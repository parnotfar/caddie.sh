# Profile Module

The Profile module sources Bash profile files and appends idempotent lines to caddie-managed snippets so project setup docs can configure the shell without hand-editing `~/.bash_profile`.

## Overview

| Command | Loads |
|---------|--------|
| `caddie profile:source` | `~/.bash_profile` and `~/.bashrc` (standard login/interactive files) |
| `caddie profile:custom:source` | `~/.bash_profile-caddie-custom` and `~/.bashrc-caddie-custom` (caddie-managed snippets) |

Use `path:add` and `profile:add-line` to write to the custom files, then `profile:custom:source` to apply them in the current shell.

## Commands

### Load profiles

#### `caddie profile:source`

Source the standard Bash profile files when they exist:

- `~/.bash_profile`
- `~/.bashrc`

```bash
caddie profile:source
```

Missing files are skipped with a warning. If neither file exists, the command fails.

#### `caddie profile:custom:source`

Source caddie-managed custom snippets when they exist:

- `~/.bash_profile-caddie-custom`
- `~/.bashrc-caddie-custom`

```bash
caddie profile:custom:source
```

Use this after `path:add` or `profile:add-line` to pick up new exports without opening a new terminal.

### PATH management

#### `caddie path:add <path> [--profile caddie-custom]`

Append a PATH export to the chosen profile file. Default profile: `caddie-custom` (`~/.bash_profile-caddie-custom`).

```bash
caddie path:add "$(brew --prefix postgresql@16)/bin" --profile caddie-custom
caddie profile:custom:source
```

Writes:

```bash
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
```

If the path string is already present in the target file, caddie skips the duplicate and prints a friendly message.

#### `caddie path:add:bashrc <path>`

Same as `path:add`, but targets `~/.bashrc-caddie-custom`.

#### `caddie path:add:profile <profile> <path>`

Append a PATH export to a named profile (`caddie-custom`, `bashrc-caddie-custom`, or `bash-profile` for `~/.bash_profile`).

### Generic line append

#### `caddie profile:add-line <line> [--profile caddie-custom]`

Append any shell line idempotently (exact line match).

#### `caddie profile:add-line:bashrc <line>`

Append to `~/.bashrc-caddie-custom`.

### Information

#### `caddie profile:info`

Show supported profile targets and file paths.

#### `caddie profile:help`

Show command reference and examples.

## Typical workflow

```bash
# 1. Add PATH for Postgres (writes ~/.bash_profile-caddie-custom)
caddie path:add "$(brew --prefix postgresql@16)/bin" --profile caddie-custom

# 2. Apply custom snippets in this shell
caddie profile:custom:source

# Or reload standard profiles (includes your main ~/.bash_profile setup)
caddie profile:source
```

## Project setup documentation pattern

Instead of:

```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.bash_profile
```

Use:

```bash
caddie path:add "$(brew --prefix postgresql@16)/bin" --profile caddie-custom
caddie profile:custom:source
```

## Error handling

- Missing path or line → usage message and non-zero exit
- Unknown profile name → error listing supported profiles
- Duplicate path or line → yellow notice, no file change
- `profile:source` / `profile:custom:source` with no files found → error
