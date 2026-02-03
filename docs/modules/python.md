# Python Module

The Python module provides comprehensive Python environment management, including virtual environments, package management, and project scaffolding.

## Overview

The Python module is designed to make Python development effortless and consistent. It provides:

- **Virtual Environment Management**: Create, activate, and manage isolated Python environments
- **Package Management**: Install, uninstall, and manage Python packages
- **Project Scaffolding**: Initialize new Python projects with proper structure
- **Development Tools**: Testing, linting, and code formatting utilities

## Commands

### Environment Summary

#### `caddie python:info`

Show Python toolchain summary (python, pip, virtualenv status).

### Virtual Environment Management

#### `caddie python:create <name>`

Create a new Python virtual environment.

**Arguments:**
- `name`: Name of the virtual environment

**Examples:**
```bash
# Create a new environment
caddie python:create myproject

# Create environment with descriptive name
caddie python:create web-api-backend
```

**What it does:**
- Creates a new virtual environment in `~/.virtualenvs/<name>`
- Uses `python3 -m venv` for environment creation
- Provides activation instructions

**Output:**
```
Creating virtual environment 'myproject'...
✓ Virtual environment 'myproject' created successfully
  Location: /Users/username/.virtualenvs/myproject
  Activate with: caddie python:activate myproject
```

**Requirements:**
- Python 3.7+ installed
- `~/.virtualenvs` directory (created automatically)

#### `caddie python:activate <name>`

Activate a Python virtual environment.

**Arguments:**
- `name`: Name of the virtual environment to activate

**Examples:**
```bash
# Activate environment
caddie python:activate myproject

# Activate different environment
caddie python:activate backend-api
```

**What it does:**
- Sources the virtual environment's activation script
- Updates `VIRTUAL_ENV` environment variable
- Modifies `PATH` to prioritize virtual environment binaries
- Shows current Python and pip locations

**Output:**
```
Activating virtual environment 'myproject'...
✓ Virtual environment 'myproject' activated
  Python: /Users/username/.virtualenvs/myproject/bin/python
  Pip: /Users/username/.virtualenvs/myproject/bin/pip
```

**Requirements:**
- Virtual environment must exist
- Environment must have valid activation script

#### `caddie python:deactivate`

Deactivate the currently active Python virtual environment.

**Examples:**
```bash
caddie python:deactivate
```

**What it does:**
- Runs the `deactivate` function
- Restores original `PATH` and environment variables
- Unsets `VIRTUAL_ENV` variable

**Output:**
```
Deactivating virtual environment...
✓ Virtual environment deactivated
```

**Requirements:**
- Must have an active virtual environment

#### `caddie python:list`

List all available Python virtual environments.

**Examples:**
```bash
caddie python:list
```

**What it does:**
- Scans `~/.virtualenvs` directory
- Shows all available environments
- Indicates which environment is currently active

**Output:**
```
Available Python virtual environments:
=====================================
  ✓ myproject (active)
    backend-api
    web-frontend
    data-analysis
```

**Requirements:**
- `~/.virtualenvs` directory must exist

#### `caddie python:remove <name>`

Remove a Python virtual environment.

**Arguments:**
- `name`: Name of the virtual environment to remove

**Examples:**
```bash
# Remove environment
caddie python:remove old-project

# Remove unused environment
caddie python:remove test-env
```

**What it does:**
- Deletes the virtual environment directory
- Removes all packages and dependencies
- Cannot remove currently active environment

**Output:**
```
Removing virtual environment 'old-project'...
✓ Virtual environment 'old-project' removed successfully
```

**Requirements:**
- Environment must exist
- Environment must not be currently active

#### `caddie python:current`

Show information about the current Python environment.

**Examples:**
```bash
caddie python:current
```

**What it does:**
- Shows current virtual environment (if active)
- Displays Python and pip versions
- Shows system Python information if no virtual environment

**Output with active environment:**
```
Current Python environment:
  Virtual Environment: /Users/username/.virtualenvs/myproject
  Python: /Users/username/.virtualenvs/myproject/bin/python
  Python Version: Python 3.11.5
  Pip: /Users/username/.virtualenvs/myproject/bin/pip
  Pip Version: pip 23.2.1
```

**Output without active environment:**
```
No virtual environment is currently active
System Python: /usr/bin/python3
System Python Version: Python 3.11.5
```

### Package Management

#### `caddie python:install <package>`

Install a Python package in the current environment.

**Arguments:**
- `package`: Package name to install

