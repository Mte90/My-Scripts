#!/usr/bin/env python3
"""Delete opencode sessions older than N days from the SQLite database.

By default runs in DRY-RUN mode: reports what would be deleted without changing
anything. Pass --force to actually delete.

Cutoff uses session.time_updated (last touched). A session created long ago but
updated recently is kept. Use --by-created to switch to time_created.

Cascade chain (all via ON DELETE CASCADE foreign keys, requires PRAGMA
foreign_keys = ON which this script sets):

    DELETE FROM session
      -> message          (FK session_id -> session.id, CASCADE)
         -> part          (FK message_id -> message.id, CASCADE)
      -> session_message (FK session_id -> session.id, CASCADE)
      -> session_input   (FK session_id -> session.id, CASCADE)
      -> session_context_epoch (FK session_id -> session.id, CASCADE)
      -> todo            (FK session_id -> session.id, CASCADE)
      -> session_share   (FK session_id -> session.id, CASCADE)

The event_sequence and event tables use aggregate_id = session.id but have NO
foreign key to session, so they do NOT cascade. This script deletes them
explicitly in the same transaction to prevent orphans:

    DELETE FROM event_sequence WHERE aggregate_id IN (deleted session ids)
      -> event            (FK aggregate_id -> event_sequence.aggregate_id, CASCADE)

Default mode auto-syncs magic-context: after deleting stale sessions from
opencode.db, the script cross-checks the magic-context DB (if it exists) and
purges orphan sessions (session_ids present in MC but absent from opencode.db)
and dead projects (projects with no remaining sessions).

Note: opencode.db is a live WAL database. If opencode is running, the DELETE may
wait on locks (busy_timeout=30s). Prefer running this while opencode is closed.

--magic-context mode:
Purges data from the magic-context knowledge DB (~/.local/share/cortexkit/magic-context/context.db)
for projects not touched in > N days. Uses project_path keys (opaque strings like
"dir:<hexhash>" or "git:<hexhash>"), NOT filesystem paths.

Excludes the sentinel project_path "__global__" (GLOBAL_USER_PROFILE_PROJECT_PATH)
which must never be deleted. Skips FTS5 tables and their shadow tables.

Introspects schema at runtime: tables with project_path column are project-scoped,
tables with only session_id column are session-scoped. Deletes session-scoped rows
first, then project-scoped rows, all in one transaction when --force is given.
"""
import argparse
import os
import sqlite3
import sys
import time

DEFAULT_DB = os.path.expanduser("~/.local/share/opencode/opencode.db")
MC_DEFAULT_DB = os.path.expanduser("~/.local/share/cortexkit/magic-context/context.db")
MC_SENTINEL_PROJECT_PATH = "__global__"

# Tables that cascade-delete via session_id FK — shown for reporting only.
CASCADE_DEPENDENTS = {
    "session_message": "session_id",
    "message": "session_id",
    "part": "session_id",
    "session_context_epoch": "session_id",
    "session_input": "session_id",
    "todo": "session_id",
    "session_share": "session_id",
}

# event_sequence has no FK to session but its aggregate_id = session.id.
# Must be deleted explicitly; event cascades from event_sequence.
AGGREGATE_DEPENDENTS = {
    "event_sequence": "aggregate_id",
}


def is_fts_table(name):
    """Check if table name matches FTS5 or shadow table patterns."""
    if ".fts" in name:
        return True
    if name.endswith("_fts"):
        return True
    if name.endswith("_content"):
        return True
    if name.endswith("_data"):
        return True
    if name.endswith("_idx"):
        return True
    if name.endswith("_doclist"):
        return True
    if name.endswith("_config"):
        return True
    return False


def get_tables_with_columns(conn):
    """
    Introspect schema and classify tables by which target columns they have.
    Returns (project_scoped, session_scoped) where each is a list of (table_name, column_name).
    project_scoped: has project_path column (but not session_id)
    session_scoped: has session_id column (tables with both session_id and project_path go here)
    """
    cur = conn.cursor()
    cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite\\_%'")
    all_tables = [row[0] for row in cur.fetchall()]

    project_scoped = []
    session_scoped = []

    for table in all_tables:
        if is_fts_table(table):
            continue
        cur.execute(f"PRAGMA table_info({table})")
        cols = {row[1] for row in cur.fetchall()}
        if "session_id" in cols:
            # Tables with session_id go here, even if they also have project_path
            session_scoped.append((table, "session_id"))
        elif "project_path" in cols:
            project_scoped.append((table, "project_path"))

    return project_scoped, session_scoped


