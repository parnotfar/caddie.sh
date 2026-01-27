# Codex Module

The Codex module provides automated code reviews for local git repositories. It can run reviews on demand or automatically after every commit.

## Overview

- **Manual review**: `codex:review` runs a review on the latest commit in a repo.
- **Watch mode**: `codex:review:watch` installs a `post-commit` hook to trigger reviews after every commit.
- **Streaming**: a dedicated Terminal tab tails review output for quick access.

## Commands

### `caddie codex:review [dir]`
Run a review on the latest commit in the repo (defaults to current directory).

```bash
caddie codex:review .
```

### `caddie codex:review:watch <dir>`
Enable automatic reviews on every commit for a repo.

```bash
caddie codex:review:watch ~/work/my-repo
```

### `caddie codex:review:watch:stop <dir>`
Disable automatic reviews and restore the previous `post-commit` hook if present.

```bash
caddie codex:review:watch:stop ~/work/my-repo
```

### `caddie codex:review:watch:status <dir>`
Check whether the watch hook is installed.

```bash
caddie codex:review:watch:status ~/work/my-repo
```

### `caddie codex:review:tail <dir>`
Tail the review output log for a repo.

```bash
caddie codex:review:tail ~/work/my-repo
```

### Review Command Configuration

The module expects a command that accepts the review prompt via stdin and prints a response to stdout. If `codex` is available, the default is `codex review -`.

#### `caddie codex:review:command:set <command>`
Set the review command used for all reviews.

```bash
caddie codex:review:command:set "codex review -"
```

#### `caddie codex:review:command:append <args>`
Append arguments to the configured review command.

```bash
caddie codex:review:command:append "--model gpt-5 --temperature 0.2"
```

#### `caddie codex:review:command:get`
Show the configured review command.

```bash
caddie codex:review:command:get
```

#### `caddie codex:review:command:unset`
Clear the configured review command.

```bash
caddie codex:review:command:unset
```

## Notes

- Merge commits are skipped by design.
- Reviews are written to `~/.caddie_state/codex/reviews/<repo-id>/review.log`.
- The watcher opens a Terminal window/tab titled **Caddie Codex Hub** for streaming.
