#!/bin/bash
set -e

# Automatically parse latest version from pubspec.yaml
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | cut -d '+' -f 1 | tr -d ' \r\n')
if [ -z "$VERSION" ]; then
  VERSION="1.0.6"
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
FLUTTER_BIN="/home/yanich/.flutter/bin/flutter"

if [ ! -f "$FLUTTER_BIN" ]; then
  FLUTTER_BIN="flutter"
fi

echo "================================================================="
echo "🚀 Building Zen Clock Production Artifacts for ALL Platforms"
echo "📌 Target Version: v${VERSION}"
echo "================================================================="

mkdir -p "${DIST_DIR}"

# 1. Linux Desktop Build & Packaging (.deb + .tar.gz)
echo ""
echo "--- 1/4 Building Linux Desktop Release & .deb Package ---"
$FLUTTER_BIN build linux --release

if [ -d "${ROOT_DIR}/build/linux/x64/release/bundle" ]; then
  # Create Portable Tarball
  tar -czvf "${DIST_DIR}/zen-clock-linux-v${VERSION}-x64.tar.gz" -C "${ROOT_DIR}/build/linux/x64/release/bundle" .
  
  # Create Ubuntu .deb Package
  chmod +x "${ROOT_DIR}/packaging/linux/build_deb.sh"
  "${ROOT_DIR}/packaging/linux/build_deb.sh"
  if [ -f "${ROOT_DIR}/zen-clock_${VERSION}_amd64.deb" ]; then
    mv "${ROOT_DIR}/zen-clock_${VERSION}_amd64.deb" "${DIST_DIR}/"
  elif [ -f "${ROOT_DIR}/zen-clock_1.0.1_amd64.deb" ]; then
    mv "${ROOT_DIR}/zen-clock_1.0.1_amd64.deb" "${DIST_DIR}/zen-clock_${VERSION}_amd64.deb"
  fi
  echo "✓ Linux artifacts created successfully!"
fi

# 2. Android Mobile Build & Packaging (.apk + .aab)
echo ""
echo "--- 2/4 Building Android Production APK & App Bundle (AAB) ---"
$FLUTTER_BIN build apk --release
$FLUTTER_BIN build appbundle --release || true

if [ -f "${ROOT_DIR}/build/app/outputs/flutter-apk/app-release.apk" ]; then
  cp "${ROOT_DIR}/build/app/outputs/flutter-apk/app-release.apk" "${DIST_DIR}/zen-clock-v${VERSION}.apk"
  echo "✓ Android APK created: ${DIST_DIR}/zen-clock-v${VERSION}.apk"
fi

if [ -f "${ROOT_DIR}/build/app/outputs/bundle/release/app-release.aab" ]; then
  cp "${ROOT_DIR}/build/app/outputs/bundle/release/app-release.aab" "${DIST_DIR}/zen-clock-v${VERSION}.aab"
  echo "✓ Android App Bundle created: ${DIST_DIR}/zen-clock-v${VERSION}.aab"
fi

# 3. Web PWA Production Build
echo ""
echo "--- 3/4 Building Web Production PWA ---"
$FLUTTER_BIN build web --release

if [ -d "${ROOT_DIR}/build/web" ]; then
  tar -czvf "${DIST_DIR}/zen-clock-web-v${VERSION}.tar.gz" -C "${ROOT_DIR}/build/web" .
  echo "✓ Web Production bundle created: ${DIST_DIR}/zen-clock-web-v${VERSION}.tar.gz"
fi

# 4. Summary Output
echo ""
echo "================================================================="
echo "🎉 ALL PLATFORM BUILDS COMPLETED SUCCESSFULLY FOR v${VERSION}!"
echo "📦 Output Files in ./dist/ :"
echo "================================================================="
ls -lh "${DIST_DIR}"
