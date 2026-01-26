# iOS Module

The iOS module focuses on App Store and TestFlight distribution workflows.

## Overview

- Project info and build number management
- Archive/export/upload for TestFlight
- Stored configuration for credentials and defaults

## Commands

### Project Information

#### `caddie ios:project:info [scheme]`

Display bundle ID, version, build number, and team ID.

**Examples:**
```bash
caddie ios:project:info
caddie ios:project:info vCaddie
```

#### `caddie ios:increment:build [scheme]`

Increment the build number for the project.

**Examples:**
```bash
caddie ios:increment:build
caddie ios:increment:build vCaddie
```

#### `caddie ios:config:load:project [scheme]`

Load project info into the iOS config store.

**Examples:**
```bash
caddie ios:config:load:project
caddie ios:config:load:project vCaddie
```

### Configuration Management

#### `caddie ios:config:get [key]`

Show stored configuration values.

**Examples:**
```bash
caddie ios:config:get
caddie ios:config:get apple-id
```

#### `caddie ios:config:set <key> <value>`

Set configuration values used by TestFlight uploads.

**Examples:**
```bash
caddie ios:config:set apple-id 'your@apple.id'
caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'
caddie ios:config:set api-key 'ABC123DEFG'
caddie ios:config:set api-issuer '01234567-89ab-cdef-0123-456789abcdef'
caddie ios:config:set scheme 'vCaddie'
```

#### `caddie ios:config:unset <key>`

Remove a configuration value.

#### `caddie ios:config:list`

List all configuration values.

#### Keychain password storage

Use the macOS Keychain to avoid storing the app-specific password in `~/.caddie_ios_config`.

```bash
caddie ios:keychain:password:set 'your@apple.id' 'xxxx-xxxx-xxxx-xxxx'
caddie ios:keychain:password:get 'your@apple.id'
caddie ios:keychain:password:unset 'your@apple.id'
```

### Versioning

#### `caddie ios:version:get [scheme]`

Show the marketing version (`CFBundleShortVersionString`).

```bash
caddie ios:version:get vCaddie
```

#### `caddie ios:version:set <version> [scheme]`

Set the marketing version (`CFBundleShortVersionString`) using agvtool when available, with a project file fallback.

```bash
caddie ios:version:set 1.2 vCaddie
```

### App Store / TestFlight

#### `caddie ios:archive [scheme] [archive_path]`

Create a distribution archive (alias for `ios:archive:testflight`).

#### `caddie ios:archive:testflight [scheme] [archive_path]`

Create a distribution archive for TestFlight.

**Examples:**
```bash
caddie ios:archive:testflight
caddie ios:archive:testflight vCaddie ./archives
```

#### `caddie ios:export:ipa [archive_path] [export_path] [export_options_plist]`

Export an IPA from the archive for App Store Connect.

**Examples:**
```bash
caddie ios:export:ipa
caddie ios:export:ipa ./build/archive/vCaddie.xcarchive ./build/export
```

#### `caddie ios:upload:testflight [ipa_path] [apple_id] [password]`

Upload an IPA to TestFlight.

**Examples:**
```bash
caddie ios:upload:testflight ./build/export/vCaddie.ipa
caddie ios:upload:testflight ./build/export/vCaddie.ipa 'your@apple.id' 'xxxx-xxxx-xxxx-xxxx'
```

#### `caddie ios:testflight [scheme] [increment] [upload]`

Run the complete TestFlight workflow.

**Examples:**
```bash
caddie ios:testflight
caddie ios:testflight vCaddie yes no
```

#### `caddie ios:testflight:publish [scheme] [archive_path] [export_path] [export_options_plist]`

Create a TestFlight archive, export the IPA, and upload it in one command. This command auto-increments the build number before archiving.

**Examples:**
```bash
caddie ios:testflight:publish
caddie ios:testflight:publish vCaddie ./build/archive ./build/export
```

#### `caddie ios:testflight:publish:increment:false [scheme] [archive_path] [export_path] [export_options_plist]`

Create a TestFlight archive, export the IPA, and upload it without incrementing the build number. App Store Connect requires unique build numbers, so use this only when you have already incremented.

**Examples:**
```bash
caddie ios:testflight:publish:increment:false
caddie ios:testflight:publish:increment:false vCaddie ./build/archive ./build/export
```

## Workflow Example

```bash
# 1) One-time config
caddie ios:config:set apple-id 'your@apple.id'
caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'

# 2) Load project defaults
caddie ios:config:load:project vCaddie

# 3) Full workflow
caddie ios:testflight
```

## Notes

- Build/run/test commands live in the Swift module (use `caddie swift:xcode:*`).
- Configuration is stored in `~/.caddie_ios_config` and loaded into the shell when the module loads.
- Prefer keychain storage for app-specific passwords (`ios:keychain:password:*`).
- API key uploads require `AuthKey_<API_KEY>.p8` in `~/.private_keys` or `~/private_keys`.
- If no password is configured, uploads will prompt for a masked app-specific password and offer to store it in the keychain (default: yes).
- TestFlight uploads go to the App Store Connect account for the Apple ID you configure and the app bundle ID in the archive. Ensure the scheme builds the correct target and that the Apple ID has access to that app in App Store Connect.

## Troubleshooting

### Scheme not found

Pass a scheme explicitly or set a default:
```bash
caddie ios:config:set scheme vCaddie
```

### Upload authentication errors

Verify configuration values:
```bash
caddie ios:config:get apple-id
caddie ios:config:get password
caddie ios:config:get api-key
caddie ios:config:get api-issuer
```

If using API key auth, ensure `AuthKey_<API_KEY>.p8` is in `~/.private_keys` or `~/private_keys`.

### Archive failures

Confirm code signing and team ID:
```bash
caddie ios:project:info
caddie ios:config:get team-id
```
