# macOS Module

The macOS module provides workflow helpers for common macOS maintenance tasks.

## Overview

Use this module to:
- Archive macOS screenshots from Desktop and Downloads
- Configure the screenshot archive directory
- Automatically trash archived screenshots older than 30 days

## Commands

### Screenshot Archive

- `caddie mac:screenshot:archive` - Move matching screenshots into the archive and trash older ones
- `caddie mac:screenshot:archive:dry:run` - Preview archive actions without moving files
- `caddie mac:screenshot:archive:dir:set <path>` - Set a custom archive directory
- `caddie mac:screenshot:archive:dir:get` - Show the configured archive directory
- `caddie mac:screenshot:archive:dir:unset` - Reset to the default archive directory

## Defaults

- Default archive directory: `~/Desktop/Screenshot-Archive`
- Filename pattern: `Screenshot YYYY-MM-DD*.png` or `Screen Shot YYYY-MM-DD*.png`
- Cleanup rule: Archived screenshots older than 30 days move to `~/.Trash`
- Output: Reports per-directory counts for Desktop and Downloads

## Examples

```bash
caddie mac:screenshot:archive
caddie mac:screenshot:archive:dry:run
caddie mac:screenshot:archive:dir:set ~/Desktop/Screenshot-Archive
caddie mac:screenshot:archive:dir:get
```
