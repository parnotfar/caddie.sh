# User Guide

Welcome to Caddie.sh! This guide will help you get the most out of your development environment manager.

## Getting Started

### First Steps

After installation, Caddie.sh is ready to use. Here's how to get started:

```bash
# Check that Caddie.sh is working
caddie --version

# Get an overview of available commands
caddie help

# See what modules are available
caddie help
```

### Understanding the Command Structure

Caddie.sh uses a simple, intuitive command structure:

```bash
caddie <module>:<command> [arguments]
```

**Examples:**
- `caddie python:install requests` - Install Python package
- `caddie rust:test:unit` - Run Rust unit tests
- `caddie js:install-local express` - Install Node.js package locally

## Core Concepts

### Modules

Caddie.sh is built around modules, each handling a specific development area:

- **`core`**: Basic functions, debug system, and home directory management
- **`python`**: Python environment and package management
- **`rust`**: Rust development tools and project management
- **`ruby`**: Ruby environment with RVM integration
- **`js`**: JavaScript/Node.js tools and NVM management
- **`csv`** *(optional via [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools))*: SQL analytics and plotting for CSV/TSV datasets
- **`ios`**: App Store and TestFlight distribution tools
- **`cross`**: Multi-language project templates and tools
- **`mac`**: macOS workflow helpers and utilities
- **`mcp`**: MCP server shortcuts and deployment helpers
- **`debian`**: Debian package management helpers
- **`server`**: Remote server access and service controls
- **`cursor`**: IDE integration and AI-powered development
- **`git`**: Enhanced git workflows with SSH URLs, auto-detection, and GitHub integration
- **`cli`**: Color utilities and formatting functions

### Data Structures

Caddie.sh uses internal data structures to manage:

- **Commands**: Available commands across all modules
- **Help**: Module descriptions and help text
- **Modules**: Loaded module information
- **Debug**: Debug system configuration

## Essential Commands

### Getting Help

```bash
# General help
caddie help

# Launch interactive prompt
caddie

# Module-specific help
caddie python:help
caddie rust:help

# Command help
caddie core:help

# Reload caddie environment
caddie reload
```

### Interactive Prompt

Run `caddie` without arguments to enter an interactive prompt. Start with a module name and follow with subcommands, or use the traditional `module:command` form.

```bash
$ caddie
caddie-8.3.0> python venv create   # Equivalent to `caddie python:venv:create`
caddie-8.3.0> csv                  # Switch to the CSV module scope
caddie[csv]-8.3.0> set file data.csv
caddie[csv]-8.3.0> back            # Return to the root prompt
caddie-8.3.0> `ls -1`              # Inline shell command without leaving the REPL
caddie-8.3.0> shell git status     # One-off shell command through the shell scope
caddie-8.3.0> shell                # Enter shell scope
caddie[shell]-8.3.0> switch git    # Jump to another module from any scope
caddie-8.3.0> cargo test           # Long-running command
# Press Ctrl+C to cancel without exiting the REPL
caddie-8.3.0> exit                 # Leave the REPL entirely
```

The prompt supports Readline editing, history, and cursor controls (e.g., `Ctrl+A`, `Ctrl+E`, `Ctrl+P`). Caddie keeps the REPL history in `~/.caddie_history`, so commands stay recallable without touching your main shell history. `Ctrl+C` now interrupts the active command and drops you back at the same prompt instead of closing the session. While scoped, the prompt shows the active module (`caddie[module]-8.3.0>`). Use `back`, `up`, or `..` to return to the root prompt, or `switch <module>` to jump directly to another module from any scope.

### Debug System

```bash
# Enable debug output
caddie core:debug on

# Disable debug output
caddie core:debug off

# Check debug status
caddie core:debug status

# Reload caddie after configuration changes
caddie reload
```

### Home Directory Management

```bash
# Set your project home directory
caddie core:set:home ~/my-projects

# Check current home directory
caddie core:get:home

# Navigate to caddie home directory
caddie go:home

# Reset to default
caddie core:reset:home
```

### System Management