**Examples:**
```bash
# Install single package
caddie python:install requests

# Install with specific version
caddie python:install "django==4.2.0"

# Install development package
caddie python:install pytest
```

**What it does:**
- Uses pip to install the package
- Installs in current virtual environment (if active)
- Warns if no virtual environment is active
- Prompts for confirmation when using system Python

**Output:**
```
Installing package 'requests'...
✓ Package 'requests' installed successfully
```

**Requirements:**
- pip must be available
- Virtual environment recommended (but not required)

#### `caddie python:uninstall <package>`

Uninstall a Python package from the current environment.

**Arguments:**
- `package`: Package name to uninstall

**Examples:**
```bash
# Uninstall package
caddie python:uninstall requests

# Uninstall development package
caddie python:uninstall pytest
```

**What it does:**
- Uses pip to uninstall the package
- Removes package and its dependencies
- Works in current virtual environment or system Python

**Output:**
```
Uninstalling package 'requests'...
✓ Package 'requests' uninstalled successfully
```

**Requirements:**
- pip must be available
- Package must be installed

#### `caddie python:freeze`

Generate a requirements.txt file from the current environment.

**Examples:**
```bash
caddie python:freeze
```

**What it does:**
- Runs `pip freeze` to capture all installed packages
- Saves output to `requirements.txt` in current directory
- Shows count of packages captured

**Output:**
```
Generating requirements.txt...
✓ requirements.txt generated successfully
  Packages: 15
```

**Requirements:**
- pip must be available
- Virtual environment recommended for clean output

#### `caddie python:sync`

Install packages from a requirements.txt file.

**Examples:**
```bash
caddie python:sync
```

**What it does:**
- Reads `requirements.txt` from current directory
- Installs all listed packages
- Uses current environment (virtual or system)

**Output:**
```
Installing packages from requirements.txt...
✓ Packages installed successfully from requirements.txt
```

**Requirements:**
- `requirements.txt` file must exist
- pip must be available

#### `caddie python:upgrade <package>`

Upgrade a specific Python package.

**Arguments:**
- `package`: Package name to upgrade

**Examples:**
```bash
# Upgrade package
caddie python:upgrade requests

# Upgrade framework
caddie python:upgrade django
```

**What it does:**
- Uses pip to upgrade the package to latest version
- Maintains compatibility with other packages
- Works in current environment

**Output:**
```
Upgrading package 'requests'...
✓ Package 'requests' upgraded successfully
```

**Requirements:**
- pip must be available
- Package must be installed

#### `caddie python:outdated`

Check for outdated Python packages.

**Examples:**
```bash
caddie python:outdated
```

**What it does:**
- Runs `pip list --outdated`
- Shows packages with available updates
- Displays current and latest versions

**Output:**
```
Checking for outdated packages...
Package    Version  Latest   Type
---------- -------  -------  ----
requests   2.28.2   2.31.0   wheel
django     4.1.7    4.2.0    wheel
```

**Requirements:**
- pip must be available
- Internet connection for version checking

### Project Management

#### `caddie python:init`

Initialize a new Python project structure.

**Examples:**
```bash
# Initialize in current directory
caddie python:init

# Create new directory and initialize
mkdir myproject && cd myproject
caddie python:init
```

**What it does:**
- Creates standard Python project structure
- Generates `setup.py` with project configuration
- Creates `.gitignore` with Python-specific exclusions
- Sets up `src/`, `tests/`, and `docs/` directories

**Output:**
```
Initializing Python project structure...
✓ Python project structure initialized
  Created: src/, tests/, docs/, README.md, .gitignore, setup.py
```

**Created Structure:**
```
.
├── src/
│   └── __init__.py
├── tests/
│   └── __init__.py
├── docs/
├── README.md
├── .gitignore
└── setup.py
```

**Requirements:**
- Must be run in project directory
- Directory should be empty or contain only version control files

#### `caddie python:test`

Run Python tests in the current project.

**Examples:**
```bash
# Run all tests
caddie python:test

# Run tests in specific environment
caddie python:activate test-env
caddie python:test
```

**What it does:**
- Detects and runs available test frameworks
- Prioritizes pytest if available
- Falls back to unittest if no pytest
- Provides helpful guidance if no tests found

**Output with pytest:**
```
Running Python tests...
======================== test session starts =========================
platform darwin -- Python 3.11.5, pytest-7.4.0, pluggy-1.2.0
collected 5 items

test_example.py .....
======================== 5 passed in 0.02s =========================
```

