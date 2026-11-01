#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "A compilação de um .app requer o runner macOS do GitHub Actions" >&2
  exit 1
fi
SDK="$(xcrun --sdk macosx --show-sdk-path)"
OUT="$PWD/build"
APP="$OUT/ChimpiNotch.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp Config/Info.plist "$APP/Contents/Info.plist"
VERSION="${CHIMPI_VERSION:-1.0.${GITHUB_RUN_NUMBER:-4}}"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${GITHUB_RUN_NUMBER:-4}" "$APP/Contents/Info.plist"
cp Config/support-*.json "$APP/Contents/Resources/"
for ARCH in x86_64 arm64; do
  xcrun swiftc -parse-as-library -O -sdk "$SDK" -target "$ARCH-apple-macos13.0" \
    Sources/*.swift -framework AppKit -framework SwiftUI \
    -o "$OUT/ChimpiNotch-$ARCH"
done
xcrun lipo -create "$OUT/ChimpiNotch-x86_64" "$OUT/ChimpiNotch-arm64" \
  -output "$APP/Contents/MacOS/ChimpiNotch"
chmod +x "$APP/Contents/MacOS/ChimpiNotch"
codesign --force --sign - "$APP"
ditto -c -k --keepParent "$APP" "$OUT/ChimpiNotch-macOS-Universal.zip"