```bash
# Reload caddie environment and configuration
caddie reload

# Useful after making changes to:
# - caddie modules or configuration
# - ~/.bash_profile or ~/.bashrc
# - environment variables
# - module installations or updates
```

### Productivity Aliases

Caddie.sh includes 50+ productivity aliases that make development faster:

Legacy git aliases from `dot_bashrc` have been removed; use `caddie git:*` commands instead.

```bash
# View all available aliases
caddie core:aliases

# Search aliases by keyword
ag git          # or: caddie core:alias:grep git
ag docker       # or: caddie core:alias:grep docker

# View aliases by family
caddie core:alias:git
caddie core:alias:docker
caddie core:alias:npm
caddie core:alias:nav

# Common shortcuts you'll use daily
g              # git
gst            # git status
gl             # git pull
gp             # git push
d              # docker
ni             # npm install
ns             # npm start
r              # rails
c              # clear
ll             # ls -laGFH
```

**Navigation & File Management:**
```bash
bu, ud, dud    # cd .. (go back)
dir            # ls -FH
pcd            # pushd
```

**Development Workflow:**
```bash
maek, amek     # make (typo correction)
bim            # vim (typo correction)
ss             # source ~/.bashrc
shitory        # search history
externalip     # curl whatismyip.org
```

**iOS Distribution:**
```bash
ios:testflight # Run TestFlight workflow
ios:archive:testflight # Create archive for TestFlight
```

**Docker Commands:**
```bash
dps            # docker ps
dsp            # docker system prune
dcb            # docker compose build
dcu            # docker compose up
dcd            # docker compose down
```

**Git Workflow:**
```bash
ga             # git add
gaa            # git add -A
gc             # git commit
gc!            # git commit --amend
gdrop          # git add .; git stash; git stash drop
glo            # git log --oneline
```

**Package Management:**
```bash
bsl            # brew services list
nid            # npm install --save-dev
nrl            # npm run lint
nrt            # npm run test
nrtw           # npm run test -- --watch
```

### CSV Analytics (external module)

The CSV analytics commands (`csv:*`) now live in the standalone [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools) repository. Install the module to regain the full querying and plotting workflow:

```bash
git clone https://github.com/parnotfar/caddie-csv-tools.git
cd caddie-csv-tools
make install
caddie reload
```

Refer to that repository’s documentation for the latest command reference and usage examples.

Shared helpers live in `~/.caddie_modules/bin`; drop new executables there when building future analytics or tooling modules so they are available across the entire caddie runtime.

> 💡 **Pro Tip**: Use `ag <keyword>` or `caddie core:alias:grep <keyword>` to search aliases, and `caddie go:home` to quickly navigate to your caddie home directory!

## Module Usage

### Python Development

#### Virtual Environment Management

```bash
# Create a new virtual environment
caddie python:create myproject

# Activate an environment
caddie python:activate myproject

# Deactivate current environment
caddie python:deactivate

# List all environments
caddie python:list

# Remove an environment
caddie python:remove myproject
```

#### Package Management

```bash
# Install a package
caddie python:install requests

# Uninstall a package
caddie python:uninstall requests

# Generate requirements.txt
caddie python:freeze

# Install from requirements.txt
caddie python:sync

# Check for outdated packages
caddie python:outdated
```

#### Project Management

```bash
# Initialize project structure
caddie python:init

# Run tests
caddie python:test

# Run linting
caddie python:lint

# Format code
caddie python:format
```

### Rust Development

#### Project Management

```bash
# Create new project with proper .gitignore
caddie rust:init myapp

# Create new project (basic)
caddie rust:new myapp

# Build project
caddie rust:build

# Run project
caddie rust:run

# Run tests
caddie rust:test

# Check code without building
caddie rust:check

# Apply compiler suggestions
caddie rust:fix

# Apply fixes across all targets (libs, bins, tests, examples)
caddie rust:fix:all

# Clean build artifacts
caddie rust:clean
```

#### Git Integration

```bash
# Check git status for build artifacts
caddie rust:git:status

# Add comprehensive .gitignore to existing project
caddie rust:gitignore

# Remove tracked build artifacts from git
caddie rust:git:clean
```

