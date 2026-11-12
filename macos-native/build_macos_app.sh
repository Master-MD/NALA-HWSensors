#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APP_BUNDLE="$REPO_ROOT/dist/NALA-HWSensors.app"
MACOS_DIR="$APP_BUNDLE/Contents/MacOS"
RES_DIR="$APP_BUNDLE/Contents/Resources/ui"

SAVER_BUNDLE="$REPO_ROOT/dist/NALA-HWSensors.saver"
SAVER_MACOS_DIR="$SAVER_BUNDLE/Contents/MacOS"
SAVER_RES_DIR="$SAVER_BUNDLE/Contents/Resources/ui"

TMP_BUILD_DIR="/tmp/nala_hwsensors_v27_universal_build"
rm -rf "$TMP_BUILD_DIR"
mkdir -p "$TMP_BUILD_DIR"

echo "🛠️  [NALA-HWSensors v2.7] Building Universal 2 (arm64 + x86_64) Native macOS .app & .saver ScreenSaver..."
rm -rf "$SAVER_BUNDLE"
mkdir -p "$MACOS_DIR" "$RES_DIR" "$SAVER_MACOS_DIR" "$SAVER_RES_DIR"

# Copy all UI assets & AppIcon.icns into both .app and .saver bundle Resources
cp -f "$REPO_ROOT/ui/"*.html "$RES_DIR/"
cp -f "$REPO_ROOT/ui/"*.html "$SAVER_RES_DIR/"
if [ -f "$REPO_ROOT/ui/NALA-HWSensors(FINAL).png" ]; then
  cp -f "$REPO_ROOT/ui/NALA-HWSensors(FINAL).png" "$RES_DIR/"
  cp -f "$REPO_ROOT/ui/NALA-HWSensors(FINAL).png" "$SAVER_RES_DIR/"
fi
if [ -f "$SCRIPT_DIR/AppIcon.icns" ]; then
  cp -f "$SCRIPT_DIR/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
  cp -f "$SCRIPT_DIR/AppIcon.icns" "$SAVER_BUNDLE/Contents/Resources/AppIcon.icns"
fi

# 1. Build Universal 2 NALA-HWSensors.saver Bundle (arm64 + x86_64)
cat << 'EOF' > "$SAVER_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>de</string>
  <key>CFBundleExecutable</key>
  <string>NALA-HWSensors-Saver</string>
  <key>CFBundleIconFile</key>
  <string>AppIcon</string>
  <key>CFBundleIdentifier</key>
  <string>org.mastermd.nala-hwsensors.saver</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>NALA-HWSensors 3D Relief</string>
  <key>CFBundleDisplayName</key>
  <string>NALA-HWSensors 3D Relief (v2.7)</string>
  <key>CFBundlePackageType</key>
  <string>BNDL</string>
  <key>CFBundleShortVersionString</key>
  <string>2.7.0</string>
  <key>CFBundleVersion</key>
  <string>2.7.0-Universal</string>
  <key>NSPrincipalClass</key>
  <string>NALAHWSensorsScreenSaverView</string>
  <key>LSMinimumSystemVersion</key>
  <string>11.0</string>
</dict>
</plist>
EOF

echo "   -> Compiling NALA-HWSensors.saver (arm64-apple-macos11.0)..."
/usr/bin/swiftc "$SCRIPT_DIR/NALAHWSensorsScreenSaver.swift" \
  -O \
  -target arm64-apple-macos11.0 \
  -emit-library \
  -Xlinker -bundle \
  -module-name NALAHWSensorsSaver \
  -framework Cocoa \
  -framework ScreenSaver \
  -framework WebKit \
  -o "$TMP_BUILD_DIR/NALA-HWSensors-Saver-arm64"

echo "   -> Compiling NALA-HWSensors.saver (x86_64-apple-macos11.0)..."
/usr/bin/swiftc "$SCRIPT_DIR/NALAHWSensorsScreenSaver.swift" \
  -O \
  -target x86_64-apple-macos11.0 \
  -emit-library \
  -Xlinker -bundle \
  -module-name NALAHWSensorsSaver \
  -framework Cocoa \
  -framework ScreenSaver \
  -framework WebKit \
  -o "$TMP_BUILD_DIR/NALA-HWSensors-Saver-x86_64"

