.PHONY: lint format install-swiftlint build run clean dmg help

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
	@echo "  make dmg                - Build Release and create DMG"
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

# Build Release and create DMG
dmg:
	@echo "🔨 Building Release..."
	@mkdir -p build
	@xcodebuild -project Timesync.xcodeproj \
		-scheme Timesync \
		-configuration Release \
		-derivedDataPath ./build/DerivedData \
		-quiet || (echo "❌ Build failed"; exit 1)
	@echo "📦 Creating DMG..."
	@rm -f build/Timesync.dmg
	@rm -rf build/Timesync.app
	@APP_PATH=$$(find ./build/DerivedData -name "Timesync.app" -type d | head -1); \
	if [ -z "$$APP_PATH" ]; then \
		echo "❌ Error: Timesync.app not found in build output"; \
		exit 1; \
	fi; \
	cp -R "$$APP_PATH" build/
	@hdiutil create -volname "Timesync" \
		-srcfolder build/Timesync.app \
		-ov -format UDZO \
		build/Timesync.dmg > /dev/null
	@mkdir -p apps/website/public
	@cp build/Timesync.dmg apps/website/public/Timesync.dmg
	@echo "✅ DMG created at build/Timesync.dmg"
	@echo "✅ DMG copied to apps/website/public/Timesync.dmg"