#### Enhanced Git Workflows

Caddie.sh provides enhanced git commands with GitHub integration:

```bash
# Set up GitHub account (one-time setup)
caddie github:account:set parnotfar

# Clone repositories with auto-detection
caddie git:clone my-project

# Add remotes with auto-detection
caddie git:remote:add

# Set upstream for new repositories
caddie git:push:set:upstream

# Enhanced git operations
caddie git:commit "Add new feature"
caddie git:gacp "Quick commit and push"
caddie git:push
caddie git:pull

# Create and manage branches
caddie git:new:branch feature/new-feature

# Create pull requests
caddie git:pr:create "Add new feature" "Description of changes"
```

#### iOS Distribution

```bash
# Show project info
caddie ios:project:info

# Increment build number
caddie ios:increment:build

# Create TestFlight archive
caddie ios:archive:testflight
```

#### Dependency Management

```bash
# Add dependency
caddie rust:add serde

# Remove dependency
caddie rust:remove serde

# Update dependencies
caddie rust:update

# Search crates
caddie rust:search json

# Check for outdated dependencies
caddie rust:outdated

# Security audit
caddie rust:audit
```

#### Toolchain Management

```bash
# Switch toolchain
caddie rust:toolchain nightly

# Add target
caddie rust:target x86_64-unknown-linux-gnu

# Install component
caddie rust:component clippy
```

#### Advanced Testing

```bash
# Run unit tests only
caddie rust:test:unit

# Run integration tests only
caddie rust:test:integration

# Run all tests
caddie rust:test:all

# Run property-based tests
caddie rust:test:property

# Run benchmarks
caddie rust:test:bench

# Run tests in watch mode
caddie rust:test:watch

# Run tests with coverage
caddie rust:test:coverage
```

### Ruby Development

#### Environment Management

```bash
# Install Ruby version
caddie ruby:install 3.2.0

# Use specific version
caddie ruby:use 3.2.0

# Set default version
caddie ruby:default 3.2.0

# List installed versions
caddie ruby:list
```

#### Gem Management

```bash
# Install gem
caddie ruby:gem install rails

# Uninstall gem
caddie ruby:gem uninstall rails

# Update gems
caddie ruby:gem update

# List installed gems
caddie ruby:gem list
```

### JavaScript/Node.js Development

#### Version Management

```bash
# Install Node.js version
caddie js:install 18.16.0

# Use specific version
caddie js:use 18.16.0

# Set default version
caddie js:default 18.16.0

# List installed versions
caddie js:list
```

#### Package Management

```bash
# Install package globally
caddie js:install-global yarn

# Install package locally
caddie js:install-local express

# Update packages
caddie js:update

# Run npm scripts
caddie js:run dev
```

### iOS Distribution

#### Project Info and Versioning

```bash
# Show project settings
caddie ios:project:info

# Increment build number
caddie ios:increment:build

# Save project settings to config
caddie ios:config:load:project
```

#### TestFlight Workflow

```bash
# Create archive for TestFlight
caddie ios:archive:testflight

# Export IPA
caddie ios:export:ipa

# Upload to TestFlight
caddie ios:upload:testflight ./build/export/MyApp.ipa

# Full workflow (increment, archive, export, upload)
caddie ios:testflight
```

**Note:** Build/run/test commands live in the Swift module (`caddie swift:xcode:*`).

### Cross-Language Development

#### Project Templates

```bash
# Create web project
caddie cross:web mywebapp

# Create API project
caddie cross:api myapi

# Create full-stack project
caddie cross:fullstack myapp

# Create microservice
caddie cross:microservice userservice
```

#### Docker Integration

```bash
# Create Dockerfile
caddie cross:docker python

# Create docker-compose
caddie cross:compose

# Build and run
caddie cross:docker-build
```

### Cursor IDE Integration

#### Project Management

```bash
# Open project in Cursor
caddie cursor:open ~/my-project

# Create new project
caddie cursor:new python myapp

# Switch between projects
caddie cursor:switch project2
```

