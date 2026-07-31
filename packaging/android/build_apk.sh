#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION=$(grep '^version:' "${ROOT_DIR}/pubspec.yaml" | sed 's/version: //' | cut -d '+' -f 1 | tr -d ' \r\n')
if [ -z "$VERSION" ]; then
  VERSION="1.2.1"
fi
OUTPUT_DIR="${ROOT_DIR}/build/app/outputs/flutter-apk"
TARGET_APK="${ROOT_DIR}/zen-clock-v${VERSION}.apk"
FLUTTER_BIN="/home/yanich/.flutter/bin/flutter"

if [ ! -f "$FLUTTER_BIN" ]; then
  FLUTTER_BIN="flutter"
fi

echo "=== Building Android Release APK for Zen Clock v${VERSION} ==="

$FLUTTER_BIN build apk --release

if [ -f "${OUTPUT_DIR}/app-release.apk" ]; then
  cp "${OUTPUT_DIR}/app-release.apk" "${TARGET_APK}"
  echo "✓ Successfully created production APK: ${TARGET_APK}"
else
  echo "Error: app-release.apk not found!"
  exit 1
fi
