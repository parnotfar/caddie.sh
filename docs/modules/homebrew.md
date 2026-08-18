# Homebrew Module

The Homebrew module reports Homebrew-provided binaries — not Apple `/bin/bash` and not whichever `bash` happens to be first on PATH.

## Overview

Cursor and Codex bash configuration use this module to find Homebrew Bash 4+. Inspect the path and version before running `caddie cursor:bash:configure` or `caddie codex:bash:configure`. Those orchestrators also set the login shell and, on macOS, launchd `SHELL`.

## Commands

- `caddie homebrew:bash:get` - Print the Homebrew Bash path
- `caddie homebrew:bash:version` - Print the Homebrew Bash version

Internal helpers:

- `caddie_homebrew_bash_path` - path only, for other modules
- `caddie_homebrew_bash_prepare <varname>` - require Bash 4+ and store the path in `<varname>`

Lookup order: `$(brew --prefix)/bin/bash`, then well-known Homebrew prefixes, then `brew --prefix bash` (keg). The linked path is preferred because it is the one Homebrew adds to `/etc/shells` for `chsh`. The system Bash path is never returned.

## Examples

```bash
caddie homebrew:bash:get
caddie homebrew:bash:version
caddie cursor:bash:configure
caddie codex:bash:configure
```

If Homebrew Bash is missing:

```bash
brew install bash
caddie homebrew:bash:get
```
