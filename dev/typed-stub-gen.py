#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
create_stubs.py — Generate .pyi stubs and py.typed markers for packages in a virtualenv.
"""
from __future__ import annotations
import argparse, csv, os, shutil, subprocess, sys, tempfile
from pathlib import Path
from typing import Iterable, List, Optional

def _txt(p: Path) -> Optional[str]:
    try: return p.read_text(encoding="utf-8", errors="ignore")
    except Exception: return None

def _norm(s: Optional[str]) -> str:
    return (s or "").strip().lower().replace("_", "-").replace(".", "-")

def find_venv(provided: Optional[str]) -> Path:
    if provided:
        p = Path(provided)
        if p.exists(): return p.resolve()
        print(f"ERROR: venv not found: {provided}", file=sys.stderr); sys.exit(1)
    if os.environ.get("VIRTUAL_ENV"): return Path(os.environ["VIRTUAL_ENV"]).resolve()
    cwd = Path.cwd()
    for parent in (cwd, *cwd.parents):
        cand = parent / ".venv"
        if cand.is_dir(): return cand.resolve()
    return Path(sys.prefix).resolve()

def venv_site_packages(venv: Path) -> Path:
    ver = f"{sys.version_info.major}.{sys.version_info.minor}"
    candidates = ([venv / "Lib" / "site-packages"] if os.name == "nt" else
                  [venv / "lib" / f"python{ver}" / "site-packages", venv / "lib" / f"python{ver}" / "dist-packages"])
    candidates.append(venv / "site-packages")
    for c in candidates:
        if c.is_dir(): return c.resolve()
    print("ERROR: cannot find site-packages in venv", file=sys.stderr); sys.exit(1)

def iter_dist_infos(site_packages: Path) -> Iterable[Path]:
    for p in site_packages.iterdir():
        if p.name.endswith((".dist-info", ".egg-info")): yield p

def dist_name_from_metadata(di: Path) -> str:
    for meta in ("METADATA", "PKG-INFO"):
        t = _txt(di / meta)
        if t:
            for line in t.splitlines():
                if line.startswith("Name:"):
                    return line.split(":",1)[1].strip()
    name = di.name
    for suf in (".dist-info", ".egg-info"):
        if name.endswith(suf): return name[:-len(suf)]
    return name

def list_package_files(site_packages: Path, name: str) -> List[str]:
    res: List[str] = []
    pkg = site_packages / name
    if pkg.exists():
        for f in pkg.rglob("*"):
            if f.is_file():
                try: res.append(str(f.relative_to(site_packages)))
                except Exception: res.append(str(f))
    mod = site_packages / f"{name}.py"
    if mod.exists(): res.append(str(mod.relative_to(site_packages)))
    return res

def list_installed_files(di: Path) -> List[str]:
    rec = di / "RECORD"
    txt = _txt(rec)
    if txt is not None:
        try:
            return [row[0] for row in csv.reader(txt.splitlines()) if row]
        except Exception:
            pass
    top = _txt(di / "top_level.txt")
    if top:
        out: List[str] = []
        for line in top.splitlines():
            n = line.strip()
            if n: out.extend(list_package_files(di.parent, n))
        return out
    stem = di.name.split("-")[0]
    return list_package_files(di.parent, stem)

def dist_has_typing(di: Path, site_packages: Path) -> bool:
    for f in list_installed_files(di):
        if f.endswith("py.typed") or f.endswith(".pyi"): return True
    name = dist_name_from_metadata(di)
    for cand in (name, name.replace("-", "_")):
        p = site_packages / cand
        if p.exists():
            if any(pp.suffix == ".pyi" for pp in p.rglob("*.pyi")): return True
            if (p / "py.typed").exists(): return True
    return False

def has_types_package(dist_name: str, site_packages: Path) -> bool:
    t = _norm(dist_name)
    for di in iter_dist_infos(site_packages):
        nm = dist_name_from_metadata(di)
        if not nm: continue
        n = _norm(nm)
        if n in (f"types-{t}", f"{t}-stubs"): return True
    return False

def mypy_installed(site_packages: Path) -> bool:
    target = _norm("mypy")
    for di in iter_dist_infos(site_packages):
        nm = dist_name_from_metadata(di)
        if nm and _norm(nm) == target: return True
    return False

def _run(cmd: List[str]) -> bool:
    try:
        p = subprocess.run(cmd, check=True, capture_output=True, text=True)
        if p.stdout: print(p.stdout, end="")
        if p.stderr: print(p.stderr, end="", file=sys.stderr)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Command failed ({e.returncode}): {' '.join(cmd)}", file=sys.stderr)
        if e.stdout: print("STDOUT:", e.stdout, file=sys.stderr)
        if e.stderr: print("STDERR:", e.stderr, file=sys.stderr)
        return False
    except FileNotFoundError:
        return False

def try_stub_exec(stub_exec: Path, package: str, outdir: Path) -> bool:
    if not stub_exec.exists(): return False
    return _run([str(stub_exec), "-p", package, "-o", str(outdir)])

def try_module(py: Path, package: str, outdir: Path) -> bool:
    cmd = [str(py), "-m", "mypy.stubgen", "-p", package, "-o", str(outdir)]
    print("Trying python -m mypy.stubgen:", " ".join(cmd))
    return _run(cmd)

def generate_stub(py: Path, stub_exec: Path, package: str) -> Optional[Path]:
    """Create a non-auto-deleted temp dir, run stubgen into it, and return its Path (caller must cleanup)."""
    tmpdir = tempfile.mkdtemp(prefix="stubgen-")
    tmp = Path(tmpdir)
    try:
        if try_stub_exec(stub_exec, package, tmp): return tmp
        if try_module(py, package, tmp): return tmp
        shutil.rmtree(tmp, ignore_errors=True)
        return None
    except Exception:
        shutil.rmtree(tmp, ignore_errors=True)
        return None

def write_py_typed(root: Path) -> None:
    try:
        if any(root.rglob("*.pyi")):
            p = root / "py.typed"
            if not p.exists():
                try: p.write_text("partial\n", encoding="utf-8")
                except Exception as e: print(f"Failed to write {p}: {e}", file=sys.stderr)
    except Exception:
        pass

def main():
    ap = argparse.ArgumentParser(description="Generate .pyi stubs for packages in a virtualenv")
    ap.add_argument("--venv", help="Path to virtualenv (default: VIRTUAL_ENV or .venv or sys.prefix)")
    ap.add_argument("--out", help="Output dir relative to venv (default: <venv>/stubs)")
    ap.add_argument("--exclude", nargs="*", help="Packages to exclude", default=[])
    args = ap.parse_args()

    venv = find_venv(args.venv)
    site = venv_site_packages(venv)
    py = (venv / "Scripts" / "python.exe") if os.name == "nt" else (venv / "bin" / "python")
    stub_exec = (venv / "Scripts" / "stubgen.exe") if os.name == "nt" else (venv / "bin" / "stubgen")

    if not py.exists():
        print(f"ERROR: python not found in venv: {py}", file=sys.stderr); sys.exit(1)
    if not mypy_installed(site):
        print("ERROR: mypy not installed in venv (no mypy dist-info).", file=sys.stderr)
        print(f"Install: {py} -m pip install mypy", file=sys.stderr)
        sys.exit(1)

    out_root = Path(args.out) if args.out else (venv / "stubs")
    exclude = set(args.exclude or [])
    scanned = generated = 0
    created = False

    for di in iter_dist_infos(site):
        name = dist_name_from_metadata(di)
        if not name:
            continue
        if name in exclude:
            print(f"Skipping excluded: {name}")
            continue
        scanned += 1
        print(f"\n-- {name} --")
        if dist_has_typing(di, site):
            print("  -> typing info present. Skipping."); continue
        if has_types_package(name, site):
            print("  -> types package installed. Skipping."); continue
        print("  -> generating stubs.")
        tmp = generate_stub(py, stub_exec, name)
        if not tmp:
            print(f"Failed to generate stubs for {name}", file=sys.stderr); continue
        if not created:
            try: out_root.mkdir(parents=True, exist_ok=True); created = True
            except Exception as e:
                print(f"Failed to create {out_root}: {e}", file=sys.stderr)
                shutil.rmtree(tmp, ignore_errors=True)
                continue
        tgt = out_root / name
        if tgt.exists():
            try:
                tgt.unlink() if tgt.is_file() else shutil.rmtree(tgt)
            except Exception as e:
                print(f"Failed to remove existing {tgt}: {e}", file=sys.stderr)
                shutil.rmtree(tmp, ignore_errors=True)
                continue
        moved = False
        try:
            tgt.mkdir(parents=True, exist_ok=True)
            for ent in tmp.iterdir():
                try: shutil.move(str(ent), str(tgt / ent.name)); moved = True
                except Exception as e: print(f"Move failed {ent}: {e}", file=sys.stderr)
            if moved:
                write_py_typed(tgt); generated += 1
            else:
                print(f"No files produced for {name}", file=sys.stderr)
                if tgt.exists(): shutil.rmtree(tgt, ignore_errors=True)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)

    print(f"\nScanned: {scanned}. Stubs generated: {generated}. Output: {out_root if created else '(none created)'}")

if __name__ == "__main__":
    main()
