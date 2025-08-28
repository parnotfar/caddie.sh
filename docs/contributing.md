# Contributing Guide

Thank you for your interest in contributing to Caddie.sh! This guide will help you get started with contributing to the project.

## Overview

Caddie.sh is an open-source project that aims to make development environment management effortless and consistent. We welcome contributions from developers of all skill levels.

## Ways to Contribute

### Code Contributions

- **Bug fixes**: Fix issues and improve reliability
- **New features**: Add new functionality to existing modules
- **New modules**: Create modules for additional languages or tools
- **Documentation**: Improve or expand documentation
- **Tests**: Add test coverage for existing functionality

### Non-Code Contributions

- **Bug reports**: Report issues you encounter
- **Feature requests**: Suggest new features or improvements
- **Documentation**: Help improve guides and examples
- **Community support**: Help other users in discussions
- **Testing**: Test new features and report feedback

## Getting Started

### Prerequisites

- **Git**: Version control system
- **Bash**: Shell scripting knowledge
- **macOS**: Development environment (for testing)
- **GitHub account**: For collaboration

### Development Environment Setup

1. **Fork the repository**:
   ```bash
   # Go to GitHub and fork the repository
   # Then clone your fork
   git clone https://github.com/yourusername/caddie.sh.git
   cd caddie.sh
   ```

2. **Set up upstream remote**:
   ```bash
   git remote add upstream https://github.com/originalusername/caddie.sh.git
   git fetch upstream
   ```

3. **Install development dependencies**:
   ```bash
   make setup-dev
   ```

4. **Install Caddie.sh locally**:
   ```bash
   make install-dot
   source ~/.bash_profile
   ```

5. **Verify installation**:
   ```bash
   caddie --version
   caddie help
   ```

## Development Workflow

### Branch Strategy

We use a simple branch strategy:

- **`main`**: Production-ready code
- **`develop`**: Development branch (when implemented)
- **`feature/*`**: Feature branches
- **`bugfix/*`**: Bug fix branches
- **`hotfix/*`**: Critical bug fixes

### Future Development Workflow Commands

We're planning to add core Caddie.sh functions to streamline development workflows:

```bash
# Quick development setup
caddie core:dev:setup                    # Setup development environment
caddie core:dev:branch feature-name      # Create and switch to feature branch
caddie core:dev:commit "message"         # Add, commit, and push changes
caddie core:dev:pr                       # Create pull request
caddie core:dev:sync                     # Sync with upstream main
caddie core:dev:cleanup                  # Clean up feature branches

# Project management
caddie core:dev:test                     # Run all tests
caddie core:dev:lint                     # Run linting
caddie core:dev:format                   # Format code
caddie core:dev:build                    # Build project
caddie core:dev:release                  # Prepare release
```

#### Benefits of These Commands

- **Standardization**: Consistent workflow across all contributors
- **Automation**: Reduce manual steps and potential errors
- **Integration**: Seamless integration with existing Caddie.sh modules
- **Learning**: Easier onboarding for new contributors
- **Efficiency**: Faster development cycles with fewer mistakes

#### Integration with Existing Modules

These development commands would integrate with your existing modules:
- **Python**: `caddie core:dev:test` would run `caddie python:test`
- **Rust**: `caddie core:dev:build` would run `caddie rust:build`
- **Git**: `caddie core:dev:commit` would use git module functions
- **Cross-language**: `caddie core:dev:lint` would detect and run appropriate linters

### Creating a Feature Branch

#### Traditional Git Commands
```bash
# Ensure you're on main and up to date
git checkout main
git pull upstream main

# Create and switch to feature branch
git checkout -b feature/your-feature-name

# Make your changes
# ... edit files ...

# Commit your changes
git add .
git commit -m "feat: add new feature description"

# Push to your fork
git push origin feature/your-feature-name
```

#### Using Caddie.sh (if git module is available)
```bash
# Ensure you're on main and up to date
caddie git:checkout main
caddie git:pull upstream main

# Create and switch to feature branch
caddie git:checkout -b feature/your-feature-name

# Make your changes
# ... edit files ...

# Commit your changes
caddie git:add .
caddie git:commit "feat: add new feature description"

# Push to your fork
caddie git:push origin feature/your-feature-name
```

### Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```bash
git commit -m "feat: add Python virtual environment management"
git commit -m "fix: resolve debug function export issue"
git commit -m "docs: update installation guide with troubleshooting"
git commit -m "style: format shell scripts with consistent indentation"
```

### Pull Request Process

1. **Create a pull request** from your feature branch to the main repository
2. **Fill out the PR template** with:
   - Description of changes
   - Related issues
   - Testing performed
   - Screenshots (if applicable)

3. **Wait for review** from maintainers
4. **Address feedback** and make requested changes
5. **Merge** when approved

## Code Standards

### Shell Script Standards

#### General Guidelines

- **Use Bash**: Write for Bash 4.0+ compatibility
- **Error handling**: Always check for errors and provide meaningful messages
- **Documentation**: Include comments for complex logic
- **Consistency**: Follow existing code style and patterns

#### Code Style

```bash
# ✅ Good: Clear variable names with braces
local filename="$1"
echo "Processing file: ${filename}"

# ❌ Bad: Unclear names, no braces
local f="$1"
echo "Processing file: $f"

# ✅ Good: Proper error handling
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found" >&2
    return 1
fi

# ❌ Bad: No error handling
cat "$filename"
```

#### Function Structure

```bash
# ✅ Good: Proper function structure
function caddie_module_command() {
    local argument="$1"
    local option="$2"
    
    # Validate input
    if [ -z "$argument" ]; then
        echo "Error: Argument required" >&2
        echo "Usage: caddie module:command <argument>" >&2
        return 1
    fi
    
    # Main logic
    if [ "$option" = "verbose" ]; then
        echo "Processing: $argument"
    fi
    
    # Perform action
    process_argument "$argument"
    
    echo "✓ Command completed successfully"
}

# ❌ Bad: Poor structure
function bad_function() {
    # No validation
    # No error handling
    # Unclear logic
    do_something "$1"
}
```

#### Variable Usage

```bash
# ✅ Good: Proper variable handling
local user_input="$1"
local sanitized_input=$(echo "$user_input" | tr -d '[:space:]')

if [ -n "$sanitized_input" ]; then
    process_input "$sanitized_input"
fi

# ❌ Bad: Unsafe variable usage
input=$1
process_input $input
```

### Module Development Standards

#### Module Structure

Each module should follow this structure:

```bash
#!/bin/bash

# Module Name
# Brief description of what the module does

# Function to register commands with the main system
function caddie_module_caddie_register() {
    caddie_commands_append "module:command1"
    caddie_commands_append "module:command2"
}

# Function to register help text
function caddie_module_help_register() {
    caddie_help_append "module:command1"
    caddie_help_append "module:command2"
}

# Function to provide module description
function caddie_module_description() {
    echo 'Brief description of the module'
}

# Main command functions
function caddie_module_command1() {
    local argument="$1"
    
    # Implementation
}

function caddie_module_command2() {
    local argument="$1"
    
    # Implementation
}

# Export functions
export -f caddie_module_caddie_register
export -f caddie_module_help_register
export -f caddie_module_description
export -f caddie_module_command1
export -f caddie_module_command2
```

#### Command Naming Convention

- **Format**: `module:action` or `module:category:action`
- **Examples**:
  - `python:create` - Create Python environment
  - `rust:new` - Create new Rust project
  - `cursor:ai:explain` - AI-powered code explanation
  - `core:debug:on` - Enable debug mode

#### Error Handling

```bash
# ✅ Good: Comprehensive error handling
function caddie_module_command() {
    local argument="$1"
    
    # Input validation
    if [ -z "$argument" ]; then
        echo "Error: Argument required" >&2
        echo "Usage: caddie module:command <argument>" >&2
        return 1
    fi
    
    # File existence check
    if [ ! -f "$argument" ]; then
        echo "Error: File '$argument' not found" >&2
        return 1
    fi
    
    # Permission check
    if [ ! -r "$argument" ]; then
        echo "Error: File '$argument' not readable" >&2
        return 1
    fi
    
    # Main logic with error handling
    if ! process_file "$argument"; then
        echo "Error: Failed to process file '$argument'" >&2
        return 1
    fi
    
    echo "✓ File processed successfully"
}
```

#### Debug Integration

```bash
# ✅ Good: Debug integration
function caddie_module_command() {
    local argument="$1"
    
    caddie_debug "=== module:command called ==="
    caddie_debug "argument: $argument"
    
    # Implementation
    caddie_debug "Processing argument: $argument"
    
    if [ -z "$argument" ]; then
        caddie_debug "Argument validation failed"
        echo "Error: Argument required" >&2
        return 1
    fi
    
    caddie_debug "Argument validation passed"
    # ... rest of implementation
}
```

## Testing

### Manual Testing

1. **Install your changes**:
   ```bash
   make install-dot
   source ~/.bash_profile
   ```

2. **Test functionality**:
   ```bash
   # Test your new command
   caddie yourmodule:command
   
   # Test help system
   caddie yourmodule:help
   
   # Test integration
   caddie help
   ```

3. **Test error cases**:
   ```bash
   # Test with invalid arguments
   caddie yourmodule:command
   
   # Test with missing files
   caddie yourmodule:command nonexistent
   ```

### Automated Testing

When we implement automated testing:

```bash
# Run all tests
make test

