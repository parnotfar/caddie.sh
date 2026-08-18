# System Module

The System module reports operating-system binaries — the paths Apple or Linux shipped, not Homebrew or PATH overlays.

## Overview

Use this module to inspect the OS Bash that Cursor Agent and Codex inherit when launchd `SHELL` / the login shell is still `/bin/bash`.

## Commands

- `caddie system:bash:get` - Print the system Bash path (`/bin/bash` on macOS)
- `caddie system:bash:version` - Print the system Bash version

Internal helper `caddie_system_bash_path` prints the same path for other modules (no formatting).

## Examples

```bash
caddie system:bash:get
caddie system:bash:version
caddie homebrew:bash:get
```

On macOS the system path is Apple Bash 3.2. Homebrew Bash is a different binary; see **[Homebrew Module](homebrew.md)**.
