# MCP Module

The MCP module provides shortcuts for working with an MCP server Rust crate. Configure the server path once, then run, test, and build from anywhere.

## Overview

The module is designed to simplify MCP server workflows:

- Configure the MCP server directory via get/set/unset commands
- Run, test, and build the MCP server without manual `cd`
- Reuse existing `caddie rust:*` behavior

## Commands

### `caddie mcp:info`

Show MCP server configuration summary (path and availability).

### `caddie mcp:server:set <path>`

Set the MCP server directory.

**Examples:**
```bash
caddie mcp:server:set ~/work/pnf/platform/mcp-server-rust
```

**What it does:**
- Validates the directory exists
- Stores the absolute path in the current shell
- Updates the prompt segment to show `[mcp: <dirname>]`

### `caddie mcp:server:get`

Show the configured MCP server directory (if set).

### `caddie mcp:server:unset`

Clear the MCP server directory.

### `caddie mcp:run`

Run the MCP server via `caddie rust:run`.

**Examples:**
```bash
caddie mcp:run
```

**What it does:**
- Uses the configured MCP server directory
- Changes into that directory
- Runs `caddie rust:run`

### `caddie mcp:test`

Run all MCP server tests via `caddie rust:test:all`.

**Examples:**
```bash
caddie mcp:test
```

### `caddie mcp:build`

Build the MCP server via `caddie rust:build`.

**Examples:**
```bash
caddie mcp:build
```

## Prompt Segment

When a server is configured, the shell prompt includes a segment like `[mcp: <dirname>]` showing the directory name of the configured server.

## Requirements

- The MCP server directory must be configured with `caddie mcp:server:set`
- Rust toolchain installed (`rustup`, `cargo`)
- Caddie rust module installed and available

## Examples

```bash
# Configure once
caddie mcp:server:set ~/work/pnf/platform/mcp-server-rust

# Run from anywhere
caddie mcp:run
caddie mcp:test
```

## Troubleshooting

- **"MCP server not set"**: Run `caddie mcp:server:set <path>` first.
- **Rust errors**: Ensure the Rust toolchain is installed and `Cargo.toml` exists in the MCP server crate.