#### AI-Powered Development

```bash
# Explain code
caddie cursor:ai:explain src/main.py

# Refactor code
caddie cursor:ai:refactor src/utils.py

# Generate tests
caddie cursor:ai:test src/models.py

# Code review
caddie cursor:ai:review src/
```

#### Extension Management

```bash
# Install extension
caddie cursor:ext:install ms-python.python

# List extensions
caddie cursor:ext:list

# Update extensions
caddie cursor:ext:update

# Sync extensions
caddie cursor:ext:sync
```

### CLI Utilities

The CLI module provides sophisticated color output and formatting functions for creating better command-line interfaces:

#### Basic Color Output

```bash
# Success messages
caddie cli:green "✓ Installation completed successfully"
caddie cli:green:bold "SUCCESS: All tests passed"

# Error messages
caddie cli:red "Error: File not found"
caddie cli:red:bold "CRITICAL: Database connection failed"

# Warning messages
caddie cli:yellow "Warning: Deprecated feature used"
caddie cli:orange "⚠️  Please update your configuration"

# Information
caddie cli:blue "Info: Processing 150 files..."
caddie cli:cyan "Debug: Function called with args: $@"
```

#### UTF-8 Character Functions

```bash
# Status indicators
caddie cli:check "Task completed successfully"
caddie cli:x "Operation failed"
caddie cli:arrow "Next step"
caddie cli:warning "Warning message"

# Section headers
caddie cli:folder "File operations"
caddie cli:wrench "Development tools"
caddie cli:whale "Docker operations"
caddie cli:package "Package management"
caddie cli:git "Git workflow"
caddie cli:rocket "Rails development"
caddie cli:thought "Tips and ideas"
caddie cli:magnifying_glass "Search operations"

# Utility
caddie cli:debug "Debug information"
caddie cli:blank
```

#### Utility Functions

```bash
# Section headers
caddie cli:title "Caddie.sh Installation"

# Usage text
caddie cli:usage "caddie <module>:<command> [options]"

# Status indicators
caddie cli:installed
caddie cli:complete

# Color reference
caddie cli:colorlist
```

#### Integration Examples

Use CLI functions in your scripts and modules:

```bash
#!/bin/bash
source ~/.caddie_cli

# Show progress
caddie cli:blue "Starting installation..."
caddie cli:green "✓ Dependencies installed"
caddie cli:yellow "⚠️  Some optional packages failed"
caddie cli:title "Installation Summary"
```

> 💡 **Pro Tip**: Use consistent colors across your modules - red for errors, green for success, yellow for warnings, blue for info!

## Advanced Usage

### Customization

#### Shell Prompt

Customize your shell prompt by editing `~/.caddie_prompt.sh`:

```bash
# Edit the prompt file
nano ~/.caddie_prompt.sh

# Reload the prompt
source ~/.caddie_prompt.sh
```

#### Environment Variables

Set custom environment variables:

```bash
# Add to your ~/.bash_profile
export CADDIE_CUSTOM_VAR="value"
export CADDIE_DEBUG=1
```

#### Module Configuration

Some modules support configuration files:

```bash
# Python configuration
~/.caddie_python_config

# Rust configuration
~/.caddie_rust_config
```

### Automation

#### Scripts

Create scripts that use Caddie.sh:

```bash
#!/bin/bash
# setup-dev.sh

# Set up development environment
caddie python:create venv
caddie python:activate venv
caddie python:install -r requirements.txt
caddie rust:new backend
caddie cursor:open .
```

#### CI/CD Integration

Use Caddie.sh in your CI/CD pipelines:

```yaml
# .github/workflows/setup.yml
- name: Setup Development Environment
  run: |
    git clone https://github.com/parnotfar/caddie.sh.git
    cd caddie.sh
    make install-dot
    source ~/.bash_profile
    caddie python:create ci-env
    caddie python:activate ci-env
```

### Troubleshooting

#### Debug Mode

Enable debug mode to see what's happening:

