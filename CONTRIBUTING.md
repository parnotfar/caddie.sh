# Contributing to Caddie.sh

## Code Standards and Linting

### Shebang Requirements

**Why shebangs are NOT required for caddie modules:**

Caddie modules are **sourced** by the bash profile, not executed as standalone scripts. When a module is sourced with `source ~/.caddie_modules/dot_caddie_rust`, the shebang line is ignored by bash. The shebang is only relevant for executable scripts that are run directly.

**Module Loading Process:**
1. `~/.bash_profile` sources `~/.caddie_modules/dot_caddie_core`
2. Core module sources other modules as needed
3. All modules are loaded into the current bash session
4. No shebang is needed or used in this process

**Exception:** Only standalone executable scripts (like the main `caddie` script) need shebangs.

### Explicit Return Statements

**Why explicit returns are recommended (but not required):**

Bash functions automatically return the exit status of the last executed command. However, explicit returns improve code clarity and make intent obvious.

**Examples:**

```bash
# Implicit return (works fine)
function caddie_rust_check() {
    cargo check
    # Returns exit status of cargo check automatically
}

# Explicit return (preferred for clarity)
function caddie_rust_check() {
    if cargo check; then
        caddie cli:check "Rust project check passed"
        return 0
    else
        caddie cli:red "Rust project check failed"
        return 1
    fi
}
```

**Benefits of explicit returns:**
- Makes success/failure paths clear
- Easier to debug and maintain
- Consistent with other programming languages
- Helps with error handling in calling functions

### Local Variable Declarations

**Why `local` is required:**

Using `local` prevents variable name conflicts and makes functions more predictable.

```bash
# Bad - pollutes global namespace
function caddie_rust_build() {
    project_name="my-project"  # Global variable!
    cargo build
}

# Good - keeps variables local
function caddie_rust_build() {
    local project_name="my-project"  # Local variable
    cargo build
}
```

### Variable Braces

**Why `${var}` is preferred over `$var`:**

Braces prevent ambiguity and make variable boundaries clear.

```bash
# Ambiguous - is this $var_suffix or ${var}suffix?
echo $var_suffix

# Clear - definitely ${var}suffix
echo ${var}_suffix
```

### Echo Message Standards

**Why use caddie CLI functions instead of raw `echo`:**

The caddie CLI module provides consistent formatting, color coding, and semantic meaning across all modules.

#### **Error Messages**
```bash
# Bad - inconsistent formatting
echo "Error: Something went wrong"

# Good - consistent with caddie standards
caddie cli:red "Error: Something went wrong"
```

#### **Usage Messages**
```bash
# Bad - inconsistent formatting
echo "Usage: caddie rust:build"

# Good - consistent with caddie standards
caddie cli:usage "caddie rust:build"
```

#### **Success Messages**
```bash
# Bad - inconsistent formatting
echo "✓ Build completed successfully"

# Good - consistent with caddie standards
caddie cli:check "Build completed successfully"
```

#### **Failure Messages**
```bash
# Bad - inconsistent formatting
echo "✗ Build failed"

# Good - consistent with caddie standards
caddie cli:red "Build failed"
```

#### **General Messages**
```bash
# Bad - inconsistent formatting
echo "Installing dependencies..."

# Good - consistent with caddie standards
caddie cli:indent "Installing dependencies..."
```

#### **Complete Echo Message Standards**
- **Error Messages**: `echo "Error:` → `caddie cli:red`
- **Usage Messages**: `echo "Usage` → `caddie cli:usage`
- **Success Messages**: `echo "✓` → `caddie cli:check`
- **Failure Messages**: `echo "✗` → `caddie cli:red`
- **General Messages**: `echo "..."` → `caddie cli:indent`

#### **Technical Echo Statements (Excluded from Linting)**
The linter intelligently excludes technical echo statements used for data processing:
```bash
# These are excluded from linting (technical use)
echo "$build_files" | while read -r file; do
echo "$data" | head -10
echo "$count" | wc -l
```

### Function Naming Convention

**Standard: `caddie_<module>_<command>`**

Examples:
- `caddie_rust_build`
- `caddie_python_test`
- `caddie_git_commit`

**Exception:** The debug module uses `caddie_debug()` as a utility function, which is exempt from this convention.

### Module Exemptions

Some modules may be exempt from certain linting rules:

- **Debug Module**: Uses `caddie_debug()` instead of `caddie_debug_<command>` for utility purposes
- **Core Module**: May have special functions that don't follow standard naming

Exemptions are handled in the linter with exemption flags.

## Running the Linter

```bash
caddie core:lint
```

This will check all modules against the standards and report any issues.

## Fixing Common Issues

1. **Missing help function**: Add `caddie_<module>_help()` function
2. **Missing local declarations**: Add `local` keyword to variable assignments
3. **Missing return statements**: Add explicit `return 0` or `return 1`
4. **Echo errors**: Replace `echo "Error:` with `caddie cli:red`
5. **Echo usage**: Replace `echo "Usage` with `caddie cli:usage`
6. **Echo success**: Replace `echo "✓` with `caddie cli:check`
7. **Echo failure**: Replace `echo "✗` with `caddie cli:red`
8. **Echo general**: Replace general `echo "..."` with `caddie cli:indent`
9. **Variable braces**: Use `${var}` instead of `$var`

## Testing Changes

After making changes, run:

```bash
caddie core:lint
caddie core:test
```

This ensures your changes don't break existing functionality and meet code standards.