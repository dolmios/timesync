# Release Process

This document outlines the steps to create a release for Timesync.

## Prerequisites

- Xcode installed and configured
- GitHub CLI (`gh`) installed (optional, for CLI-based releases)
- DMG creation tools (built into Xcode)

## Building the DMG

1. **Open the project in Xcode:**
   ```bash
   open Timesync.xcodeproj
   ```

2. **Archive the app:**
   - Select "Any Mac" as the destination
   - Go to Product → Archive
   - Wait for the archive to complete

3. **Export the archive:**
   - In the Organizer window, select your archive
   - Click "Distribute App"
   - Choose "Copy App" or "Developer ID" (depending on your distribution method)
   - Select "Export" and choose a location
   - The app will be exported as `Timesync.app`

4. **Create a DMG:**
   - Open Disk Utility
   - Create a new disk image (File → New Image → Blank Image)
   - Set size to ~50MB
   - Format: Mac OS Extended (Journaled)
   - Drag `Timesync.app` into the disk image
   - Optionally add a link to Applications folder
   - Eject the disk image
   - Rename the `.dmg` file to `Timesync-v0.1.0.dmg`

## Creating a GitHub Release

### Using GitHub Web UI

1. Go to https://github.com/dolmios/timesync/releases/new
2. Click "Choose a tag" and create a new tag: `v0.1.0`
3. Fill in the release title: `v0.1.0`
4. Add release notes:
   ```
   ## First Release

   Timesync is a macOS menu bar app for managing multiple timezones and converting times.

   **Personal Project**
   This app was built for my personal needs—working between New York and Melbourne timezones.
   Inspired by [Hovrly](https://hovrly.com), but tailored to my workflow. This was my first Mac app project.

   **Features:**
   - Menu bar display of selected timezone
   - Natural language time conversion (e.g., "Thursday at 5pm")
   - Multiple timezone management
   - 24-hour time format toggle
   - Auto-launch on login
   - Keyboard shortcut: ⌘⇧T to toggle popup window
   ```
5. Upload the DMG file as a release asset
6. Click "Publish release"

### Using GitHub CLI

```bash
# Create a tag
git tag v0.1.0
git push origin v0.1.0

# Create release with DMG
gh release create v0.1.0 \
  --title "v0.1.0" \
  --notes "## First Release

Timesync is a macOS menu bar app for managing multiple timezones and converting times.

**Personal Project**
This app was built for my personal needs—working between New York and Melbourne timezones.
Inspired by Hoverly, but tailored to my workflow. This was my first Mac app project.

**Features:**
- Menu bar display of selected timezone
- Natural language time conversion (e.g., \"Thursday at 5pm\")
- Multiple timezone management
- 24-hour time format toggle
- Auto-launch on login
- Keyboard shortcut: ⌘⇧T to toggle popup window" \
  Timesync-v0.1.0.dmg
```

## Post-Release

- Update the website download link to point to the latest release
- Consider adding release notes to the website
- Update version number in `Info.plist` for next release