**Output with unittest:**
```
Running Python tests...
test_example (__main__.TestExample) ... ok

----------------------------------------------------------------------
Ran 1 test in 0.001s

OK
```

**Requirements:**
- Test files must exist in `tests/` directory
- pytest or unittest must be available

#### `caddie python:lint`

Run Python linting tools on the current project.

**Examples:**
```bash
# Run linting
caddie python:lint

# Lint specific directories
caddie python:lint src/ tests/
```

**What it does:**
- Detects available linting tools
- Prioritizes flake8 if available
- Falls back to pylint if no flake8
- Lints source and test directories

**Output with flake8:**
```
Running Python linting...
src/main.py:15:1: E302 expected 2 blank lines, found 1
src/utils.py:25:80: E501 line too long (82 > 79 characters)
```

**Output with pylint:**
```
Running Python linting...
************* Module src.main
src/main.py:15:0: C0116: Missing function or method docstring
src/main.py:20:0: C0103: Variable name "x" doesn't conform to snake_case naming style
```

**Requirements:**
- flake8 or pylint must be installed
- Source code must exist

#### `caddie python:format`

Format Python code in the current project.

**Examples:**
```bash
# Format all code
caddie python:format

# Format specific directories
caddie python:format src/ tests/
```

**What it does:**
- Detects available formatting tools
- Prioritizes black if available
- Falls back to autopep8 if no black
- Formats source and test directories

**Output with black:**
```
Running Python formatting...
reformatted src/main.py
reformatted src/utils.py
reformatted tests/test_main.py
All done! ✨ 🍰 ✨
3 files reformatted.
```

**Output with autopep8:**
```
Running Python formatting...
[file:src/main.py] applying pep8 fixes
[file:src/utils.py] applying pep8 fixes
```

**Requirements:**
- black or autopep8 must be installed
- Source code must exist

## Environment Variables

### `VIRTUAL_ENV`

**Purpose**: Path to currently active virtual environment
**Set by**: `caddie python:activate <name>`
**Unset by**: `caddie python:deactivate`
**Default**: Not set

**Usage:**
```bash
if [ -n "$VIRTUAL_ENV" ]; then
    echo "Active environment: $VIRTUAL_ENV"
    echo "Environment name: $(basename "$VIRTUAL_ENV")"
fi
```

### `PATH`

**Purpose**: Modified to prioritize virtual environment binaries
**Modified by**: Virtual environment activation
**Restored by**: Virtual environment deactivation

**Usage:**
```bash
# Check which python is being used
which python
which pip

# Should point to virtual environment if active
```

## Configuration Files

### `~/.virtualenvs/`

**Purpose**: Directory containing all Python virtual environments
**Created by**: First `caddie python:create` command
**Permissions**: `755` (readable and executable by user, readable by group/others)

**Structure:**
```
~/.virtualenvs/
├── myproject/
│   ├── bin/
│   ├── lib/
│   └── pyvenv.cfg
├── backend-api/
│   ├── bin/
│   ├── lib/
│   └── pyvenv.cfg
└── web-frontend/
    ├── bin/
    ├── lib/
    └── pyvenv.cfg
```

### `setup.py`

**Purpose**: Python package configuration file
**Created by**: `caddie python:init`
**Format**: Python setuptools configuration

**Example content:**
```python
from setuptools import setup, find_packages

setup(
    name="myproject",
    version="0.1.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.7",
    install_requires=[],
    extras_require={
        "dev": [
            "pytest>=6.0",
            "black",
            "flake8",
            "mypy",
        ],
    },
)
```

### `.gitignore`

**Purpose**: Git ignore patterns for Python projects
**Created by**: `caddie python:init`
**Format**: Git ignore patterns