```bash
caddie core:debug on
# Run your command
caddie python:create test
# Check debug output
caddie core:debug off
```

#### Common Issues

**Command not found:**
```bash
source ~/.bash_profile
```

**Permission denied:**
```bash
ls -la ~/
chmod 755 ~/
```

**Module not loading:**
```bash
ls -la ~/.caddie_modules/
caddie core:debug on
caddie help
```

## Best Practices

### Project Organization

1. **Use consistent naming**: Follow your team's conventions
2. **Set project home**: `caddie core:set:home ~/projects`
3. **Use virtual environments**: Always create isolated environments
4. **Version control**: Keep your Caddie.sh configuration in version control

### Environment Management

1. **One environment per project**: Avoid conflicts
2. **Regular updates**: Keep tools and packages current
3. **Cleanup**: Remove unused environments and packages
4. **Documentation**: Document your setup process

### Performance

1. **Lazy loading**: Modules load only when needed
2. **Efficient commands**: Use specific commands rather than general ones
3. **Debug off**: Keep debug mode off in production
4. **Regular maintenance**: Clean up old files and environments

### Code Quality

1. **Use the linter**: Run `caddie core:lint` regularly to maintain code standards
   - `caddie core:lint` - Shows ALL issues (comprehensive view)
   - `caddie core:lint:limit <n>` - Shows max n issues per check (focused debugging)
2. **Follow caddie conventions**: Use `caddie cli:*` functions for consistent output
3. **Avoid variable shadowing**: Don't declare `local` variables inside conditional blocks that shadow outer variables
4. **Lint ignore blocks**: Use `# caddie:lint:disable` and `# caddie:lint:enable` for exceptions
5. **Document exceptions**: Always explain why you're using ignore blocks

#### Lint Ignore Blocks

When you need to suppress linting warnings for specific code sections:

```bash
# caddie:lint:disable
function complex_function() {
    # This entire function will be ignored by the linter
    echo "This won't trigger warnings"
    local var=value  # This won't trigger local variable warnings
    # Any other code that would normally trigger warnings
}
# caddie:lint:enable
```

**Use cases:**
- Linter implementation code (prevents self-flagging)
- Legacy code during refactoring
- Third-party code that doesn't follow caddie standards
- Complex edge cases that legitimately need to break standards

## Integration with Other Tools

### Version Control

Caddie.sh works seamlessly with Git:

```bash
# Initialize git repository
git init

# Create .gitignore
caddie python:init  # Creates Python .gitignore
caddie rust:new .    # Creates Rust .gitignore

# Commit your setup
git add .
git commit -m "Initial project setup with Caddie.sh"
```

### Package Managers

Integrate with language-specific package managers:

```bash
# Python: pip + requirements.txt
caddie python:freeze > requirements.txt
caddie python:sync

# Rust: Cargo.toml
caddie rust:add serde
caddie rust:build

# Node.js: package.json
caddie js:install-local express
npm run dev
```

### IDEs and Editors

Caddie.sh enhances your development workflow:

```bash
# Open in Cursor
caddie cursor:open .

# Open in VS Code
code .

# Open in Vim
vim .
```

## Getting Help

### Built-in Help

```bash
# General help
caddie help

# Module help
caddie python:help

# Command help
caddie core:help
```

### External Resources

- **GitHub Issues**: Report bugs and request features
- **GitHub Discussions**: Ask questions and share tips
- **Documentation**: Check the [docs directory](modules/) for detailed information
- **Community**: Join our community channels

### Contributing

Found a bug or want to add a feature?

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Add tests** (when applicable)
5. **Submit a pull request**

## Next Steps

Now that you're familiar with Caddie.sh:

1. **Explore modules**: Try different commands and features
2. **Customize your environment**: Set up your preferred configuration
3. **Create projects**: Use Caddie.sh to scaffold new projects
4. **Share your experience**: Help others in the community
5. **Contribute**: Add new features or improve existing ones

---

*Happy coding with Caddie.sh! 🏌️‍♂️*

For more detailed information, check out the [Module Documentation](modules/) and [Configuration Guide](configuration.md).
