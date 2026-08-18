# Codex Module

The Codex module provides two workflows:
- Daily Codex CLI usage (`run`, `exec`, `resume`, auth, MCP, cloud)
- Automated git commit reviews (`review`, `review:watch`, `review:tail`)

## Overview

Use this module to:
- Start Codex sessions from caddie
- Run non-interactive Codex tasks
- Manage CLI defaults for model, approval mode, and sandbox mode
- Automatically review commits and stream review logs

## Commands

### Core Codex CLI

- `caddie codex:info` - Show CLI path/version, defaults, and review state
- `caddie codex:bash:get` - Show system Bash, Homebrew Bash, login shell, and launchd SHELL
- `caddie codex:bash:configure` - Point the login shell and launchd SHELL at `caddie homebrew:bash:get`
- `caddie codex:run [prompt]` - Start Codex (or run one prompt)
- `caddie codex:exec <prompt> [exec-options...]` - Run a non-interactive task
- `caddie codex:resume [session-id]` - Resume a previous session
- `caddie codex:status` - Show Codex login/account status
- `caddie codex:auth:login` - Authenticate with Codex
- `caddie codex:auth:logout` - Remove local Codex auth
- `caddie codex:mcp [args...]` - Forward args to `codex mcp`
- `caddie codex:cloud [args...]` - Forward args to `codex cloud`
- `caddie codex:completion [shell]` - Print shell completion script

### CLI Defaults

- `caddie codex:model:set <model>`
- `caddie codex:model:get`
- `caddie codex:model:unset`

- `caddie codex:approval:set <untrusted|on-failure|on-request|never>`
- `caddie codex:approval:get`
- `caddie codex:approval:unset`

- `caddie codex:sandbox:set <read-only|workspace-write|danger-full-access>`
- `caddie codex:sandbox:get`
- `caddie codex:sandbox:unset`

These defaults are applied by `codex:run` and `codex:exec`.

### Review Automation

- `caddie codex:review [dir]` - Review the latest commit in the repo
- `caddie codex:review:watch <dir>` - Install a post-commit hook for auto-review
- `caddie codex:review:watch:stop <dir>` - Remove auto-review hook and restore prior hook
- `caddie codex:review:watch:status <dir>` - Check watch-hook status
- `caddie codex:review:tail <dir>` - Tail and format review logs
- `caddie codex:review:terminal:debug` - Validate Terminal AppleScript automation
- `caddie codex:review:terminal:script <dir>` - Generate Terminal helper scripts
- `caddie codex:review:terminal:open <dir>` - Open review hub + tail tab

### Review Command Configuration

- `caddie codex:review:command:set <command>`
- `caddie codex:review:command:append <args>`
- `caddie codex:review:command:get`
- `caddie codex:review:command:unset`

Default review command:

```bash
codex exec --full-auto __PROMPT__
```

`__PROMPT__` is replaced with the generated review prompt. For stdin-style commands, keep your command without `__PROMPT__`.

## Examples

```bash
# Day-to-day CLI usage
caddie codex:run
caddie codex:bash:get
caddie codex:bash:configure
caddie codex:exec "Summarize the current branch risk"
caddie codex:model:set gpt-5.3-codex
caddie codex:approval:set on-request

# Review automation
caddie codex:review .
caddie codex:review:watch ~/work/my-repo
caddie codex:review:tail ~/work/my-repo
caddie codex:review:command:set "codex exec --full-auto __PROMPT__"
```

## Notes

- Codex has no Unix shell-path key in `config.toml`. On macOS, Codex agents use launchd `SHELL`; on Linux they use the login shell. Use `caddie codex:bash:configure` and fully quit Codex afterward. Inspect with `caddie core:bash:launchd:get`.
- Merge commits are skipped by design.
- Reviews are written to `~/.caddie_state/codex/reviews/<repo-id>/review.log`.
- Hook execution is asynchronous and logs start/end markers for stream parsing.
- If your terminal tab automation fails, run `caddie codex:review:terminal:debug`.