def has_session_projects(conn):
    cur = conn.cursor()
    cur.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name='session_projects'")
    return cur.fetchone() is not None


def sync_magic_context(conn_oc, mc_path, args, force, pending_deletes=None):
    """
    Cross-check opencode.db against magic-context DB.
    Purge orphan sessions (in MC but not in opencode) and dead projects.
    Returns (orphan_count, dead_project_count, table_counts, mc_conn) or (0, 0, {}, None) on warning.
    """
    if not os.path.exists(mc_path):
        print(f"warning: magic-context DB not found at {mc_path}, skipping cross-check")
        return 0, 0, {}, None

    try:
        mc_conn = sqlite3.connect(mc_path, timeout=30, isolation_level=None)
        mc_conn.execute("PRAGMA foreign_keys = ON;")
        mc_conn.execute("PRAGMA busy_timeout = 30000;")
    except sqlite3.OperationalError as e:
        print(f"warning: magic-context DB locked or inaccessible: {e}, skipping cross-check")
        return 0, 0, {}, None

    mc_cur = mc_conn.cursor()

    if not has_session_projects(mc_conn):
        print(f"warning: magic-context DB has no session_projects table at {mc_path}, skipping cross-check")
        return 0, 0, {}, None

    # Get all session_ids in opencode.db (source of truth). In dry-run the stale
    # sessions are not yet deleted, so subtract the pending set to preview the
    # post-deletion state.
    cur = conn_oc.cursor()
    cur.execute("SELECT id FROM session")
    opencode_sessions = {row[0] for row in cur.fetchall()} - set(pending_deletes or ())

    # Get all session_ids in MC's session_projects
    mc_cur.execute("SELECT DISTINCT session_id FROM session_projects")
    mc_sessions = {row[0] for row in mc_cur.fetchall()}

    # Orphans: in MC but not in opencode
    orphan_sessions = mc_sessions - opencode_sessions

    # Count orphan rows per session-scoped table
    project_scoped_tables, session_scoped_tables = get_tables_with_columns(mc_conn)

    table_counts = {}
    for table, col in session_scoped_tables:
        if orphan_sessions:
            placeholders = ",".join("?" * len(orphan_sessions))
            mc_cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({placeholders})", list(orphan_sessions))
        else:
            mc_cur.execute("SELECT COUNT(*) FROM session_projects WHERE 1=0")
        table_counts[table] = mc_cur.fetchone()[0]

    # Find connected projects (at least one session that is not an orphan)
    mc_cur.execute("SELECT DISTINCT session_id, project_path FROM session_projects")
    connected_projects = {
        row[1] for row in mc_cur.fetchall() if row[1] and row[0] not in orphan_sessions
    }

    # Dead projects: all project_paths in project-scoped tables minus connected, minus sentinel
    all_project_paths = set()
    for table, col in project_scoped_tables:
        mc_cur.execute(f"SELECT DISTINCT {col} FROM {table} WHERE {col} IS NOT NULL")
        for row in mc_cur.fetchall():
            if row[0] and row[0] != MC_SENTINEL_PROJECT_PATH:
                all_project_paths.add(row[0])

    dead_projects = (all_project_paths - connected_projects - {MC_SENTINEL_PROJECT_PATH}) - {None}

    # Count dead project rows per project-scoped table
    for table, col in project_scoped_tables:
        if dead_projects:
            placeholders = ",".join("?" * len(dead_projects))
            mc_cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({placeholders})", list(dead_projects))
        else:
            mc_cur.execute("SELECT COUNT(*) FROM session_projects WHERE 1=0")
        table_counts[table] = mc_cur.fetchone()[0]

    print()
    print("Magic-context cross-check:")
    print(f"  Orphan sessions: {len(orphan_sessions)}")
    print(f"  Dead projects: {len(dead_projects)}")
    print()

    if args.list and (orphan_sessions or dead_projects):
        if orphan_sessions:
            print("  Orphan session IDs:")
            for sid in sorted(orphan_sessions)[:20]:
                print(f"    {sid}")
            if len(orphan_sessions) > 20:
                print(f"    ... and {len(orphan_sessions) - 20} more")
        if dead_projects:
            print("  Dead project paths:")
            for proj in sorted(dead_projects):
                print(f"    {proj}")
        print()

    print("  Rows that will be deleted:")
    for table, col in session_scoped_tables:
        count = table_counts.get(table, 0)
        if count > 0:
            print(f"    {table} ({col}): {count}")
    for table, col in project_scoped_tables:
        count = table_counts.get(table, 0)
        if count > 0:
            print(f"    {table} ({col}): {count}")

    if not force:
        return len(orphan_sessions), len(dead_projects), table_counts, mc_conn

    # Actually delete
    print()
    print("Deleting magic-context orphans and dead projects...")
    mc_conn.execute("BEGIN")

    total_deleted = 0

    # Delete session-scoped rows (orphans)
    for table, col in session_scoped_tables:
        if orphan_sessions:
            placeholders = ",".join("?" * len(orphan_sessions))
            deleted = mc_conn.execute(
                f"DELETE FROM {table} WHERE {col} IN ({placeholders})",
                list(orphan_sessions)
            ).rowcount
            if deleted > 0:
                print(f"    {table}: {deleted} rows")
                total_deleted += deleted

    # Delete project-scoped rows (dead projects)
    for table, col in project_scoped_tables:
        if dead_projects:
            placeholders = ",".join("?" * len(dead_projects))
            deleted = mc_conn.execute(
                f"DELETE FROM {table} WHERE {col} IN ({placeholders})",
                list(dead_projects)
            ).rowcount
            if deleted > 0:
                print(f"    {table}: {deleted} rows")
                total_deleted += deleted

    mc_conn.execute("COMMIT")
    print(f"  Total: {total_deleted} rows deleted.")

    return len(orphan_sessions), len(dead_projects), table_counts, mc_conn


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--db", default=None, help="Path to database (default: opencode.db or magic-context DB with --magic-context)")
    parser.add_argument("--mc-db", default=None, help="Path to magic-context DB for cross-check (default: ~/.local/share/cortexkit/magic-context/context.db)")
    parser.add_argument("--days", type=int, default=30, help="Delete sessions not updated in this many days (default: 30)")
    parser.add_argument("--force", action="store_true", help="Actually delete. Without this flag, runs in dry-run mode.")
    parser.add_argument("--vacuum", action="store_true", help="Run VACUUM after deletion to reclaim disk space (slow on large DBs).")
    parser.add_argument("--by-created", action="store_true", help="Use time_created instead of time_updated for the cutoff.")
    parser.add_argument("--list", action="store_true", help="Print the list of sessions that would be deleted.")
    parser.add_argument("--magic-context", action="store_true", help="Target magic-context knowledge DB instead of opencode.db")
    args = parser.parse_args()

    # Determine default DB based on mode
    if args.db is None:
        args.db = MC_DEFAULT_DB if args.magic_context else DEFAULT_DB

    if not os.path.exists(args.db):
        print(f"error: database not found: {args.db}", file=sys.stderr)
        return 1

    cutoff_ms = int((time.time() - args.days * 86400) * 1000)
    cutoff_human = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(cutoff_ms / 1000))

    # autocommit mode so VACUUM works and we control the delete transaction explicitly.
    conn = sqlite3.connect(args.db, timeout=30, isolation_level=None)
    conn.execute("PRAGMA foreign_keys = ON;")
    conn.execute("PRAGMA busy_timeout = 30000;")
    cur = conn.cursor()

    if args.magic_context:
        # Magic-context mode: stale project_path based on session_projects.updated_at
        if not has_session_projects(conn):
            print(f"warning: magic-context DB has no session_projects table at {args.db}, nothing to clean")
            stale_projects = set()
            stale_sessions = set()
        else:
            cur.execute(
                "SELECT project_path, MAX(updated_at) FROM session_projects "
                "GROUP BY project_path HAVING MAX(updated_at) < ?",
                (cutoff_ms,)
            )
            stale_projects = {row[0] for row in cur.fetchall() if row[0] != MC_SENTINEL_PROJECT_PATH}

            # Get stale session_ids belonging to stale projects
            if stale_projects:
                placeholders = ",".join("?" * len(stale_projects))
                cur.execute(
                    f"SELECT DISTINCT session_id FROM session_projects WHERE project_path IN ({placeholders})",
                    list(stale_projects)
                )
                stale_sessions = {row[0] for row in cur.fetchall()}
            else:
                stale_sessions = set()

        # Introspect schema
        project_scoped_tables, session_scoped_tables = get_tables_with_columns(conn)

        # Count rows per table
        table_counts = {}
        for table, col in session_scoped_tables:
            if stale_sessions:
                cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({','.join('?'*len(stale_sessions))})", list(stale_sessions))
            else:
                cur.execute(f"SELECT COUNT(*) FROM {table} WHERE 1=0")  # Always 0
            table_counts[table] = cur.fetchone()[0]

        for table, col in project_scoped_tables:
            if stale_projects:
                cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({','.join('?'*len(stale_projects))})", list(stale_projects))
            else:
                cur.execute(f"SELECT COUNT(*) FROM {table} WHERE 1=0")  # Always 0
            table_counts[table] = cur.fetchone()[0]

        print(f"Database:      {args.db}")
        print(f"Mode:          magic-context (project cleanup)")
        print(f"Cutoff:        updated_at < {args.days} days ago ({cutoff_human})")
        print(f"Stale projects: {len(stale_projects)} (excludes sentinel: {MC_SENTINEL_PROJECT_PATH})")
        print(f"Stale sessions: {len(stale_sessions)}")
        print()

        if args.list and stale_projects:
            print("Stale projects:")
            for proj_path in sorted(stale_projects):
                cur.execute(
                    "SELECT MAX(updated_at) FROM session_projects WHERE project_path = ?",
                    (proj_path,)
                )
                max_ts = cur.fetchone()[0]
                max_human = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(max_ts / 1000))
                print(f"  {proj_path}  (last activity: {max_human})")
            print()

        print("Rows that will be deleted:")
        # Session-scoped first
        for table, col in session_scoped_tables:
            count = table_counts.get(table, 0)
            if count > 0:
                print(f"  {table} ({col}): {count}")
        # Then project-scoped
        for table, col in project_scoped_tables:
            count = table_counts.get(table, 0)
            if count > 0:
                print(f"  {table} ({col}): {count}")

        if not args.force:
            print()
            print("Dry-run: no rows deleted. Re-run with --force to delete.")
            conn.close()
            return 0

        print()
        print("Deleting...")
        conn.execute("BEGIN")

        total_deleted = 0
        # Delete session-scoped rows first
        for table, col in session_scoped_tables:
            if stale_sessions:
                deleted = conn.execute(
                    f"DELETE FROM {table} WHERE {col} IN ({','.join('?'*len(stale_sessions))})",
                    list(stale_sessions)
                ).rowcount
                if deleted > 0:
                    print(f"  {table}: {deleted} rows")
                    total_deleted += deleted

        # Then delete project-scoped rows
        for table, col in project_scoped_tables:
            if stale_projects:
                deleted = conn.execute(
                    f"DELETE FROM {table} WHERE {col} IN ({','.join('?'*len(stale_projects))})",
                    list(stale_projects)
                ).rowcount
                if deleted > 0:
                    print(f"  {table}: {deleted} rows")
                    total_deleted += deleted

        conn.execute("COMMIT")
        print(f"Total: {total_deleted} rows deleted.")

        if args.vacuum:
            print("Running VACUUM (this may take a while on a large DB)...")
            conn.execute("VACUUM")
            print("VACUUM done.")

        conn.close()
        return 0

    # Original opencode.db mode
    cur.execute("SELECT COUNT(*) FROM session")
    all_sessions = cur.fetchone()[0]

    time_col = "time_created" if args.by_created else "time_updated"
    cur.execute(f"SELECT COUNT(*) FROM session WHERE {time_col} < ?", (cutoff_ms,))
    to_delete = cur.fetchone()[0]

    print(f"Database:      {args.db}")
    print(f"Cutoff:        {time_col} < {args.days} days ago ({cutoff_human})")
    print(f"Mode:          {'DELETE' if args.force else 'DRY-RUN (no changes)'}")
    print(f"Total sessions: {all_sessions}")
    print(f"To delete:     {to_delete}")
    print()
    existing_tables = {row[0] for row in cur.execute(
        "SELECT name FROM sqlite_master WHERE type='table'"
    ).fetchall()}
    cascade_count = sum(1 for t in CASCADE_DEPENDENTS if t in existing_tables)

    print("Dependent rows that will cascade-delete (via session_id FK):")

    subquery = f"SELECT id FROM session WHERE {time_col} < ?"
    for table, col in CASCADE_DEPENDENTS.items():
        if table not in existing_tables:
            continue
        cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({subquery})", (cutoff_ms,))
        print(f"  {table}: {cur.fetchone()[0]}")

    print()
    print("Dependent rows with no FK to session (deleted explicitly to prevent orphans):")
    for table, col in AGGREGATE_DEPENDENTS.items():
        if table not in existing_tables:
            continue
        cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({subquery})", (cutoff_ms,))
        print(f"  {table}: {cur.fetchone()[0]}")
    # event cascades from event_sequence, report it too (only if both tables exist)
    if "event" in existing_tables and "event_sequence" in existing_tables:
        cur.execute(
            f"SELECT COUNT(*) FROM event WHERE aggregate_id IN "
            f"(SELECT aggregate_id FROM event_sequence WHERE aggregate_id IN ({subquery}))",
            (cutoff_ms,),
        )
        print(f"  event (cascades from event_sequence): {cur.fetchone()[0]}")

    if args.list and to_delete > 0:
        print()
        print(f"Sessions to delete ({to_delete}):")
        cur.execute(
            f"SELECT id, title, datetime({time_col}/1000, 'unixepoch'), directory "
            f"FROM session WHERE {time_col} < ? ORDER BY {time_col} ASC",
            (cutoff_ms,),
        )
        for sid, title, when, directory in cur.fetchall():
            title_short = (title or "").strip().replace("\n", " ")
            if len(title_short) > 80:
                title_short = title_short[:77] + "..."
            print(f"  {when}  {sid:<36}  {title_short}")
            if directory:
                print(f"           {directory}")

    # Magic-context cross-check: preview in dry-run (subtracting sessions that
    # are about to be deleted), real sync after the opencode.db commit.
    mc_db_path = args.mc_db if args.mc_db else MC_DEFAULT_DB

    if not args.force:
        cur.execute(f"SELECT id FROM session WHERE {time_col} < ?", (cutoff_ms,))
        pending_deletes = {row[0] for row in cur.fetchall()}
        _, _, _, mc_conn = sync_magic_context(
            conn, mc_db_path, args, force=False, pending_deletes=pending_deletes
        )
        print()
        print("Dry-run: no rows deleted. Re-run with --force to delete.")
        conn.close()
        if mc_conn:
            mc_conn.close()
        return 0

    # Delete stale sessions from opencode.db
    print()
    print("Deleting...")
    conn.execute("BEGIN")

    # Delete event_sequence first (cascades to event) — must run while session
    # rows still exist so the subquery can match aggregate_id = session.id.
    deleted_events = 0
    if "event_sequence" in existing_tables:
        deleted_events = conn.execute(
            f"DELETE FROM event_sequence WHERE aggregate_id IN ({subquery})",
            (cutoff_ms,),
        ).rowcount
    print(f"  event_sequence: {deleted_events} rows (event cascades)")

    deleted = conn.execute(
        f"DELETE FROM session WHERE {time_col} < ?", (cutoff_ms,)
    ).rowcount
    print(f"  session: {deleted} rows ({cascade_count} tables cascade)")

    conn.execute("COMMIT")
    print(f"Deleted {deleted} sessions.")

    # Now do the magic-context cross-check with force
    orphan_count, dead_count, mc_table_counts, mc_conn = sync_magic_context(
        conn, mc_db_path, args, force=True
    )
    if mc_conn:
        mc_conn.close()

    if args.vacuum:
        print("Running VACUUM (this may take a while on a large DB)...")
        conn.execute("VACUUM")
        print("VACUUM done.")

    conn.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())