# Cross Module

The Cross module provides cross-language utilities, templates, and deployment helpers for multi-language projects.

## Overview

Use this module when you want to:
- Set up or inspect your dev environment across languages
- Create project templates quickly
- Build projects across Python, Rust, and iOS
- Run cross-language tooling helpers (lint/format)

## Commands

### Environment Management

- `caddie cross:info` - Show toolchain summary
- `caddie cross:env:status` - Show Python/Rust/Node/iOS/Git/Docker status
- `caddie cross:env:setup` - Install common tooling via Homebrew
- `caddie cross:env:reset` - Clean local environments in the current directory
- `caddie cross:env:backup` - Backup common tool configs to `~/.caddie-backups`

### Project Templates

- `caddie cross:template:list` - List available templates
- `caddie cross:template:create <type> <name>` - Create a project from template
- `caddie cross:template:<type> <name>` - Shortcut for a specific template type (advanced)

Template types include: `web`, `api`, `mobile`, `app`, `framework`, `extension`, `data`, `ml`, `cli`, `lib`, `wasm`.

### Build Helpers

- `caddie cross:build:all` - Build all detected project types
- `caddie cross:build:python` - Build Python package
- `caddie cross:build:rust` - Build Rust project
- `caddie cross:build:ios` - iOS build placeholder (not fully implemented)

### Deployment Helpers

- `caddie cross:deploy:docker` - Generate Dockerfile + docker-compose.yml
- `caddie cross:deploy:local` - Generate a local deploy script
- `caddie cross:deploy:railway` - Deploy MCP server via Railway CLI

### Development Tools

- `caddie cross:tools:install` - Install common lint/format tools
- `caddie cross:tools:setup` - Initialize tool config (pre-commit, lint)
- `caddie cross:tools:lint` - Run available linters
- `caddie cross:tools:format` - Format code where supported

## Examples

```bash
caddie cross:env:status
caddie cross:template:create web myapp
caddie cross:build:rust
caddie cross:deploy:railway
caddie cross:tools:lint
```
