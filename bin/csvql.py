#!/usr/bin/env python3
"""Lightweight CSV/TSV SQL and plotting helper for caddie.sh."""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import textwrap
from pathlib import Path
import venv

SCRIPT_PATH = Path(__file__).resolve()
SCRIPT_DIR = SCRIPT_PATH.parent
VENV_DIR = SCRIPT_DIR / ".caddie_venv"
REQUIREMENTS_PATH = SCRIPT_DIR / "requirements.txt"
DEPENDENCIES = ["duckdb", "pandas", "matplotlib"]


def env_bool(name: str, default: bool = False) -> bool:
    value = os.environ.get(name)
    if value is None:
        return default
    return value.strip().lower() in {"1", "true", "yes", "on"}


def env_float(name: str, default: float) -> float:
    value = os.environ.get(name)
    if value is None or value.strip() == "":
        return default
    try:
        return float(value)
    except ValueError as exc:  # pragma: no cover - defensive guard
        raise SystemExit(f"Invalid float for {name}: {value}") from exc


def env_int(name: str, default: int | None) -> int | None:
    value = os.environ.get(name)
    if value is None or value.strip() == "":
        return default
    try:
        return int(value)
    except ValueError as exc:  # pragma: no cover - defensive guard
        raise SystemExit(f"Invalid integer for {name}: {value}") from exc


def get_venv_python() -> Path:
    if os.name == "nt":  # pragma: no cover - windows guard
        return VENV_DIR / "Scripts" / "python.exe"
    return VENV_DIR / "bin" / "python"


def in_project_venv() -> bool:
    try:
        return Path(sys.prefix).resolve() == VENV_DIR.resolve()
    except FileNotFoundError:
        return False


def ensure_initialized(show_next_steps: bool = True) -> bool:
    created = False
    def emit(message: str) -> None:
        stream = sys.stdout if show_next_steps else sys.stderr
        print(message, file=stream)

    if not VENV_DIR.exists():
        VENV_DIR.mkdir(parents=True, exist_ok=True)
        venv.EnvBuilder(with_pip=True).create(VENV_DIR)
        created = True
        emit(f"Created virtual environment at {VENV_DIR}")
    else:
        emit(f"Using existing virtual environment at {VENV_DIR}")
    python = get_venv_python()
    if not python.exists():
        raise SystemExit("Virtual environment bootstrap failed; python not found")
    subprocess.run([str(python), "-m", "pip", "install", "--upgrade", "pip"], check=True)
    subprocess.run([str(python), "-m", "pip", "install", "--upgrade", *DEPENDENCIES], check=True)
    freeze = subprocess.run([str(python), "-m", "pip", "freeze"], check=True, capture_output=True, text=True)
    REQUIREMENTS_PATH.write_text(freeze.stdout, encoding="utf-8")
    if show_next_steps:
        emit("Dependencies installed. Next steps:")
        emit("  • Run csvql.py <file.csv> --plot scatter --x X --y Y")
        emit("  • Use --help for full usage details")
    return created


def reexec_inside_venv(argv: list[str]) -> None:
    python = get_venv_python()
    if not python.exists():
        raise SystemExit("Virtual environment is not ready; run with --init")
    os.execv(str(python), [str(python), str(SCRIPT_PATH), *argv])


def apply_success_filter(query: str, condition: str | None) -> str:
    if not condition:
        return query
    query_body = query.strip().rstrip(";")
    lower = query_body.lower()
    split_at = len(query_body)
    for keyword in [" order by ", " group by ", " limit ", " having ", " qualify "]:
        idx = lower.find(keyword)
        if idx != -1 and idx < split_at:
            split_at = idx
    head = query_body[:split_at].rstrip()
    tail = query_body[split_at:]
    if re.search(r"\bwhere\b", head, re.IGNORECASE):
        head = f"{head} AND ({condition})"
    else:
        head = f"{head} WHERE {condition}"
    return f"{head}{tail}".strip()


def parse_ring_radii(raw: str | None) -> list[float]:
    if not raw:
        return []
    radii = []
    for chunk in raw.split(","):
        chunk = chunk.strip()
        if not chunk:
            continue
        try:
            radii.append(float(chunk))
        except ValueError as exc:
            raise SystemExit(f"Invalid ring radius: {chunk}") from exc
    return radii


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Query CSV/TSV files with DuckDB SQL and optional plotting.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("csvfile", help="Path to the CSV/TSV file")
    parser.add_argument(
        "sql_query",
        nargs="?",
        default=os.environ.get("CADDIE_CSV_SQL"),
        help="Override SQL query; defaults to SELECT * FROM df",
    )
    parser.add_argument("--init", action="store_true", help="Bootstrap or update local virtualenv and dependencies")
    parser.add_argument("--plot", choices=["scatter", "line", "bar"], default=os.environ.get("CADDIE_CSV_PLOT"))
    parser.add_argument("--x", dest="x", default=os.environ.get("CADDIE_CSV_X"), help="X-axis column for plotting")
    parser.add_argument("--y", dest="y", default=os.environ.get("CADDIE_CSV_Y"), help="Y-axis column for plotting")
    parser.add_argument("--sep", default=os.environ.get("CADDIE_CSV_SEP", ","), help="Field separator for the input file")
    parser.add_argument("--limit", type=int, default=env_int("CADDIE_CSV_LIMIT", None), help="Row limit for plotting (printing always shows full result)")
    parser.add_argument("--save", default=os.environ.get("CADDIE_CSV_SAVE"), help="Path to save plot image instead of showing it")
    parser.add_argument("--title", default=os.environ.get("CADDIE_CSV_TITLE"), help="Plot title override")
    parser.add_argument("--success-filter", default=os.environ.get("CADDIE_CSV_SUCCESS_FILTER"), help="SQL predicate to filter successful shots")
    hole_default = env_bool("CADDIE_CSV_HOLE", False)
    parser.add_argument("--hole", dest="hole", action="store_true", default=hole_default, help="Overlay hole outline on plots")
    parser.add_argument("--no-hole", dest="hole", action="store_false", help="Disable hole overlay even if enabled via environment")
    rings_default = env_bool("CADDIE_CSV_RINGS", False)
    parser.add_argument("--rings", dest="rings", action="store_true", default=rings_default, help="Overlay bullseye rings on plots")
    parser.add_argument("--no-rings", dest="rings", action="store_false", help="Disable ring overlay even if enabled via environment")
    parser.add_argument("--hole-x", type=float, default=env_float("CADDIE_CSV_HOLE_X", 0.0), help="X position for hole center")
    parser.add_argument("--hole-y", type=float, default=env_float("CADDIE_CSV_HOLE_Y", 0.0), help="Y position for hole center")
    parser.add_argument("--hole-r", type=float, default=env_float("CADDIE_CSV_HOLE_R", 4.25 / 2.0), help="Hole radius")
    parser.add_argument("--ring-radii", default=os.environ.get("CADDIE_CSV_RING_RADII"), help="Comma-separated ring radii")
    return parser.parse_args(argv)


