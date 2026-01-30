# MCP Module

The MCP module provides shortcuts for working with the MCP server Rust crate located at `platform/mcp-server-rust`.

## Overview

The module is designed to simplify MCP server workflows from anywhere inside the repo:

- Resolve the repo root automatically
- Run, test, and build the MCP server without manual `cd`
- Reuse existing `caddie rust:*` behavior

## Commands

### `caddie mcp:run`

Run the MCP server via `caddie rust:run`.

**Examples:**
```bash
caddie mcp:run
```

**What it does:**
- Locates `platform/mcp-server-rust` from the current directory
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

## Project Resolution

The module walks up from the current directory until it finds a repo root that contains `platform/mcp-server-rust`. This means you can run the commands from any subdirectory within the repo.

## Requirements

- The MCP server crate must exist at `platform/mcp-server-rust`
- Rust toolchain installed (`rustup`, `cargo`)
- Caddie rust module installed and available

## Examples

```bash
# From repo root
caddie mcp:run

# From a subdirectory
cd platform
caddie mcp:test
```

## Troubleshooting

- **"Could not locate platform/mcp-server-rust"**: Run the command from inside the repo.
- **Rust errors**: Ensure the Rust toolchain is installed and `Cargo.toml` exists in the MCP server crate.
