#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APP_BUNDLE="$REPO_ROOT/dist/NALA-HWSensors.app"
MACOS_DIR="$APP_BUNDLE/Contents/MacOS"
RES_DIR="$APP_BUNDLE/Contents/Resources/ui"

echo "🛠️  [NALA-HWSensors v2.6] Building Native Standalone macOS Bundle with AppIcon.icns..."
mkdir -p "$MACOS_DIR" "$RES_DIR"

# Copy all UI assets & AppIcon.icns into the standalone .app bundle Resources
cp -f "$REPO_ROOT/ui/"*.html "$RES_DIR/"
if [ -f "$REPO_ROOT/ui/NALA-HWSensors(FINAL).png" ]; then
  cp -f "$REPO_ROOT/ui/NALA-HWSensors(FINAL).png" "$RES_DIR/"
fi
if [ -f "$SCRIPT_DIR/AppIcon.icns" ]; then
  cp -f "$SCRIPT_DIR/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
fi

cat << 'EOF' > "$APP_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>NALA-HWSensors</string>
  <key>CFBundleIconFile</key>
  <string>AppIcon</string>
  <key>CFBundleIdentifier</key>
  <string>org.mastermd.nala-hwsensors</string>
  <key>CFBundleName</key>
  <string>NALA-HWSensors</string>
  <key>CFBundleDisplayName</key>
  <string>NALA-HWSensors v2.6</string>
  <key>CFBundleShortVersionString</key>
  <string>2.6.0</string>
  <key>CFBundleVersion</key>
  <string>2.6.0-NCSP</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>LSMinimumSystemVersion</key>
  <string>11.0</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
EOF

/usr/bin/swiftc "$SCRIPT_DIR/NALAHWSensorsApp.swift" \
  -O \
  -framework Cocoa \
  -framework WebKit \
  -framework IOKit \
  -framework Security \
  -o "$MACOS_DIR/NALA-HWSensors"

touch "$APP_BUNDLE"

BIN_SIZE=$(stat -f%z "$MACOS_DIR/NALA-HWSensors")
if [ "$BIN_SIZE" -lt 10000 ]; then
  echo "❌ [GATE FAIL] Binary too small ($BIN_SIZE bytes)!"
  exit 1
fi

echo "✅ [GATE PASS] Native macOS App compiled with Official NALA-HWSensors Icon: $APP_BUNDLE (Binary: $BIN_SIZE bytes)"