def require_columns(columns: list[str], df_columns: list[str]) -> None:
    missing = [col for col in columns if col and col not in df_columns]
    if missing:
        raise SystemExit(f"Missing columns in result set: {', '.join(missing)}")


def maybe_plot(df, args: argparse.Namespace) -> None:
    if not args.plot:
        return
    import pandas as pd  # noqa: F401 - ensures pandas is available before plotting
    import matplotlib

    if args.save:
        matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    x_col = args.x
    y_col = args.y
    if args.plot in {"scatter", "line", "bar"}:
        if not x_col or not y_col:
            raise SystemExit("Plotting requires both --x and --y (or CADDIE_CSV_X/CADDIE_CSV_Y)")
        require_columns([x_col, y_col], list(df.columns))
    plot_df = df
    if args.limit is not None:
        if args.limit <= 0:
            raise SystemExit("--limit must be a positive integer")
        plot_df = df.head(args.limit)
    fig, ax = plt.subplots(figsize=(8, 6))
    if args.plot == "scatter":
        ax.scatter(plot_df[x_col], plot_df[y_col], alpha=0.8, edgecolor="black", linewidth=0.5)
    elif args.plot == "line":
        ax.plot(plot_df[x_col], plot_df[y_col], marker="o")
    elif args.plot == "bar":
        ax.bar(plot_df[x_col], plot_df[y_col])
    if args.title:
        ax.set_title(args.title)
    ax.set_xlabel(x_col if x_col else "")
    ax.set_ylabel(y_col if y_col else "")
    if args.hole:
        circle = plt.Circle((args.hole_x, args.hole_y), args.hole_r, fill=False, color="darkgreen", linewidth=1.5)
        ax.add_patch(circle)
        ax.set_aspect("equal", adjustable="datalim")
    if args.rings:
        for idx, radius in enumerate(parse_ring_radii(args.ring_radii), start=1):
            ring = plt.Circle((args.hole_x, args.hole_y), radius, fill=False, linestyle="--", linewidth=1.0, color="orange")
            ax.add_patch(ring)
            ax.text(args.hole_x, args.hole_y + radius, f"Ring {idx}", color="orange", fontsize=8, ha="center")
        ax.set_aspect("equal", adjustable="datalim")
    ax.grid(True, linestyle="--", alpha=0.3)
    fig.tight_layout()
    if args.save:
        fig.savefig(args.save, dpi=150)
        print(f"Saved plot to {args.save}")
    else:
        plt.show()
    plt.close(fig)


def print_dataframe(df) -> None:
    if df.empty:
        print("(no rows)")
        return
    import pandas as pd

    with pd.option_context("display.max_rows", None, "display.max_columns", None, "display.width", 0):
        print(df.to_string(index=False))


def run_query(args: argparse.Namespace) -> None:
    import duckdb

    csv_path = Path(args.csvfile).expanduser().resolve()
    if not csv_path.exists():
        raise SystemExit(f"Input file not found: {csv_path}")
    conn = duckdb.connect(database=":memory:")
    try:
        conn.execute(
            "CREATE OR REPLACE TABLE df AS SELECT * FROM read_csv_auto(?, HEADER=TRUE, SEP=?)",
            [str(csv_path), args.sep],
        )
        base_query = args.sql_query or "SELECT * FROM df"
        final_query = apply_success_filter(base_query, args.success_filter)
        df = conn.execute(final_query).df()
    finally:
        conn.close()
    print_dataframe(df)
    maybe_plot(df, args)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    if args.init:
        ensure_initialized(show_next_steps=True)
        return 0
    if not in_project_venv():
        created = False
        if not VENV_DIR.exists():
            print("Bootstrapping csvql environment...", file=sys.stderr)
            ensure_initialized(show_next_steps=False)
            created = True
        if not created:
            # dependencies may have drifted; ensure venv has them installed once
            if not get_venv_python().exists():
                ensure_initialized(show_next_steps=False)
        reexec_inside_venv(argv)
    run_query(args)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
