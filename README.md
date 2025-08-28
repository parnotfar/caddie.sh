# Caddie.sh 🏌️‍♂️

> **The Ultimate Development Environment Manager for macOS**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-10.15+-blue.svg)](https://www.apple.com/macos/)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)

Caddie.sh is a powerful, modular shell script that transforms your macOS terminal into a comprehensive development environment. Think of it as your personal caddie on the golf course of development - always ready with the right tools, environment setup, and shortcuts to make your coding experience smooth and efficient.

## ✨ Features

- 🚀 **One-Command Setup**: Complete development environment installation in minutes
- 🧩 **Modular Architecture**: Pick and choose the tools you need
- 🐍 **Python Management**: Virtual environments, package management, and project scaffolding
- 🦀 **Rust Development**: Cargo integration, toolchain management, and project templates
- 💎 **Ruby Environment**: RVM integration and gem management
- 🟨 **JavaScript/Node.js**: NVM integration and package management
- 📱 **iOS Development**: Xcode integration and development tools
- 🎯 **Cross-Platform**: Multi-language project templates and tools
- 🖥️ **IDE Integration**: Cursor IDE integration with AI-powered development
- 🔧 **Git Integration**: Enhanced git workflows and shortcuts
- 🐛 **Debug System**: Built-in debugging and logging capabilities
- 🎨 **Customizable Prompts**: Beautiful, informative shell prompts

## 🚀 Quick Start

### Prerequisites

- macOS 10.15+ (Catalina or later)
- Homebrew (will be installed automatically if missing)
- Bash 4.0+ (latest version via Homebrew recommended)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/caddie.sh.git
cd caddie.sh

# Run the installer
make install
```

### First Use

```bash
# Restart your terminal or source the profile
source ~/.bash_profile

# Verify installation
caddie --version

# Get help
caddie help
```

## 📚 Documentation

- **[Installation Guide](docs/installation.md)** - Detailed setup instructions
- **[User Guide](docs/user-guide.md)** - How to use caddie.sh effectively
- **[Module Reference](docs/modules/)** - Complete documentation for each module
- **[Configuration](docs/configuration.md)** - Customizing your environment
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions
- **[Contributing](docs/contributing.md)** - How to contribute to the project

### Module Documentation

- **[Core Module](docs/modules/core.md)** - Basic caddie functions and debug system
- **[Python Module](docs/modules/python.md)** - Python environment management
- **[Rust Module](docs/modules/rust.md)** - Rust development tools
- **[Ruby Module](docs/modules/ruby.md)** - Ruby environment with RVM
- **[JavaScript Module](docs/modules/javascript.md)** - Node.js and npm management
- **[iOS Module](docs/modules/ios.md)** - iOS development tools
- **[Cross Module](docs/modules/cross.md)** - Multi-language project templates
- **[Cursor Module](docs/modules/cursor.md)** - IDE integration and AI tools
- **[Git Module](docs/modules/git.md)** - Enhanced git workflows

## 🎯 Use Cases

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
├── dot_caddie_core         # Core functions and debug system
├── dot_caddie_python       # Python environment management
├── dot_caddie_rust         # Rust development tools
├── dot_caddie_ruby         # Ruby environment management
├── dot_caddie_js           # JavaScript/Node.js tools
├── dot_caddie_ios          # iOS development tools
├── dot_caddie_cross        # Cross-language features
├── dot_caddie_cursor       # IDE integration
├── dot_caddie_git          # Git enhancements
└── dot_caddie_*            # Additional modules...
```

## 🔧 Configuration

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

## 🚀 Examples

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

### Project Management

```bash
# Open project in Cursor IDE
caddie cursor:open ~/my-project

# Get AI-powered code explanation
caddie cursor:ai:explain src/main.rs
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](docs/contributing.md) for details.

### Development Setup

```bash
# Clone and setup development environment
git clone https://github.com/yourusername/caddie.sh.git
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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Homebrew**: For package management infrastructure
- **RVM**: For Ruby version management
- **NVM**: For Node.js version management
- **Rustup**: For Rust toolchain management
- **Cursor**: For AI-powered development tools

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/caddie.sh/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/caddie.sh/discussions)
- **Wiki**: [Project Wiki](https://github.com/yourusername/caddie.sh/wiki)

## 🗺️ Roadmap

- [ ] **v1.1**: Additional language support (Go, Java, C++)
- [ ] **v1.2**: Docker integration and containerization
- [ ] **v1.3**: Cloud development tools (AWS, GCP, Azure)
- [ ] **v1.4**: Team collaboration features
- [ ] **v2.0**: Cross-platform support (Linux, Windows)

---

**Made with ❤️ for the developer community**

*Caddie.sh - Because every developer deserves a great caddie on the course of coding.*
