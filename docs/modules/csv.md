# CSV Module

The CSV module wraps the `bin/csvql.py` helper, providing fast analytics over CSV/TSV data with DuckDB SQL and optional matplotlib plots. Session-level defaults live in environment variables so each shell can tailor its workflow without persisting changes globally.

## Overview

- Query CSV/TSV files with familiar SQL syntax (DuckDB backend)
- Automatically bootstrap a local Python virtual environment on first use
- Render scatter, line, and bar plots with matplotlib
- Manage default inputs via dedicated `csv:set:*`, `csv:get:*`, and `csv:unset:*` commands
- Optional overlays for golf hole outlines and bullseye rings

## Requirements

- macOS or Linux with Python 3.10+
- Network access during the initial bootstrap (installs DuckDB, pandas, matplotlib)

## Bootstrapping

```bash
# Install or update csvql dependencies inside ~/.caddie_modules/bin/
caddie csv:init
```

The command creates (or updates) a self-contained virtual environment next to `csvql.py` inside `~/.caddie_modules/bin`, installs the required libraries, and records pinned versions in `requirements.txt`.

> **Note:** If you skip the explicit init step, the first call to any CSV command will bootstrap automatically and then rerun your command inside the new environment.

## Commands

| Command | Description |
|---------|-------------|
| `caddie csv:init` | Build or update the local `csvql` virtual environment |
| `caddie csv:query [file] [sql] [-- flags]` | Run `csvql.py` directly with optional SQL/flags (defaults to stored values when omitted) |
| `caddie csv:scatter [file] [out.png] [-- flags]` | Create a scatter plot using current defaults and optional overrides |
| `caddie csv:list` | Display every default value in the current shell |
| `caddie csv:set:<key> <value>` | Define a default (only for this shell) |
| `caddie csv:get:<key>` | Show the current value for a key |
| `caddie csv:unset:<key>` | Clear the value for a key |

### Keys Supported

```
file, x, y, sep, plot, title, limit, save,
success_filter, scatter_filter, sql,
hole, rings, hole_x, hole_y, hole_r, ring_radii
```

Each key maps directly to an environment variable (`CADDIE_CSV_*`). Values persist only for the life of the shell, keeping concurrent terminals independent.

### Example Session

```bash
# Define defaults for this shell
caddie csv:set:file target/15ft_positions.csv
caddie csv:set:x x_position
caddie csv:set:y y_position
caddie csv:set:sql "select x_position, y_position from df where success=false"

# Review configuration
aim.csv
caddie csv:list

# Render a plot without re-specifying options
caddie csv:scatter --limit 200 --rings --ring_radii "3,6"

# Clear when finished
caddie csv:unset:file
```

Large result sets are summarised automatically: when a query returns more than 20 rows, `csvql.py` prints the first 10 and last 10 rows with an ellipsis between them so terminal history stays readable. Set `scatter_filter` or `success_filter` if you want to trim rows; leaving them unset includes the full result set.

## Plot Overlays

Enable the hole or rings overlays with `caddie csv:set:hole on` or `caddie csv:set:rings on`. Set geometry with `hole_x`, `hole_y`, `hole_r`, and ring radii using `ring_radii` (comma-separated values). These defaults propagate to `csvql.py` via environment variables.

## Output Artifacts

- Virtual environment: `~/.caddie_modules/bin/.caddie_venv`
- Resolver manifest: `~/.caddie_modules/bin/requirements.txt`

## Troubleshooting

| Symptom | Resolution |
|---------|------------|
| `csvql.py` not found | Re-run `make install-dot` so `~/.caddie_modules/bin/csvql.py` is restored |
| Bootstrap fails due to pip/network errors | Ensure network access, then rerun `caddie csv:init` |
| Scatter plot warns about missing defaults | Define required axes with `caddie csv:set:x …` and `caddie csv:set:y …` |
| DuckDB errors loading the file | Verify the separator with `caddie csv:set:sep` and confirm the CSV/TSV has a header row |

## Related Files

- `bin/csvql.py` — Python helper that powers all CSV commands
- `~/.caddie_modules/.caddie_csv` — Installed module script

With these tools you can iterate on data-driven practice plans quickly, test hypotheses with SQL, and deliver visuals suitable for coaching sessions or performance reviews.
