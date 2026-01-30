# Module Documentation

This directory contains detailed documentation for each Caddie.sh module.

## Available Modules

### Core Module
- **[Core Module](core.md)** - Basic functions, debug system, and home directory management

### Language Modules
- **[Python Module](python.md)** - Python environment and package management
- **[Rust Module](rust.md)** - Rust development tools and project management
- **[Swift Module](swift.md)** - Swift Package Manager and Xcode project integration
- **[Ruby Module](ruby.md)** - Ruby environment with RVM integration
- **[JavaScript Module](javascript.md)** - Node.js and npm management

### Development Tools
- **[iOS Module](ios.md)** - App Store and TestFlight distribution tools
- **[Cross Module](cross.md)** - Multi-language project templates and tools
- **[macOS Module](mac.md)** - macOS workflow helpers and utilities
- **[MCP Module](mcp.md)** - MCP server shortcuts and deployment helpers
- **[Cursor Module](cursor.md)** - IDE integration and AI-powered development
- **[Codex Module](codex.md)** - Codex-powered review and automation helpers
- **[Debug Module](debug.md)** - Debug control and output helpers
- **[Git Module](git.md)** - Enhanced git workflows and GitHub integration
- **[GitHub Module](github.md)** - GitHub account and repository management
- **[CLI Module](cli.md)** - Color utilities and formatting functions

### Operations
- **[Debian Module](debian.md)** - Debian package management helpers
- **[Server Module](server.md)** - Remote server access and service controls

### Optional Ecosystem Modules
- External modules maintained in separate repositories—such as [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools)—can be installed alongside the core set when you need additional capabilities.
- **[CSV Module](csv.md)** - Optional CSV analytics module (requires separate install)

#### Prompt & Completion APIs
- Register prompt segments with `caddie_prompt_register_segment <function>` and return the text you want appended to PS1.
- Register tab-completion entries with `caddie_completion_register <module> "cmd1 cmd2 …"` or implement `caddie_<module>_commands` to have caddie call it automatically during module discovery.

### Shared Executables (`bin/`)

Common executables that support multiple modules live in the top-level `bin/` folder (deployed to `~/.caddie_modules/bin`). Place new helpers here when you need more than shell functions—keep them executable and reference them from your modules.

## Module Structure

Each module follows a consistent structure:

1. **Overview** - What the module provides
2. **Commands** - Available commands with examples
3. **Environment Variables** - Configuration options
4. **Configuration Files** - Files the module uses
5. **Error Handling** - Common errors and solutions
6. **Best Practices** - Recommended usage patterns
7. **Examples** - Practical usage examples
8. **Troubleshooting** - Common issues and fixes

## Getting Help

For each module, use the help command:

```bash
caddie <module>:help
```

For example:
```bash
caddie python:help
caddie rust:help
caddie core:help
caddie cli:help
```

## Contributing

To add documentation for a new module or improve existing documentation, see the [Contributing Guide](../contributing.md).
