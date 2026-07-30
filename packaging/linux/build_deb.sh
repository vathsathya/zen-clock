#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION=$(grep '^version:' "${ROOT_DIR}/pubspec.yaml" | sed 's/version: //' | cut -d '+' -f 1 | tr -d ' \r\n')
if [ -z "$VERSION" ]; then
  VERSION="1.0.6"
fi

ARCH="amd64"
PACKAGE_NAME="zen-clock_${VERSION}_${ARCH}"
BUILD_BUNDLE="${ROOT_DIR}/build/linux/x64/release/bundle"
DEB_DIR="${ROOT_DIR}/build/deb_tmp"

echo "=== Building Ubuntu .deb package for Zen Clock v${VERSION} ==="

if [ ! -d "${BUILD_BUNDLE}" ]; then
  echo "Error: Linux release bundle not found at ${BUILD_BUNDLE}. Run 'flutter build linux --release' first."
  exit 1
fi

rm -rf "${DEB_DIR}" "${ROOT_DIR}/${PACKAGE_NAME}.deb"
mkdir -p "${DEB_DIR}/DEBIAN"
mkdir -p "${DEB_DIR}/usr/bin"
mkdir -p "${DEB_DIR}/usr/lib/zen-clock"
mkdir -p "${DEB_DIR}/usr/share/applications"
mkdir -p "${DEB_DIR}/usr/share/icons/hicolor/256x256/apps"

# 1. Copy Linux release bundle to /usr/lib/zen-clock/
cp -r "${BUILD_BUNDLE}/"* "${DEB_DIR}/usr/lib/zen-clock/"

# 2. Create launcher wrapper in /usr/bin/zen-clock
cat << 'EOF' > "${DEB_DIR}/usr/bin/zen-clock"
#!/bin/bash
exec /usr/lib/zen-clock/zen_clock "$@"
EOF
chmod +x "${DEB_DIR}/usr/bin/zen-clock"

# 3. Copy desktop entry
cp "${ROOT_DIR}/packaging/linux/zen-clock.desktop" "${DEB_DIR}/usr/share/applications/"

# 4. Copy app icon
if [ -f "${ROOT_DIR}/assets/icons/app_icon.png" ]; then
  cp "${ROOT_DIR}/assets/icons/app_icon.png" "${DEB_DIR}/usr/share/icons/hicolor/256x256/apps/zen-clock.png"
fi

# 5. Create DEBIAN/control file
cat << EOF > "${DEB_DIR}/DEBIAN/control"
Package: zen-clock
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: Vath Sathya <vath.sathya@gmail.com>
Section: utils
Priority: optional
Depends: libgtk-3-0, libglib2.0-0, libayatana-appindicator3-1, libgstreamer1.0-0, libgstreamer-plugins-base1.0-0
Description: Ultra-Lightweight Zen Digital Clock with 100% Khmer Culture & Weather Forecast
 Ultra-lightweight AMOLED digital clock with 25 Cambodian province themes,
 5-day weather forecast, Khmer lunar calendar, and customizable focus timer.
EOF

# 6. Build .deb package
dpkg-deb --build "${DEB_DIR}" "${ROOT_DIR}/${PACKAGE_NAME}.deb"

echo "✓ Successfully created ${PACKAGE_NAME}.deb at ${ROOT_DIR}/${PACKAGE_NAME}.deb"
