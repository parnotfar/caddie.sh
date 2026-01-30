# Cursor Module

The Cursor module integrates the Cursor IDE with Caddie for project management, AI helpers, extensions, and configuration.

## Overview

Use this module to:
- Detect and verify Cursor installation
- Open or create projects in Cursor
- Run AI-powered utilities for code explanation, refactoring, testing, and docs
- Manage extensions and settings

## Commands

### Setup & Verification

- `caddie cursor:detect` - Detect Cursor installation
- `caddie cursor:setup` - Configure Cursor integration
- `caddie cursor:verify` - Verify integration

### Project Management

- `caddie cursor:open <path>` - Open a project in Cursor
- `caddie cursor:new <type> <name>` - Create a project and open it
- `caddie cursor:setup:project <name> <type>` - Initialize Cursor project config (advanced)
- `caddie cursor:workspace` - Show workspace info
- `caddie cursor:recent` - List recent projects
- `caddie cursor:switch <project>` - Switch to a recent project

### AI Helpers

- `caddie cursor:ai:explain <file>` - Explain code
- `caddie cursor:ai:refactor <file> [type]` - Refactor code
- `caddie cursor:ai:test <file> [framework]` - Generate tests
- `caddie cursor:ai:docs <file> [format]` - Generate documentation
- `caddie cursor:ai:review <file> [focus]` - Review code

### Extensions

- `caddie cursor:ext:list` - List installed extensions
- `caddie cursor:ext:install <id>` - Install an extension
- `caddie cursor:ext:update` - Update all extensions
- `caddie cursor:ext:sync` - Sync extensions across devices
- `caddie cursor:ext:recommend <type>` - Recommend extensions

### Configuration

- `caddie cursor:config:show` - Show current settings
- `caddie cursor:config:backup` - Backup settings
- `caddie cursor:config:restore <path>` - Restore settings
- `caddie cursor:config:sync` - Sync settings
- `caddie cursor:config:optimize` - Apply performance-focused settings

## Examples

```bash
caddie cursor:detect
caddie cursor:open ~/projects/myapp
caddie cursor:ai:explain src/main.py
caddie cursor:ext:install ms-python.python
caddie cursor:config:backup
```
