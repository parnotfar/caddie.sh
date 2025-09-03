# iOS Module

The iOS module provides comprehensive iOS development tools and project management capabilities, making iOS development effortless and consistent.

## Overview

The iOS module is designed to streamline iOS development workflows by providing:

- **Environment Setup**: Set up iOS development environment with Xcode and Swift
- **Project Management**: Build, run, and test iOS projects
- **Dependency Management**: Manage CocoaPods dependencies
- **Rust Integration**: Set up Rust development environment for iOS
- **Device Management**: List simulators and connected devices

## Commands

### Environment Setup

#### `caddie ios:setup`

Set up the basic iOS development environment.

**Examples:**
```bash
# Setup iOS development environment
caddie ios:setup
```

**What it does:**
- Checks for Xcode installation
- Validates Swift availability
- Installs CocoaPods if needed
- Provides environment information

**Output:**
```
Setting up iOS development environment...
✓ Xcode found: Xcode 15.2 Build version 15C500b
✓ Swift found: swift-driver version: 1.75.2
Installing CocoaPods...
✓ CocoaPods installed successfully
✓ iOS development environment setup complete
  Xcode: Xcode 15.2 Build version 15C500b
  Swift: swift-driver version: 1.75.2
  CocoaPods: 1.14.3
```

**Requirements:**
- macOS with Xcode installed
- Xcode command line tools

#### `caddie ios:rust:setup`

Set up Rust development environment specifically for iOS development.

**Examples:**
```bash
# Setup Rust for iOS development
caddie ios:rust:setup
```

**What it does:**
- Installs Rust if not already present
- Adds iOS-specific targets (aarch64-apple-ios, x86_64-apple-ios)
- Installs essential Cargo tools (cargo-edit, cargo-watch, cargo-tarpaulin)
- Validates iOS development environment (Xcode, Swift)
- Provides next steps for iOS-Rust integration

**Output:**
```
Setting up Rust development environment for iOS...
✓ Rust already installed: rustc 1.75.0 (8ea583342 2023-12-18)
Adding iOS Rust targets...
✓ iOS Rust targets added successfully
Installing essential Cargo tools...
✓ Cargo tools installed successfully
Validating iOS development environment...
✓ iOS development environment validated
  Xcode: Xcode 15.2 Build version 15C500b
  Swift: swift-driver version: 1.75.2
  Rust: rustc 1.75.0 (8ea583342 2023-12-18)
✓ Rust development environment for iOS setup complete

Next steps:
1. Build Rust library: cargo build --target aarch64-apple-ios --release --lib
2. Create iOS framework structure for Swift integration
3. Use the generated .a static libraries in your iOS project
```

**Requirements:**
- macOS with Xcode installed
- Xcode command line tools
- Internet connection for Rust installation

**Idempotent:** Yes - can be run multiple times safely

### Device Management

#### `caddie ios:simulator`

List available iOS simulators.

**Examples:**
```bash
# List available simulators
caddie ios:simulator
```

**What it does:**
- Lists all available iOS simulators
- Shows device types and iOS versions
- Displays simulator identifiers

**Output:**
```
Available iOS Simulators
== Device Types ==
iPhone 15 (19.2) (00008120-000D0C0A0E00001E)
iPhone 15 Pro (19.2) (00008120-000D0C0A0E00001F)
iPad Pro (12.9-inch) (6th generation) (19.2) (00008120-000D0C0A0E000020)
```

#### `caddie ios:device`

List connected iOS devices.

**Examples:**
```bash
# List connected devices
caddie ios:device
```

**What it does:**
- Lists all connected iOS devices
- Shows device information and status
- Displays device identifiers

### Project Management

#### `caddie ios:build`

Build the current iOS project.

**Examples:**
```bash
# Build iOS project
caddie ios:build
```

**What it does:**
- Builds the iOS project in the current directory
- Supports both .xcodeproj and .xcworkspace files
- Shows build output and results

**Requirements:**
- Must be in an iOS project directory (contains .xcodeproj or .xcworkspace)

#### `caddie ios:run`

Run the current iOS project on simulator.

**Examples:**
```bash
# Run on simulator
caddie ios:run
```

**What it does:**
- Builds and runs the iOS project on simulator
- Automatically selects available simulator
- Shows run output and results

**Requirements:**
- Must be in an iOS project directory
- iOS simulator must be available

#### `caddie ios:test`

Run tests for the current iOS project.

**Examples:**
```bash
# Run iOS tests
caddie ios:test
```

**What it does:**
- Runs unit tests for the iOS project
- Shows test results and coverage
- Reports test failures