**Example content:**
```
# Python
__pycache__/
*.py[cod]
*.pyc
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

## Error Handling

### Common Errors

#### "Error: Please provide a name for the virtual environment"
**Cause**: No environment name provided
**Solution**: Provide a name: `caddie python:create myproject`

#### "Error: Virtual environment 'name' already exists"
**Cause**: Environment with that name already exists
**Solution**: Use a different name or remove existing: `caddie python:remove name`

#### "Error: Virtual environment 'name' does not exist"
**Cause**: Environment doesn't exist
**Solution**: Create it first: `caddie python:create name`

#### "Error: Cannot remove currently active virtual environment"
**Cause**: Trying to remove active environment
**Solution**: Deactivate first: `caddie python:deactivate`

#### "Error: requirements.txt not found in current directory"
**Cause**: No requirements.txt file
**Solution**: Generate one: `caddie python:freeze`

### Error Output Format

All errors follow a consistent format:
```
Error: <description>
Usage: caddie python:<command> <arguments>
```

## Best Practices

### Virtual Environment Management

1. **One environment per project**: Avoid conflicts and dependency issues
2. **Descriptive names**: Use names that clearly identify the project
3. **Regular cleanup**: Remove unused environments to save disk space
4. **Version control**: Don't commit virtual environment directories

### Package Management

1. **Use requirements.txt**: Always capture dependencies
2. **Pin versions**: Specify exact versions for production
3. **Separate dev dependencies**: Use extras_require for development tools
4. **Regular updates**: Keep packages current for security

### Project Structure

1. **Follow standards**: Use src/ layout for packages
2. **Include tests**: Always have a tests/ directory
3. **Documentation**: Maintain README.md and docstrings
4. **Git integration**: Use proper .gitignore patterns

### Development Workflow

1. **Activate environment**: Always activate before development
2. **Install dependencies**: Install packages in virtual environment
3. **Run tests**: Test before committing changes
4. **Format code**: Maintain consistent code style

## Examples

### Complete Project Setup

```bash
#!/bin/bash
# setup-project.sh

# Create and activate virtual environment
caddie python:create myproject
caddie python:activate myproject

# Initialize project structure
caddie python:init

# Install development dependencies
caddie python:install pytest
caddie python:install black
caddie python:install flake8

# Generate requirements
caddie python:freeze

echo "Project setup complete!"
```

### Development Workflow

```bash
#!/bin/bash
# dev-workflow.sh

# Activate environment
caddie python:activate myproject

# Install new dependency
caddie python:install requests

# Run tests
caddie python:test

# Format code
caddie python:format

# Lint code
caddie python:lint

# Update requirements
caddie python:freeze
```

### CI/CD Integration

```bash
#!/bin/bash
# ci-setup.sh

# Create CI environment
caddie python:create ci-env
caddie python:activate ci-env

# Install dependencies
caddie python:sync

# Run tests
caddie python:test

# Run linting
caddie python:lint

# Cleanup
caddie python:deactivate
caddie python:remove ci-env
```

### Environment Management

```bash
#!/bin/bash
# manage-envs.sh

echo "Python Environment Manager"
echo "========================="

# List all environments
caddie python:list

# Show current environment
caddie python:current

# Create new environment
read -p "Create new environment? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Environment name: " env_name
    caddie python:create "$env_name"
fi
```

## Troubleshooting

### Virtual Environment Issues

1. **Environment not activating:**
   ```bash
   ls -la ~/.virtualenvs/environment-name/bin/activate
   source ~/.virtualenvs/environment-name/bin/activate
   ```

2. **Environment corrupted:**
   ```bash
   caddie python:remove environment-name
   caddie python:create environment-name
   ```

3. **Permission issues:**
   ```bash
   ls -la ~/.virtualenvs/
   chmod 755 ~/.virtualenvs/environment-name
   ```

### Package Management Issues

1. **pip not found:**
   ```bash
   which pip
   python -m pip --version
   ```

2. **Installation fails:**
   ```bash
   caddie python:upgrade pip
   caddie python:install --upgrade setuptools wheel
   ```

3. **Version conflicts:**
   ```bash
   caddie python:freeze
   # Check for conflicting versions
   ```

### Project Structure Issues

1. **Missing directories:**
   ```bash
   ls -la
   caddie python:init
   ```

2. **setup.py errors:**
   ```bash
   python setup.py check
   python -m py_compile src/
   ```

3. **Import errors:**
   ```bash
   export PYTHONPATH="${PYTHONPATH}:$(pwd)/src"
   python -c "import mypackage"
   ```

## Related Documentation

- **[Core Module](core.md)** - Basic Caddie.sh functions
- **[Installation Guide](../installation.md)** - How to install Caddie.sh
- **[User Guide](../user-guide.md)** - General usage instructions
- **[Configuration Guide](../configuration.md)** - Customization options

## External Resources

- **[Python Official Documentation](https://docs.python.org/)** - Python language reference
- **[pip Documentation](https://pip.pypa.io/)** - Package installer reference
- **[venv Documentation](https://docs.python.org/3/library/venv.html)** - Virtual environment reference
- **[setuptools Documentation](https://setuptools.pypa.io/)** - Package configuration reference

---

*The Python module provides everything you need for professional Python development. From virtual environments to project scaffolding, it makes Python development effortless and consistent.*
