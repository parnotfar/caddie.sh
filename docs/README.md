# Caddie.sh Documentation

Welcome to the comprehensive documentation for Caddie.sh, the ultimate development environment manager for macOS.

## Getting Started

- **[Installation Guide](installation.md)** - Complete setup instructions
- **[User Guide](user-guide.md)** - How to use Caddie.sh effectively

## 🚀 Launch & Community

- **[Launch Plan](launch-plan.md)** - Comprehensive open-source launch strategy and checklist

## Core Documentation

- **[Configuration Guide](configuration.md)** - Customize your environment
- **[Troubleshooting Guide](troubleshooting.md)** - Common issues and solutions
- **[Contributing Guide](contributing.md)** - How to contribute to the project

## Module Reference

- **[Module Documentation](modules/)** - Detailed information for each module
  - [Core Module](modules/core.md) - Basic functions and debug system
  - [Python Module](modules/python.md) - Python environment management
  - [Rust Module](modules/rust.md) - Rust development tools
  - [Ruby Module](modules/ruby.md) - Ruby environment management
  - [JavaScript Module](modules/javascript.md) - Node.js tools
  - [iOS Module](modules/ios.md) - iOS development tools
  - [Cross Module](modules/cross.md) - Multi-language templates
  - [CSV Module](modules/csv.md) - SQL analytics, plotting, and persistent defaults for CSV/TSV datasets
  - [Cursor Module](modules/cursor.md) - IDE integration
  - [Git Module](modules/git.md) - Enhanced git workflows

### Shared Executables

Reusable helper scripts now live in the repository `bin/` directory. The installer copies this folder to `~/.caddie_modules/bin`, giving every module a predictable place to locate shared tools (for example, the `csvql.py` analytics helper). When adding a new cross-cutting utility, drop the executable into `bin/`, ensure it has a shebang plus execute permissions, and invoke it from your module or dotfile.

## Quick Reference

### Essential Commands

```bash
# Get help
caddie help

# Check version
caddie --version

# Enable debug mode
caddie core:debug on

# Set project home
caddie core:set:home ~/projects

# Navigate to caddie home
caddie go:home
```

### Module Help

```bash
# Get help for specific module
caddie python:help
caddie rust:help
caddie core:help
```

## Support

- **GitHub Issues**: [Report bugs and request features](https://github.com/parnotfar/caddie.sh/issues)
- **GitHub Discussions**: [Ask questions and share tips](https://github.com/parnotfar/caddie.sh/discussions)
- **Documentation**: Check this directory for detailed information

## Contributing

We welcome contributions! See our [Contributing Guide](contributing.md) for details on how to get started.

---

*Happy building, analyzing, deploying, and growing with Caddie.sh! 🏌️‍♂️*
