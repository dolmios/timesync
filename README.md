# Timesync

A macOS menu bar app for managing multiple timezones and converting times.

## Features

- Menu bar display of selected timezone with time and weekday
- Timezone management (add, remove, display in menu bar)
- Natural language time conversion (e.g., "Thursday at 5pm")
- 24-hour time format (default, toggleable)
- Auto-launch on login
- Keyboard shortcut: ⌘⇧T to toggle popup window

### Code Quality

```bash
make install-swiftlint  # Install SwiftLint (once)
make lint               # Check code
make format             # Auto-fix code
```

### Commands

```bash
make build              # Build the project
make run                # Build and run
make clean              # Clean build
make lint               # Check code quality
make format             # Auto-fix code style
make help               # Show all commands
```

### Architecture

- **AppState**: Manages timezone list and pinned timezone
- **TimeProvider**: Centralized time updates
- **Preferences**: App-wide settings
- **DateFormatterCache**: Thread-safe formatter caching
- **PrimaryButton**: Reusable black button component

## UI Components

### Primary Buttons

Black background buttons with SF Symbols icons:

```swift
// Simple button
PrimaryButton("Convert") { }

// With icon (SF Symbols)
PrimaryButton("Add Timezone", icon: "plus.circle") { }
PrimaryButton("Delete", icon: "trash") { }
PrimaryButton("Settings", icon: "gear") { }
```

Browse 5,000+ SF Symbol icons:
- Apple SF Symbols app (download from App Store)
- https://sfsymbols.com

### Typography

Uses the **Standard** custom font family:

```swift
// Semantic sizes
Text("Heading").font(StandardFont.heading1)
Text("Body").font(StandardFont.body)

// Specific weights
Text("Bold").font(StandardFont.bold(size: 16))
Text("Regular").font(StandardFont.book(size: 14))
```

### Navigation

Tab navigation uses Apple's Liquid Glass design:
- Active tabs have `.thinMaterial` glass effect
- Subtle white borders for depth
- Modern, clean appearance

## Code Quality

SwiftLint is configured for code standards. Configuration in `.swiftlint.yml`.

```bash
make lint               # Check
make format             # Auto-fix
```