#### `caddie ios:archive`

Create an archive for distribution.

**Examples:**
```bash
# Create archive
caddie ios:archive
```

**What it does:**
- Creates a release archive
- Stores archive in build/archive directory
- Prepares for App Store distribution

#### `caddie ios:clean`

Clean build artifacts.

**Examples:**
```bash
# Clean build artifacts
caddie ios:clean
```

**What it does:**
- Removes build artifacts
- Cleans derived data
- Frees up disk space

### Dependency Management

#### `caddie ios:pod:install`

Install CocoaPods dependencies.

**Examples:**
```bash
# Install dependencies
caddie ios:pod:install
```

**What it does:**
- Installs CocoaPods dependencies
- Updates Podfile.lock
- Creates .xcworkspace if needed

**Requirements:**
- Podfile must exist in current directory

#### `caddie ios:pod:update`

Update CocoaPods dependencies.

**Examples:**
```bash
# Update dependencies
caddie ios:pod:update
```

**What it does:**
- Updates CocoaPods dependencies to latest versions
- Updates Podfile.lock
- Shows update results

### Version Information

#### `caddie ios:swift:version`

Show Swift version.

**Examples:**
```bash
# Show Swift version
caddie ios:swift:version
```

**What it does:**
- Displays Swift version information
- Shows Swift driver details

#### `caddie ios:xcode:version`

Show Xcode version.

**Examples:**
```bash
# Show Xcode version
caddie ios:xcode:version
```

**What it does:**
- Displays Xcode version information
- Shows build version and details

## Workflow Examples

### Basic iOS Development

```bash
# Setup environment
caddie ios:setup

# Create new project (using Xcode)
# ... create project in Xcode ...

# Build and run
caddie ios:build
caddie ios:run

# Run tests
caddie ios:test
```

### iOS with Rust Integration

```bash
# Setup iOS and Rust environment
caddie ios:setup
caddie ios:rust:setup

# Build Rust library for iOS
cargo build --target aarch64-apple-ios --release --lib

# Create iOS framework structure
# ... integrate with iOS project ...

# Build iOS project with Rust library
caddie ios:build
```

### CocoaPods Workflow

```bash
# Setup environment
caddie ios:setup

# Install dependencies
caddie ios:pod:install

# Build project (use .xcworkspace)
caddie ios:build

# Update dependencies
caddie ios:pod:update
```

## Troubleshooting

### Common Issues

#### Build Failures

1. **Check Xcode installation**:
   ```bash
   caddie ios:xcode:version
   ```

2. **Check Swift availability**:
   ```bash
   caddie ios:swift:version
   ```

3. **Clean and rebuild**:
   ```bash
   caddie ios:clean
   caddie ios:build
   ```

#### Simulator Issues

1. **List available simulators**:
   ```bash
   caddie ios:simulator
   ```

2. **Check device availability**:
   ```bash
   caddie ios:device
   ```

3. **Reset simulator**:
   ```bash
   xcrun simctl erase all
   ```

#### CocoaPods Issues

1. **Reinstall dependencies**:
   ```bash
   caddie ios:pod:install
   ```

2. **Update dependencies**:
   ```bash
   caddie ios:pod:update
   ```

3. **Clean CocoaPods cache**:
   ```bash
   pod cache clean --all
   ```

#### Rust Integration Issues

1. **Verify Rust setup**:
   ```bash
   caddie ios:rust:setup
   ```

2. **Check Rust targets**:
   ```bash
   rustup target list --installed
   ```

3. **Build Rust library**:
   ```bash
   cargo build --target aarch64-apple-ios --release --lib
   ```

## Related Documentation

- **[Rust Module](rust.md)** - Rust development tools and iOS integration
- **[Core Module](core.md)** - Basic Caddie.sh functions
- **[Installation Guide](../installation.md)** - How to install Caddie.sh
- **[User Guide](../user-guide.md)** - General usage instructions
- **[Configuration Guide](../configuration.md)** - Customization options

## External Resources

- **[Apple Developer Documentation](https://developer.apple.com/documentation/)** - Official iOS development docs
- **[Swift Documentation](https://swift.org/documentation/)** - Swift programming language guide
- **[CocoaPods Documentation](https://guides.cocoapods.org/)** - CocoaPods dependency management
- **[Xcode Documentation](https://developer.apple.com/xcode/)** - Xcode IDE guide

---

*The iOS module provides everything you need for professional iOS development. From environment setup to Rust integration, it makes iOS development effortless and consistent.*
