.PHONY: lint format install-swiftlint build run clean help

help:
	@echo "Timesync Build Commands"
	@echo "======================="
	@echo ""
	@echo "Setup:"
	@echo "  make install-swiftlint  - Install SwiftLint via Homebrew"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint               - Run SwiftLint checks"
	@echo "  make format             - Auto-fix code style"
	@echo ""
	@echo "Building:"
	@echo "  make build              - Build the project"
	@echo "  make run                - Build and run"
	@echo "  make clean              - Clean build artifacts"
	@echo ""

# Install SwiftLint via Homebrew
install-swiftlint:
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew not found. Install from https://brew.sh"; exit 1; }
	brew install swiftlint
	@echo "✅ SwiftLint installed"

# Run SwiftLint
lint:
	@command -v swiftlint >/dev/null 2>&1 || { echo "SwiftLint not found. Run: make install-swiftlint"; exit 1; }
	swiftlint lint

# Auto-fix SwiftLint issues
format:
	@command -v swiftlint >/dev/null 2>&1 || { echo "SwiftLint not found. Run: make install-swiftlint"; exit 1; }
	swiftlint --fix

# Build the project
build:
	xcodebuild -project Timesync.xcodeproj -scheme Timesync -configuration Debug

# Run the app
run: build
	@echo "✅ Build complete"

# Clean build directory
clean:
	xcodebuild -project Timesync.xcodeproj -scheme Timesync clean
	@echo "✅ Clean complete"
