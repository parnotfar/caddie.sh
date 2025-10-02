# CSV Module

The CSV module wraps the `bin/csvql.py` helper, providing fast analytics over CSV/TSV data with DuckDB SQL and optional matplotlib plots. Persistent configuration commands let you store defaults without juggling environment variables, making it ideal for shot-tracking workflows where you want repeatable analysis and visuals.

## Overview

- Query CSV/TSV files with familiar SQL syntax (DuckDB backend)
- Automatically bootstrap a local Python virtual environment on first use
- Render scatter, line, and bar plots with matplotlib
- Store reusable defaults (axes, filters, overlays, etc.) via `csv:config:*`
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
| `caddie csv:help` | Show module summary and available commands |
| `caddie csv:init` | Build or update the local `csvql` virtual environment |
| `caddie csv:query <file.csv> [sql] [-- flags]` | Run `csvql.py` directly with optional SQL/flags (defaults to stored file if omitted) |
| `caddie csv:scatter <file.csv> [out.png] [-- flags]` | Create a scatter plot using module defaults and optional overrides (uses stored file if omitted) |
| `caddie csv:config:set <key> <value>` | Persist a default (axes, filters, overlays, etc.) |
| `caddie csv:config:get <key>` | Show the current value for a stored default |
| `caddie csv:config:unset <key>` | Remove a stored value and fall back to script defaults |
| `caddie csv:config:list` | Display all stored defaults |

### `csv:query`

```bash
# Print all rows
caddie csv:query data/aim.csv

# Run a custom query and plot a line chart
caddie csv:query data/aim.csv "SELECT target_x, target_y FROM df WHERE club = '7i'" \
  --plot line --x target_x --y target_y
```

### `csv:scatter`

```bash
# Quick plot using stored defaults
caddie csv:scatter data/aim.csv

# Save output and narrow to the last 200 swings
caddie csv:scatter data/aim.csv visuals/last-200.png --limit 200
```

The scatter helper ensures required axes are set, applies a reusable success filter (defaults to `success = FALSE`), and respects any additional CLI flags you supply.

### `csv:config:*`

Configuration commands write to `~/.caddie_data/csv_config` and are automatically sourced before every CSV invocation. You never need to remember the underlying environment variable names—use concise keys instead:

| Key | Underlying Env Var | Description |
|-----|--------------------|-------------|
| `file` | `CADDIE_CSV_FILE` | Default CSV/TSV file path |
| `x`, `y` | `CADDIE_CSV_X`, `CADDIE_CSV_Y` | Default plotting axes |
| `sep` | `CADDIE_CSV_SEP` | CSV/TSV separator (`,` or `\t`) |
| `plot` | `CADDIE_CSV_PLOT` | Default plot type (`scatter`, `line`, `bar`) |
| `title` | `CADDIE_CSV_TITLE` | Plot title override |
| `limit` | `CADDIE_CSV_LIMIT` | Row limit applied to plots |
| `save` | `CADDIE_CSV_SAVE` | Default output image path |
| `success-filter` | `CADDIE_CSV_SUCCESS_FILTER` | Predicate defining a “successful” shot |
| `scatter-filter` | `CADDIE_CSV_SCATTER_FILTER` | Filter automatically applied by `csv:scatter` |
| `sql` | `CADDIE_CSV_SQL` | Default SQL query when none is supplied |
| `hole`, `hole:x`, `hole:y`, `hole:r` | `CADDIE_CSV_HOLE*` | Hole overlay toggle and geometry |
| `rings` | `CADDIE_CSV_RINGS` | Enable/disable bullseye rings |
| `ring:radii` | `CADDIE_CSV_RING_RADII` | Comma-separated ring radii |

Example usage:

```bash
caddie csv:config:set file ~/work/data/aim.csv
caddie csv:config:set x aim_offset_x
caddie csv:config:set y aim_offset_y
caddie csv:config:set scatter-filter "miss = FALSE"
caddie csv:config:list
```

Once `file` is set, the active path appears in the shell prompt as `[csv:…]`, mirroring the GitHub account indicator so you always know which dataset is targeted.

## Persistent Defaults vs. Environment Variables

The module stores defaults in `~/.caddie_data/csv_config` (created automatically the first time you save a value); each entry is exported as the corresponding `CADDIE_CSV_*` environment variable when commands run. Advanced users can still override settings ad hoc by exporting environment variables or passing CLI flags—module defaults simply provide a safer, easier baseline.

## Plot Overlays

Enabling the hole or rings overlay draws circles centered on `hole:x`/`hole:y`. This helps visualize dispersion patterns and target rings. Combine `ring:radii` with `rings=true` to annotate concentric scoring zones.

## Output Artifacts

- Virtual environment: `~/.caddie_modules/bin/.caddie_venv`
- Resolver manifest: `~/.caddie_modules/bin/requirements.txt`
- Module configuration: `~/.caddie_data/csv_config`
- Default plots (when `save` is set): stored wherever the `save` path resolves

## Troubleshooting

| Symptom | Resolution |
|---------|------------|
| `csvql.py` not found | Re-run `make install-dot` so `~/.caddie_modules/bin/csvql.py` is recreated, or set `CADDIE_HOME` to the caddie.sh checkout |
| Bootstrap fails due to pip/network errors | Ensure you have network access, then rerun `caddie csv:init` |
| Plot command exits with “Set csv defaults for 'x' and 'y'” | Define the required axes using `caddie csv:config:set x ...` and `caddie csv:config:set y ...` |
| DuckDB errors loading the file | Verify the separator via `csv:config:get sep` and confirm the CSV/TSV has a header row |

## Related Files

- `bin/csvql.py` — Python helper that powers all CSV commands
- `~/.caddie_modules/.caddie_csv` — Installed module script
- `~/.caddie_modules/bin/` — Deployed helper scripts and virtual environment assets
- `~/.caddie_data/csv_config` — Stored defaults consumed by every csv command

With these tools you can iterate on data-driven practice plans quickly, test hypotheses with SQL, and deliver visuals suitable for coaching sessions or performance reviews.