# Run specific test suite
make test-unit
make test-integration

# Run tests with coverage
make test-coverage
```

## Documentation

### Code Documentation

- **Function headers**: Include purpose, arguments, and return values
- **Complex logic**: Add inline comments explaining the reasoning
- **Examples**: Include usage examples in comments

```bash
# Function to create a new project
# Arguments:
#   $1 - Project name (required)
#   $2 - Project type (optional, defaults to 'basic')
# Returns:
#   0 on success, 1 on failure
function caddie_project_create() {
    local project_name="$1"
    local project_type="${2:-basic}"
    
    # Validate project name
    if [ -z "$project_name" ]; then
        echo "Error: Project name required" >&2
        return 1
    fi
    
    # Check if project already exists
    if [ -d "$project_name" ]; then
        echo "Error: Project '$project_name' already exists" >&2
        return 1
    fi
    
    # Create project based on type
    case "$project_type" in
        "basic")
            create_basic_project "$project_name"
            ;;
        "web")
            create_web_project "$project_name"
            ;;
        *)
            echo "Error: Unknown project type '$project_type'" >&2
            return 1
            ;;
    esac
}
```

### User Documentation

- **README updates**: Update README.md for new features
- **Module documentation**: Create or update module docs
- **Examples**: Provide practical usage examples
- **Screenshots**: Include visual examples when helpful

## Review Process

### Code Review Checklist

Before submitting a PR, ensure:

- [ ] **Code follows style guidelines**
- [ ] **Functions are properly documented**
- [ ] **Error handling is comprehensive**
- [ ] **Debug statements are included**
- [ ] **Tests pass** (when implemented)
- [ ] **Documentation is updated**
- [ ] **Commit messages follow convention**

### Review Feedback

When receiving feedback:

1. **Read carefully**: Understand the feedback completely
2. **Ask questions**: Clarify anything unclear
3. **Make changes**: Implement suggested improvements
4. **Resubmit**: Push updated changes to your branch

## Release Process

### Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist

- [ ] **All tests pass**
- [ ] **Documentation is current**
- [ ] **Changelog is updated**
- [ ] **Version is bumped**
- [ ] **Release notes are prepared**

## Community Guidelines

### Communication

- **Be respectful**: Treat all contributors with respect
- **Be constructive**: Provide helpful, constructive feedback
- **Be patient**: Development takes time and iteration
- **Be inclusive**: Welcome contributors of all backgrounds

### Getting Help

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Pull Requests**: For code contributions
- **Documentation**: Check existing docs first

## Recognition

### Contributors

All contributors are recognized in:

- **README.md**: List of contributors
- **CHANGELOG.md**: Detailed contribution history
- **GitHub**: Contributor statistics and graphs

### Special Recognition

- **First-time contributors**: Welcome and guidance
- **Major contributors**: Special mention in releases
- **Documentation contributors**: Recognition for improving user experience

## Getting Help

### Questions and Support

- **GitHub Issues**: Create an issue for bugs or feature requests
- **GitHub Discussions**: Start a discussion for questions
- **Documentation**: Check the docs directory first
- **Community**: Engage with other contributors

### Mentorship

New contributors can:

- **Ask for help**: Don't hesitate to ask questions
- **Request review**: Ask for code review and feedback
- **Start small**: Begin with documentation or small fixes
- **Learn from others**: Study existing code and patterns

## Resources

### Learning Resources

- **[Bash Guide](https://mywiki.wooledge.org/BashGuide)**: Comprehensive Bash scripting guide
- **[Shell Scripting Tutorial](https://www.shellscript.sh/)**: Online shell scripting tutorial
- **[GitHub Guides](https://guides.github.com/)**: GitHub collaboration guides
- **[Open Source Guide](https://opensource.guide/)**: Contributing to open source

### Tools

- **ShellCheck**: Shell script analysis tool
- **Bash Debug**: Bash debugging utilities
- **Git**: Version control system
- **GitHub**: Collaboration platform

## Next Steps

Ready to contribute? Here's how to get started:

1. **Fork the repository** on GitHub
2. **Set up your development environment**
3. **Pick an issue** to work on (start with "good first issue" labels)
4. **Create a feature branch**
5. **Make your changes**
6. **Submit a pull request**

We're excited to see your contributions! 🚀

---

*Thank you for contributing to Caddie.sh! Together, we can make development environment management better for everyone.*
