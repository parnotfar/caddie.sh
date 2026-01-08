# iOS Module

The iOS module provides comprehensive iOS development tools and project management capabilities, making iOS development effortless and consistent.

## Overview

The iOS module is designed to streamline iOS development workflows by providing:

- **Environment Setup**: Set up iOS development environment with Xcode and Swift
- **Project Management**: Build, run, and test iOS projects
- **Dependency Management**: Manage CocoaPods dependencies
- **Rust Integration**: Set up Rust development environment for iOS
- **Device Management**: List simulators and connected devices
- **TestFlight Distribution**: Complete command-line workflow for uploading to TestFlight
- **Configuration Management**: Persistent storage for Apple ID, credentials, and project settings

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

### Project Information

#### `caddie ios:project:info [scheme]`

Display project information including bundle ID, version, build number, and team ID.

**Examples:**
```bash
# Show project info (auto-detects scheme)
caddie ios:project:info

# Show project info for specific scheme
caddie ios:project:info vCaddie
```

**What it does:**
- Extracts bundle identifier from project settings
- Shows marketing version (e.g., "1.0")
- Displays current build number
- Shows development team ID
- Displays app display name
- Exports values for use by other functions

**Output:**
```
Project Information (Scheme: vCaddie)

  Display Name: vCaddie
  Bundle ID: com.parnotfar.vCaddie
  Version: 1.0
  Build Number: 1
  Team ID: 6ZBU84K496
```

**Requirements:**
- Must be in an iOS project directory
- Xcode project must have valid build settings

#### `caddie ios:increment:build [scheme]`

Increment the build number in your Xcode project.

**Examples:**
```bash
# Increment build number (auto-detects scheme)
caddie ios:increment:build

# Increment build for specific scheme
caddie ios:increment:build vCaddie
```

**What it does:**
- Reads current build number from project
- Increments by 1
- Updates project.pbxproj file
- Updates Info.plist if present
- Uses agvtool if available, otherwise edits files directly

**Output:**
```
Incrementing Build Number (Scheme: vCaddie)
  Current build: 1
  New build: 2
✓ Build number incremented to 2
```

**Requirements:**
- Must be in an iOS project directory
- Project must have CURRENT_PROJECT_VERSION set

### TestFlight Distribution

#### `caddie ios:archive:testflight [scheme] [archive_path]`

Create an archive for TestFlight distribution.

**Examples:**
```bash
# Create archive (auto-detects scheme)
caddie ios:archive:testflight

# Create archive for specific scheme
caddie ios:archive:testflight vCaddie

# Specify custom archive path
caddie ios:archive:testflight vCaddie ./archives
```

**What it does:**
- Creates Release configuration archive
- Builds for generic iOS device (required for App Store)
- Stores archive in specified or default location
- Prepares archive for App Store distribution

**Output:**
```
Creating Archive for TestFlight (Scheme: vCaddie)
  Archive path: ./build/archive/vCaddie.xcarchive
  Building archive...
✓ Archive created successfully
  Location: ./build/archive/vCaddie.xcarchive
```

**Requirements:**
- Must be in an iOS project directory
- Valid code signing configuration
- Development team must be set

#### `caddie ios:export:ipa [archive_path] [export_path] [export_options_plist]`

Export IPA file from archive for App Store distribution.

**Examples:**
```bash
# Export IPA (uses last created archive)
caddie ios:export:ipa

# Export from specific archive
caddie ios:export:ipa ./build/archive/vCaddie.xcarchive

# Specify export path
caddie ios:export:ipa ./build/archive/vCaddie.xcarchive ./exports
```

**What it does:**
- Creates export options plist automatically if not provided
- Configures for App Store distribution
- Exports IPA with proper signing
- Includes symbols for crash reporting

**Output:**
```
Exporting IPA from Archive
  Export path: ./build/export
  Creating export options plist...
✓ Export options plist created
✓ IPA exported successfully
  IPA location: ./build/export/vCaddie.ipa
```

