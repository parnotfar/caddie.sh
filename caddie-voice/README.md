# Caddie Voice Daemon

A voice-enabled interface for the Caddie development environment. This daemon runs in the background and listens for voice commands to execute caddie operations.

## Features

- **Push-to-Talk**: Press V key to activate voice listening
- **Rust Example Commands**: Voice control for running Rust examples
- **Background Daemon**: Runs continuously in the background
- **TTS Feedback**: Voice confirmation of command execution

## Installation

```bash
# Build and install the voice daemon
make build-voice
make install-voice

# Check status
make voice-status
```

## Usage

1. **Press V** - Activates voice listening (you'll hear "Listening...")
2. **Speak** - Say your command (e.g., "rust run example multi distance chip validation")
3. **Release V** - Executes the command and provides feedback

## Supported Commands

### Rust Examples
- **Voice**: "rust run example multi distance chip validation"
- **Executes**: `caddie rust:run:example multi-distance-chip-validation`

## Architecture

- **CaddieVoiceDaemon.swift**: Main daemon entry point
- **HotkeyManager.swift**: Global hotkey registration (V key)
- **CommandProcessor.swift**: Voice-to-command translation
- **SpeechRecognizer.swift**: Speech-to-text conversion
- **TTSManager.swift**: Text-to-speech feedback

## Development

```bash
# Build
make build-voice

# Test locally
cd caddie-voice
xcodebuild -project CaddieVoice.xcodeproj -scheme CaddieVoice run

# Uninstall
make uninstall-voice
```

## Requirements

- macOS 13.0+
- Xcode command line tools
- Microphone permissions
- Speech recognition permissions

## Troubleshooting

- **Permissions**: Grant microphone and speech recognition access in System Preferences
- **Hotkey conflicts**: V key may conflict with other applications
- **Daemon not starting**: Check logs in `/tmp/caddie-voice.log`

## Future Enhancements

- Support for more caddie commands
- Custom voice command mapping
- Context-aware command processing
- Multi-language support
