# Profile Module

The Profile module appends idempotent lines to caddie-managed Bash profile snippets so project setup docs can configure the shell without telling users to hand-edit `~/.bash_profile`.

## Overview

Caddie loads optional custom snippets via `caddie git:custom:source`:

- `~/.bash_profile-caddie-custom` — default target for login-shell additions
- `~/.bashrc-caddie-custom` — interactive bashrc additions

The Profile module (`caddie profile:<command>` and `caddie path:<command>`) writes to those files safely. It does **not** modify `~/.zshrc` or `~/.bash_profile` unless you explicitly choose the `bash-profile` target.

## Commands

### PATH management

#### `caddie path:add <path> [--profile caddie-custom]`

Append a PATH export to the chosen profile file. Default profile: `caddie-custom` (`~/.bash_profile-caddie-custom`).

```bash
caddie path:add "$(brew --prefix postgresql@16)/bin" --profile caddie-custom
caddie git:custom:source
```

Writes:

```bash
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
```

If the path string is already present in the target file, caddie skips the duplicate and prints a friendly message.

#### `caddie path:add:bashrc <path>`

Same as `path:add`, but targets `~/.bashrc-caddie-custom`.

```bash
caddie path:add:bashrc /opt/local/bin
```

#### `caddie path:add:profile <profile> <path>`

Append a PATH export to a named profile:

| Profile name | File |
|--------------|------|
| `caddie-custom` | `~/.bash_profile-caddie-custom` |
| `bashrc-caddie-custom` | `~/.bashrc-caddie-custom` |
| `bash-profile` | `~/.bash_profile` (explicit only) |

```bash
caddie path:add:profile caddie-custom "$(brew --prefix postgresql@16)/bin"
```

### Generic line append

#### `caddie profile:add-line <line> [--profile caddie-custom]`

Append any shell line idempotently (exact line match). Useful for exports beyond PATH.

```bash
caddie profile:add-line 'export EDITOR=vim'
caddie profile:add-line:bashrc 'export EDITOR=vim'
```

### Information

#### `caddie profile:info`

Show supported profile targets and file paths.

#### `caddie profile:help`

Show command reference and examples.

## After adding lines

Apply changes in the current shell:

```bash
caddie git:custom:source
```

Or open a new terminal.

## Project setup documentation pattern

Instead of:

```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.bash_profile
```

Use:

```bash
caddie path:add "$(brew --prefix postgresql@16)/bin" --profile caddie-custom
caddie git:custom:source
```

## Related commands

- **`caddie git:custom:source`** — Sources `~/.bash_profile-caddie-custom` and `~/.bashrc-caddie-custom` when present.

## Error handling

- Missing path or line → usage message and non-zero exit
- Unknown profile name → error listing supported profiles
- Duplicate path or line → yellow notice, no file change