**Requirements:**
- Valid archive file
- Export options plist (auto-generated if not provided)
- Valid code signing

#### `caddie ios:upload:testflight [ipa_path] [apple_id] [password]`

Upload IPA to App Store Connect for TestFlight distribution.

**Examples:**
```bash
# Upload IPA (uses saved credentials)
caddie ios:upload:testflight ./build/export/vCaddie.ipa

# Upload with explicit credentials
caddie ios:upload:testflight ./build/export/vCaddie.ipa 'your@apple.id' 'password'
```

**What it does:**
- Validates IPA file exists
- Uses saved credentials or command-line arguments
- Uploads to App Store Connect via xcrun altool
- Provides next steps for processing

**Output:**
```
Uploading to TestFlight
  Using app-specific password
  IPA: ./build/export/vCaddie.ipa
  Apple ID: your@apple.id
  Uploading...
✓ Upload completed successfully

Next Steps:
1. Wait for processing in App Store Connect (5-30 minutes)
2. Go to: https://appstoreconnect.apple.com
3. Navigate to: My Apps → Your App → TestFlight
4. Add build to testing groups when processing completes
```

**Requirements:**
- Valid IPA file
- Apple ID with App Store Connect access
- App-specific password (recommended) or regular password
- xcrun altool available

**Security Note:** Use app-specific passwords instead of your regular Apple ID password. Get one from https://appleid.apple.com/account/manage

#### `caddie ios:testflight [scheme] [increment] [upload]`

Complete end-to-end TestFlight workflow.

**Examples:**
```bash
# Complete workflow (increment build, archive, export, upload)
caddie ios:testflight

# Specify scheme
caddie ios:testflight vCaddie

# Skip build increment
caddie ios:testflight vCaddie no yes

# Archive and export only (skip upload)
caddie ios:testflight vCaddie yes no
```

**What it does:**
1. Gets project information
2. Optionally increments build number
3. Creates archive
4. Exports IPA
5. Optionally uploads to TestFlight

**Output:**
```
TestFlight Upload Workflow

Project Information (Scheme: vCaddie)
  Display Name: vCaddie
  Bundle ID: com.parnotfar.vCaddie
  Version: 1.0
  Build Number: 1
  Team ID: 6ZBU84K496

Incrementing Build Number (Scheme: vCaddie)
  Current build: 1
  New build: 2
✓ Build number incremented to 2

Creating Archive for TestFlight (Scheme: vCaddie)
  ...
✓ Archive created successfully

Exporting IPA from Archive
  ...
✓ IPA exported successfully

Uploading to TestFlight
  ...
✓ Upload completed successfully

✓ TestFlight workflow completed
```

**Requirements:**
- Must be in an iOS project directory
- Valid code signing
- Apple ID credentials (saved or provided)

### Configuration Management

#### `caddie ios:config:get [key]`

Get configuration value(s). Shows all configuration if no key specified.

**Examples:**
```bash
# Show all configuration
caddie ios:config:get

# Get specific value
caddie ios:config:get apple-id
caddie ios:config:get password
caddie ios:config:get bundle-id
```

**What it does:**
- Displays all saved configuration values
- Shows specific value if key provided
- Masks passwords for security
- Shows `<not set>` for unconfigured values

**Output:**
```
iOS Configuration

  apple-id:        your@apple.id
  password:        <set>
  bundle-id:       com.parnotfar.vCaddie
  version:         1.0
  build:           2
  team-id:         6ZBU84K496
  scheme:          vCaddie
```

**Available Keys:**
- `apple-id` - Your Apple ID email
- `password` - App-specific password
- `bundle-id` - Bundle identifier
- `version` - App version
- `build` - Build number
- `team-id` - Development team ID
- `scheme` - Default Xcode scheme

#### `caddie ios:config:set <key> <value>`

Set a configuration value. Values are saved to `~/.caddie_ios_config` and persist across sessions.