/usr/bin/lipo -create \
  "$TMP_BUILD_DIR/NALA-HWSensors-Saver-arm64" \
  "$TMP_BUILD_DIR/NALA-HWSensors-Saver-x86_64" \
  -output "$SAVER_MACOS_DIR/NALA-HWSensors-Saver"

/usr/bin/codesign --force --deep --sign - "$SAVER_BUNDLE" 2>/dev/null || true

# Embed the .saver inside the .app bundle Resources for 1-Click Export/Install
rm -rf "$APP_BUNDLE/Contents/Resources/NALA-HWSensors.saver"
cp -R "$SAVER_BUNDLE" "$APP_BUNDLE/Contents/Resources/NALA-HWSensors.saver"

# Also install directly to ~/Library/Screen Savers/NALA-HWSensors.saver
USER_SAVERS_DIR="$HOME/Library/Screen Savers"
mkdir -p "$USER_SAVERS_DIR"
rm -rf "$USER_SAVERS_DIR/NALA-HWSensors.saver"
cp -R "$SAVER_BUNDLE" "$USER_SAVERS_DIR/NALA-HWSensors.saver"

# 2. Build Universal 2 NALA-HWSensors.app Bundle (arm64 + x86_64)
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
  <string>NALA-HWSensors v2.7 Universal</string>
  <key>CFBundleShortVersionString</key>
  <string>2.7.0</string>
  <key>CFBundleVersion</key>
  <string>2.7.0-Universal-NCSP</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>LSMinimumSystemVersion</key>
  <string>11.0</string>
  <key>LSUIElement</key>
  <false/>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
EOF

echo "   -> Compiling NALA-HWSensors.app (arm64-apple-macos11.0)..."
/usr/bin/swiftc "$SCRIPT_DIR/NALAHWSensorsApp.swift" \
  -O \
  -target arm64-apple-macos11.0 \
  -framework Cocoa \
  -framework WebKit \
  -framework IOKit \
  -framework Security \
  -o "$TMP_BUILD_DIR/NALA-HWSensors-arm64"

echo "   -> Compiling NALA-HWSensors.app (x86_64-apple-macos11.0)..."
/usr/bin/swiftc "$SCRIPT_DIR/NALAHWSensorsApp.swift" \
  -O \
  -target x86_64-apple-macos11.0 \
  -framework Cocoa \
  -framework WebKit \
  -framework IOKit \
  -framework Security \
  -o "$TMP_BUILD_DIR/NALA-HWSensors-x86_64"

/usr/bin/lipo -create \
  "$TMP_BUILD_DIR/NALA-HWSensors-arm64" \
  "$TMP_BUILD_DIR/NALA-HWSensors-x86_64" \
  -output "$MACOS_DIR/NALA-HWSensors"

/usr/bin/codesign --force --deep --sign - "$APP_BUNDLE" 2>/dev/null || true
touch "$APP_BUNDLE" "$SAVER_BUNDLE"
rm -rf "$TMP_BUILD_DIR"

BIN_SIZE=$(stat -f%z "$MACOS_DIR/NALA-HWSensors")
SAVER_SIZE=$(stat -f%z "$SAVER_MACOS_DIR/NALA-HWSensors-Saver")
if [ "$BIN_SIZE" -lt 20000 ] || [ "$SAVER_SIZE" -lt 20000 ]; then
  echo "❌ [GATE FAIL] Binary too small (App: $BIN_SIZE bytes, Saver: $SAVER_SIZE bytes)!"
  exit 1
fi

echo "✅ [GATE PASS] Universal 2 macOS App & ScreenSaver compiled:"
/usr/bin/lipo -info "$MACOS_DIR/NALA-HWSensors"
/usr/bin/lipo -info "$SAVER_MACOS_DIR/NALA-HWSensors-Saver"
echo "   -> App Bundle:   $APP_BUNDLE ($BIN_SIZE bytes)"
echo "   -> Saver Bundle: $SAVER_BUNDLE ($SAVER_SIZE bytes)"
echo "   -> Installed in: $USER_SAVERS_DIR/NALA-HWSensors.saver"
