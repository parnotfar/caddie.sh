# Module Documentation

This directory contains detailed documentation for each Caddie.sh module.

## Available Modules

### Core Module
- **[Core Module](core.md)** - Basic functions, debug system, and home directory management

### Language Modules
- **[Python Module](python.md)** - Python environment and package management
- **[Rust Module](rust.md)** - Rust development tools and project management
- **[Ruby Module](ruby.md)** - Ruby environment with RVM integration
- **[JavaScript Module](javascript.md)** - Node.js and npm management

### Analytics Modules
- **[CSV Module](csv.md)** - SQL-powered analytics, plotting, and session defaults for CSV/TSV datasets

### Development Tools
- **[iOS Module](ios.md)** - iOS development tools and Xcode integration
- **[Cross Module](cross.md)** - Multi-language project templates and tools
- **[Cursor Module](cursor.md)** - IDE integration and AI-powered development
- **[Git Module](git.md)** - Enhanced git workflows and GitHub integration
- **[GitHub Module](github.md)** - GitHub account and repository management
- **[CLI Module](cli.md)** - Color utilities and formatting functions

### Shared Executables (`bin/`)

Common executables that support multiple modules live in the top-level `bin/` folder (deployed to `~/.caddie_modules/bin`). Place new helpers here when you need more than shell functions—keep them executable and reference them from your modules. See the [CSV module](csv.md) for an example using `bin/csvql.py`.

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