**Examples:**
```bash
# Set Apple ID
caddie ios:config:set apple-id 'your@apple.id'

# Set app-specific password
caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'

# Set bundle ID
caddie ios:config:set bundle-id 'com.parnotfar.vCaddie'

# Set default scheme
caddie ios:config:set scheme 'vCaddie'
```

**What it does:**
- Saves value to configuration file
- Exports as environment variable
- Validates key name
- Provides confirmation

**Output:**
```
✓ Set apple-id to: your@apple.id
✓ Set password (hidden)
✓ Set bundle-id to: com.parnotfar.vCaddie
```

#### `caddie ios:config:unset <key>`

Remove a configuration value.

**Examples:**
```bash
# Remove Apple ID
caddie ios:config:unset apple-id

# Remove password
caddie ios:config:unset password
```

**What it does:**
- Removes value from configuration
- Updates configuration file
- Unsets environment variable

**Output:**
```
✓ Unset apple-id
✓ Unset password
```

#### `caddie ios:config:list`

List all configuration values. Same as `caddie ios:config:get` with no arguments.

**Examples:**
```bash
# List all configuration
caddie ios:config:list
```

#### `caddie ios:config:load:project [scheme]`

Extract project information and save it to configuration.

**Examples:**
```bash
# Load project info (auto-detects scheme)
caddie ios:config:load:project

# Load for specific scheme
caddie ios:config:load:project vCaddie
```

**What it does:**
- Extracts bundle ID, version, build, and team ID from project
- Saves to configuration
- Optionally saves scheme name

**Output:**
```
Project Information (Scheme: vCaddie)
  ...
✓ Project information loaded into configuration
  View with: caddie ios:config:get
```

**Requirements:**
- Must be in an iOS project directory
- Valid Xcode project with build settings

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

### TestFlight Distribution Workflow

```bash
# 1. Setup credentials (one-time)
caddie ios:config:set apple-id 'your@apple.id'
caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'

# 2. Load project information
caddie ios:config:load:project vCaddie

# 3. Complete workflow (increment, archive, export, upload)
caddie ios:testflight

# Or step-by-step:
caddie ios:project:info
caddie ios:increment:build
caddie ios:archive:testflight
caddie ios:export:ipa
caddie ios:upload:testflight ./build/export/vCaddie.ipa
```

### Configuration Management

```bash
# View all configuration
caddie ios:config:get

# Set credentials
caddie ios:config:set apple-id 'your@apple.id'
caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'

# Set project defaults
caddie ios:config:set scheme 'vCaddie'
caddie ios:config:set bundle-id 'com.parnotfar.vCaddie'

# Load from project
caddie ios:config:load:project

# Remove configuration
caddie ios:config:unset password
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

#### TestFlight Upload Issues

1. **Upload fails with authentication error**:
   ```bash
   # Verify credentials are set
   caddie ios:config:get apple-id
   caddie ios:config:get password
   
   # Use app-specific password (recommended)
   # Get from: https://appleid.apple.com/account/manage
   caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'
   ```

2. **Archive creation fails**:
   ```bash
   # Check project settings
   caddie ios:project:info
   
   # Verify team ID is set
   caddie ios:config:get team-id
   
   # Clean and try again
   caddie ios:clean
   caddie ios:archive:testflight
   ```

3. **IPA export fails**:
   ```bash
   # Verify archive exists
   ls -la ./build/archive/
   
   # Check code signing
   caddie ios:project:info
   
   # Try manual export
   caddie ios:export:ipa ./build/archive/vCaddie.xcarchive
   ```

#### Configuration Issues

1. **Configuration not persisting**:
   ```bash
   # Check config file exists
   cat ~/.caddie_ios_config
   
   # Reload configuration
   caddie reload
   caddie ios:config:get
   ```

2. **Wrong scheme being used**:
   ```bash
   # Set default scheme
   caddie ios:config:set scheme 'vCaddie'
   
   # Or specify explicitly
   caddie ios:testflight vCaddie
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
