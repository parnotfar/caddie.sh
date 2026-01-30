# Caddie.sh 🏌️‍♂️

> **The Ultimate Development Environment Manager for macOS**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![macOS](https://img.shields.io/badge/macOS-10.15+-blue.svg)](https://www.apple.com/macos/)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)

Caddie.sh is a powerful, modular shell application that transforms your macOS terminal into a standardized development
environment.  Using a common language for tooling is a powerful multiplier for you and your team's success.  Think of it
as your personal caddie on the golf course of development - always ready with the right tools and environment setup to
make your coding experience smooth and efficient.

📋 **[Release Notes](RELEASE_NOTES.md)** - See what's new in the latest version


## Features

- **One-Command Setup**: Complete development environment installation in minutes
- **Modular Architecture**: Pick and choose the tools you need
- **Python Management**: Virtual environments, package management, and project scaffolding
- **Rust Development**: Cargo integration, toolchain management, project templates, and git integration
- **Swift Development**: Swift Package Manager workflows, formatting, and linting helpers
- **Ruby Environment**: RVM integration and gem management
- **JavaScript/Node.js**: NVM integration and package management
- **iOS Distribution**: App Store and TestFlight workflows
- **Rust Integration**: Cross-platform Rust development for iOS, WatchOS, and Android
- **Cross-Platform**: Multi-language project templates and tools
- **Git Workflow**: Branch management, pull request creation, and GitHub integration
- **IDE Integration**: Cursor IDE integration with AI-powered development
- **Git Integration**: Enhanced git workflows with SSH URLs, auto-detection, GitHub integration, and branch management
- **GitHub Integration**: Account management and repository creation with seamless Git workflow
- **Code Quality Tools**: Comprehensive linter with flexible output (all issues or limited), variable shadowing detection, and caddie-specific standards
- **CLI Utilities**: Rich terminal output with colors, UTF-8 characters, and semantic formatting
- **Debug System**: Built-in debugging and logging capabilities
- **Customizable Prompts**: Beautiful, informative shell prompts
- **Extensible Ecosystem**: Optional modules—like [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools)—slot in without modifying the core

## 🚀 Quick Start

### Prerequisites

- Bash 4.0+ (Homebrew Bash recommended on macOS)
- Homebrew on macOS (installed automatically if missing)
- macOS 10.15+ recommended; Linux is supported but may require minor manual tweaks depending on your distro

> **macOS Terminal configuration (after install)**: If you want to use Homebrew Bash, configure your Terminal profile to run `/opt/homebrew/bin/bash --login` after Homebrew is installed. See the [Installation Guide](docs/installation.md#macos-terminal-configuration) for details.

### Installation

```bash
# Clone the repository
git clone https://github.com/parnotfar/caddie.sh.git
cd caddie.sh

# Run the installer
make install
```

### First Use

```bash
# Reload environment (recommended)
caddie reload

# Get help
caddie help

# Enter interactive prompt
caddie  # prompt shows as caddie-8.3.0 (update this for each release)

# Narrow the prompt to a module scope
caddie-8.3.0 rust  # prompt switches to caddie[rust]-8.3.0
caddie[rust]-8.3.0 back  # exits scope (also accepts `up` or `..`)

# Run shell commands without leaving the REPL
caddie-8.3.0 `ls -la`
caddie-8.3.0 shell git status  # one-off shell command

# Cancel a long-running command without leaving the REPL
caddie-8.3.0 rust build
# press Ctrl+C → command stops and prompt stays open
```

> Tip: Caddie keeps REPL history in `~/.caddie_history`, so arrow-key recall works without adding entries to your shell history.

## Documentation

- **[Installation Guide](docs/installation.md)** - Detailed setup instructions
- **[User Guide](docs/user-guide.md)** - How to use caddie.sh effectively
- **[Module Reference](docs/modules/)** - Complete documentation for each module
- **[Configuration](docs/configuration.md)** - Customizing your environment
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions
- **[Contributing](docs/contributing.md)** - How to contribute to the project
- **[Launch Plan](docs/launch-plan.md)** - Open-source launch strategy and checklist

### Module Documentation

- **[Core Module](docs/modules/core.md)** - Basic caddie functions and debug system
- **[Python Module](docs/modules/python.md)** - Python environment management
- **[Rust Module](docs/modules/rust.md)** - Rust development tools and cross-platform integration
- **[MCP Module](docs/modules/mcp.md)** - MCP server shortcuts and deployment helpers
- **[Ruby Module](docs/modules/ruby.md)** - Ruby environment with RVM
- **[JavaScript Module](docs/modules/javascript.md)** - Node.js and npm management
- **[iOS Module](docs/modules/ios.md)** - App Store and TestFlight distribution tools
- **[Cross Module](docs/modules/cross.md)** - Multi-language project templates
- **[Cursor Module](docs/modules/cursor.md)** - IDE integration and AI tools
- **[Codex Module](docs/modules/codex.md)** - Codex-powered review and automation helpers
- **[Debug Module](docs/modules/debug.md)** - Debug control and output helpers
- **[Git Module](docs/modules/git.md)** - Enhanced git workflows
- **[CLI Module](docs/modules/cli.md)** - Color utilities and formatting functions
- External ecosystem modules—such as [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools)—provide additional capabilities when installed separately

## Use Cases

### For Developers
- **Quick Environment Setup**: Get a new development machine ready in minutes
- **Project Scaffolding**: Create new projects with proper structure and tooling
- **Environment Management**: Switch between different language versions and tools
- **IDE Integration**: Seamless integration with modern development tools

### For Teams
- **Standardized Environments**: Ensure all team members have identical setups
- **Onboarding**: New team members can be productive immediately
- **Tool Consistency**: Everyone uses the same versions and configurations

### For DevOps
- **CI/CD Integration**: Automated environment setup in build pipelines
- **Infrastructure as Code**: Reproducible development environments
- **Tool Management**: Centralized control over development tools

## 🏗️ Architecture

Caddie.sh follows a modular architecture where each development tool or language is implemented as a separate module:

```
caddie.sh/
├── dot_caddie              # Main entry point
├── dot_caddie_prompt       # Prompt customization
├── dot_caddie_version      # Version information
├── dot_caddie_debug        # Debug system
├── dot_caddie_modules      # Data structure management
├── bin/                    # Executables shared across modules
├── modules/                # All module files
│   ├── dot_caddie_core     # Core functions and debug system
│   ├── dot_caddie_python   # Python environment management
│   ├── dot_caddie_rust     # Rust development tools
│   ├── dot_caddie_ruby     # Ruby environment management
│   ├── dot_caddie_js       # JavaScript/Node.js tools
│   ├── dot_caddie_ios      # App Store and TestFlight tools
│   ├── dot_caddie_cross    # Cross-language features
│   ├── dot_caddie_cursor   # IDE integration
│   └── dot_caddie_git      # Git enhancements
├── docs/                   # Documentation
├── Makefile                # Build system
└── README.md               # Project overview
```

> **Note**: Tab completion is currently centralized in the main `dot_caddie` file due to Bash variable scope limitations. See [Contributing Guide](docs/contributing.md#adding-tab-completion-for-new-modules) for details on adding completion for new modules.

The new `bin/` directory collects standalone executables that ship with caddie. During installation these scripts are copied to `~/.caddie_modules/bin`, giving every module a predictable place to find shared helpers. When adding future language or analytics tools, drop the runnable script into `bin/`, ensure it is executable, and reference it from your module implementation.

## Configuration

### Environment Variables

- `CADDIE_DEBUG`: Enable/disable debug output (0/1)
- `CADDIE_HOME`: Set custom home directory for projects
- `CADDIE_MODULES_DIR`: Custom modules directory

### Customization

```bash
# Enable debug mode
caddie core:debug on

# Set custom home directory
caddie core:set:home ~/my-projects

# Customize shell prompt
# Edit ~/.caddie_prompt.sh
```

## Examples

### Python Development

```bash
# Create and activate virtual environment
caddie python:create myproject
caddie python:activate myproject

# Install packages and manage dependencies
caddie python:install requests
caddie python:freeze
```

### Rust Development

```bash
# Create new Rust project
caddie rust:new myapp
cd myapp

# Build and run
caddie rust:build
caddie rust:run
```

### Git Workflow

```bash
# Set up GitHub account
caddie github:account:set parnotfar

# Clone repository
caddie git:clone my-project

# Create and publish new branch
caddie git:new:branch feature/new-feature

# Quick commit and push
caddie git:gacp "Add new feature"

# Create pull request
caddie git:pr:create "Add new feature" "Description of changes"

# Check status and manage remotes
caddie git:status
caddie git:remote:add
```

### Project Management

```bash
# Open project in Cursor IDE
caddie cursor:open ~/my-project

# Get AI-powered code explanation
caddie cursor:ai:explain src/main.rs
```

### Codex Review

```bash
# Run a Codex review on the latest commit
caddie codex:review .

# Watch a repo and review every commit automatically
caddie codex:review:watch ~/work/my-repo

# Open the Codex review hub + tail tab for a repo
caddie codex:review:terminal:open ~/work/my-repo

# Debug Terminal automation (opens a test hub + tab)
caddie codex:review:terminal:debug
```

### Code Quality

```bash
# Run comprehensive linter on all modules (shows ALL issues)
caddie core:lint

# Check specific module (shows ALL issues)
caddie core:lint modules/dot_caddie_rust

# Limited output (shows max 5 issues per check type)
caddie core:lint:limit 5 modules/dot_caddie_ruby

# Focused debugging (shows max 3 issues per check type)
caddie core:lint:limit 3 modules/
```

The linter enforces caddie-specific standards including:
- Consistent CLI formatting (`caddie cli:*` functions)
- Proper echo message handling (usage, success, error, general)
- Function naming conventions
- Local variable declarations
- Explicit return statements

## Contributing

We welcome contributions! Please see our [Contributing Guide](docs/contributing.md) for details.

### Development Setup

```bash
# Clone and setup development environment
git clone https://github.com/parnotfar/caddie.sh.git
cd caddie.sh

# Install development dependencies
make setup-dev

# Run tests (when implemented)
make test
```

### Code Style

- Follow shell script best practices
- Use consistent naming conventions
- Include comprehensive error handling
- Add debug statements for troubleshooting

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Homebrew**: For package management infrastructure
- **RVM**: For Ruby version management
- **NVM**: For Node.js version management
- **Rustup**: For Rust toolchain management
- **Cursor**: For AI-powered development tools

## Support

- **Issues**: [GitHub Issues](https://github.com/parnotfar/caddie.sh/issues)
- **Discussions**: [GitHub Discussions](https://github.com/parnotfar/caddie.sh/discussions)
- **Wiki**: [Project Wiki](https://github.com/parnotfar/caddie.sh/wiki)

## Roadmap

- [ ] **v1.1**: Docker integration and containerization
- [ ] **v1.2**: Additional language support (Go, Java, C++)
- [ ] **v1.3**: Cloud development tools (AWS, GCP, Azure)
- [ ] **v1.4**: Team collaboration features
- [ ] **v2.0**: Cross-platform support (Linux, Windows)

---

**Made with ❤️ for the developer community**

*Caddie.sh – Because every developer, DevOps engineer, and data engineer deserves a great caddie on the course of
*building, deploying, and innovating.*
