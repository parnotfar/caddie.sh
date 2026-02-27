# Claude Module

The Claude module helps teams get started with Claude Code quickly and use it consistently from caddie.

## Overview

Use this module to:
- Scaffold project-level Claude files (`CLAUDE.md`, `.claude/commands/`)
- Run Claude interactively or in print mode
- Resume/continue Claude sessions
- Manage auth, diagnostics, updates, MCP, and agents commands
- Set reusable defaults for model and permission mode

## Commands

### Setup & Status

- `caddie claude:info` - Show CLI path/version, config directories, and defaults
- `caddie claude:init [dir]` - Create starter `CLAUDE.md` and `.claude/commands/review.md`

### Session & Prompting

- `caddie claude:run [prompt]` - Start Claude (or run one prompt)
- `caddie claude:print <prompt> [claude-print-options...]` - Run non-interactive prompt mode (`claude -p`)
- `caddie claude:continue` - Continue the most recent session
- `caddie claude:resume [session-id]` - Resume a previous session

### Auth / Maintenance

- `caddie claude:auth:login`
- `caddie claude:auth:logout`
- `caddie claude:doctor`
- `caddie claude:update`

### Advanced CLI Surfaces

- `caddie claude:mcp [args...]` - Forward args to `claude mcp`
- `caddie claude:agents [args...]` - Forward args to `claude agents`

### Defaults

- `caddie claude:model:set <model>`
- `caddie claude:model:get`
- `caddie claude:model:unset`

- `caddie claude:permission:mode:set <default|acceptEdits|bypassPermissions|plan>`
- `caddie claude:permission:mode:get`
- `caddie claude:permission:mode:unset`

These defaults are applied by `claude:run`, `claude:print`, `claude:continue`, and `claude:resume`.

## Examples

```bash
# First-time project setup
caddie claude:init .
caddie claude:auth:login

# Daily usage
caddie claude:run
caddie claude:print "Review the staged diff for regressions" --output-format text
caddie claude:continue

# Team defaults
caddie claude:model:set claude-opus-4-1
caddie claude:permission:mode:set acceptEdits
```

## Notes

- Global Claude settings typically live under `~/.claude`.
- Project-level configuration lives in `.claude/`.
- `claude:init` is non-destructive: existing files are preserved.
