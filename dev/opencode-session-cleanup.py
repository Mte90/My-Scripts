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

Note: opencode.db is a live WAL database. If opencode is running, the DELETE may
wait on locks (busy_timeout=30s). Prefer running this while opencode is closed.
"""
import argparse
import os
import sqlite3
import sys
import time

DEFAULT_DB = os.path.expanduser("~/.local/share/opencode/opencode.db")

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


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--db", default=DEFAULT_DB, help=f"Path to opencode.db (default: {DEFAULT_DB})")
    parser.add_argument("--days", type=int, default=30, help="Delete sessions not updated in this many days (default: 30)")
    parser.add_argument("--force", action="store_true", help="Actually delete. Without this flag, runs in dry-run mode.")
    parser.add_argument("--vacuum", action="store_true", help="Run VACUUM after deletion to reclaim disk space (slow on large DBs).")
    parser.add_argument("--by-created", action="store_true", help="Use time_created instead of time_updated for the cutoff.")
    parser.add_argument("--list", action="store_true", help="Print the list of sessions that would be deleted.")
    args = parser.parse_args()

    if not os.path.exists(args.db):
        print(f"error: database not found: {args.db}", file=sys.stderr)
        return 1

    cutoff_ms = int((time.time() - args.days * 86400) * 1000)
    time_col = "time_created" if args.by_created else "time_updated"
    cutoff_human = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(cutoff_ms / 1000))

    # autocommit mode so VACUUM works and we control the delete transaction explicitly.
    conn = sqlite3.connect(args.db, timeout=30, isolation_level=None)
    conn.execute("PRAGMA foreign_keys = ON;")
    conn.execute("PRAGMA busy_timeout = 30000;")
    cur = conn.cursor()

    cur.execute("SELECT COUNT(*) FROM session")
    all_sessions = cur.fetchone()[0]

    cur.execute(f"SELECT COUNT(*) FROM session WHERE {time_col} < ?", (cutoff_ms,))
    to_delete = cur.fetchone()[0]

    print(f"Database:      {args.db}")
    print(f"Cutoff:        {time_col} < {args.days} days ago ({cutoff_human})")
    print(f"Mode:          {'DELETE' if args.force else 'DRY-RUN (no changes)'}")
    print(f"Total sessions: {all_sessions}")
    print(f"To delete:     {to_delete}")
    print()
    print("Dependent rows that will cascade-delete (via session_id FK):")

    subquery = f"SELECT id FROM session WHERE {time_col} < ?"
    for table, col in CASCADE_DEPENDENTS.items():
        cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({subquery})", (cutoff_ms,))
        print(f"  {table}: {cur.fetchone()[0]}")

    print()
    print("Dependent rows with no FK to session (deleted explicitly to prevent orphans):")
    for table, col in AGGREGATE_DEPENDENTS.items():
        cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {col} IN ({subquery})", (cutoff_ms,))
        print(f"  {table}: {cur.fetchone()[0]}")
    # event cascades from event_sequence, report it too
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

    if not args.force:
        print()
        print("Dry-run: no rows deleted. Re-run with --force to delete.")
        conn.close()
        return 0

    print()
    print("Deleting...")
    conn.execute("BEGIN")

    # Delete event_sequence first (cascades to event) — must run while session
    # rows still exist so the subquery can match aggregate_id = session.id.
    deleted_events = conn.execute(
        f"DELETE FROM event_sequence WHERE aggregate_id IN ({subquery})",
        (cutoff_ms,),
    ).rowcount
    print(f"  event_sequence: {deleted_events} rows (event cascades)")

    deleted = conn.execute(
        f"DELETE FROM session WHERE {time_col} < ?", (cutoff_ms,)
    ).rowcount
    print(f"  session: {deleted} rows (7 tables cascade)")

    conn.execute("COMMIT")
    print(f"Deleted {deleted} sessions.")

    if args.vacuum:
        print("Running VACUUM (this may take a while on a large DB)...")
        conn.execute("VACUUM")
        print("VACUUM done.")

    conn.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
