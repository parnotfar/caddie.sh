# Caddie.sh Documentation

Welcome to the comprehensive documentation for Caddie.sh, the ultimate development environment manager for macOS.

## Getting Started

- **[Installation Guide](installation.md)** - Complete setup instructions (`make install` for installs and upgrades; `make install-dot` is for caddie development only)
- **[User Guide](user-guide.md)** - How to use Caddie.sh effectively

## 🚀 Launch & Community

- **[Launch Plan](launch-plan.md)** - Comprehensive open-source launch strategy and checklist

## Core Documentation

- **[Configuration Guide](configuration.md)** - Customize your environment
- **[Troubleshooting Guide](troubleshooting.md)** - Common issues and solutions
- **[Contributing Guide](contributing.md)** - How to contribute to the project

## Module Reference

- **[Module Documentation](modules/)** - Detailed information for each module
  - [Core Module](modules/core.md) - Basic functions, debug system, **`caddie agent:exec`**, and **`caddie core:module:commands`**
  - [Python Module](modules/python.md) - Python environment management
  - [Rust Module](modules/rust.md) - Rust development tools
  - [Ruby Module](modules/ruby.md) - Ruby environment management
  - [JavaScript Module](modules/javascript.md) - Node.js tools
  - [iOS Module](modules/ios.md) - App Store and TestFlight distribution tools
  - [Cross Module](modules/cross.md) - Multi-language templates
  - [Cursor Module](modules/cursor.md) - IDE integration
  - [Git Module](modules/git.md) - Enhanced git workflows
  - [GitHub Module](modules/github.md) - GitHub account and repository management
  - [Profile Module](modules/profile.md) - Bash profile sourcing and custom PATH snippets
  - [Skill Module](modules/skill.md) - Agent skill install, update, and audit
  - Optional ecosystem modules (e.g. [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools)) can be installed separately

### Shared executables

The installer copies repository `bin/` to `~/.caddie_modules/bin` and installs **`~/bin/caddie`** as the public CLI entry point. The `caddie agent:exec` subcommand (handled by `~/bin/caddie`) runs any module command in a clean Bash subprocess — useful for Codex and other automation shells. See **[Core Module — Agent and automation](modules/core.md#agent-and-automation)**.

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

# Install agent skill (Cursor / Codex)
caddie skill:install:all
caddie skill:audit
```

### Module Help

```bash
# Get help for specific module
caddie python:help
caddie rust:help
caddie profile:help
caddie skill:help
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
