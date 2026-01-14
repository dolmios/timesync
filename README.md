# Timesync

A macOS menu bar app for managing multiple timezones and converting times.

## Website

Visit [timesync.dolmios.com](https://timesync.dolmios.com) for more information and downloads.

## Features

- Menu bar display of selected timezone with time and weekday
- Timezone management (add, remove, display in menu bar)
- Natural language time conversion (e.g., "Thursday at 5pm")
- 24-hour time format (default, toggleable)
- Auto-launch on login

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

## Release

See [RELEASE.md](./RELEASE.md) for instructions on creating a release and building the DMG.

## Website

The website is located in `apps/website/` and uses Next.js with stoop-ui. To run locally:

```bash
cd apps/website
npm install
npm run dev
```

The website follows the same design conventions as [stoop.dolmios.com](https://stoop.dolmios.com).
