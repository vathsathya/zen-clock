# 🇰🇭 Zen Digital Clock - 25 Cambodian Provinces Edition (v1.2.0)

> **Ultra-Lightweight, Modern, Cambodian Standby Digital Clock** with 25 Cambodian Province Themes, 5-Day Weather Forecast, Khmer Lunar Calendar, AMOLED Dark Canvas, and Customizable Focus Timer for **Linux (GTK)**, **Windows (Win32)**, **Android**, and **Web PWA**.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows%20%7C%20Android%20%7C%20Web-blue?style=for-the-badge)
![Province Themes](https://img.shields.io/badge/Themes-25%20Cambodian%20Provinces-red?style=for-the-badge)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![Version](https://img.shields.io/badge/Version-v1.2.0-gold?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 🌟 Key Features & User Guide (មុខងារសំខាន់ៗ & មគ្គុទ្ទេសក៍ប្រើប្រាស់)

### 1. 🏛️ 25 Cambodian Province Themes (២៥ ខេត្តក្រុង នៃព្រះរាជាណាចក្រកម្ពុជា)
- Tailored color palettes, cultural highlights, and representative icons for all 25 Cambodian provinces and capital city.
- High-contrast AMOLED-friendly digital clock display with glowing drop shadows and customized Google Khmer Fonts (`Kantumruy Pro`, `Battambang`, `Moul`, `Siemreap`).

### 2. 📅 Khmer Lunar Calendar & Holy Day Indicators (ប្រតិទិនចន្ទគតិ & ថ្ងៃសីល)
- Displays traditional Khmer lunar dates (e.g. `ថ្ងៃ ៧ រោច ខែ អាសាឍ ឆ្នាំ ឆ្មោះ`).
- Features a glowing gold indicator dot (`#FFFFD700`) on Buddhist Holy Days (ថ្ងៃសីល ៨កើត, ៨រោច, ១៥កើត, ១៥រោច).

### 3. 🌧️ Live Wallpaper & Atmospheric Weather Physics
- **6 Live Wallpaper Modes**: `Off`, `Aura Pulse`, `Cosmic Stars`, `Gentle Rain`, `Province Theme Wallpaper`, and `HD Video Thunderstorm`.
- Dynamic 60FPS particle engine: 90 Twinkling Cosmic Stars, Shooting Star Meteor Trails, Deep Cosmic Nebula Clouds, 3D Glass Raindrops with Specular Highlights, Concentric Splash Ripples, and Atmospheric Lightning Flashes.
- Multi-Video Lightning Playlist Engine rotating 4 HD video clips (`thunder.mp4`, `thunder1.mp4`, `thunder2.mp4`, `thunder3.mp4`) with smooth zero-lag 2000ms Cubic Crossfades.

### 4. 🌤️ 5-Day Weather Forecast & Khmer Digits Option
- Synchronized Open-Meteo API weather updates (temperature, humidity, weather icons, and 5-day forecasts).
- Native support for switching between Khmer numerals (`០១២៣៤៥៦៧៨៩`) and Western digits (`0123456789`) across all UI elements.

### 5. ⏱️ Zen Focus Timer & Ambient Audio Soundscapes
- Built-in Pomodoro/Focus Session timer with ambient chime notifications.
- Integrated soundscapes: Gentle Rain, Soft Wind, Ocean Waves, and Forest Streams.

### 6. 🖥️ Multi-Monitor Standby & System Tray Protection
- Automatically detects single vs. multi-monitor desktop setups:
  - **Single Monitor**: Minimizes cleanly to System Tray (`tray_manager`) to stay out of the way.
  - **Multi-Monitor**: Displays edge-to-edge as a dedicated standby clock on your secondary monitor.

---

## 📥 Installation Guide (មគ្គុទ្ទេសក៍ដំឡើង)

### Linux (Ubuntu / Debian / Linux Mint)

#### Option 1: Native `.deb` Installer Package (Recommended)
Download `zen-clock_1.2.0_amd64.deb` from the [GitHub Releases](https://github.com/vathsathya/zen-clock/releases) page and install:
```bash
sudo dpkg -i zen-clock_1.2.0_amd64.deb
sudo apt-get install -f # Install any missing dependencies if needed
```
Launch from your application menu or run `zen-clock` in terminal.

#### Option 2: Portable Linux Tarball
```bash
tar -xzvf zen-clock-linux-v1.2.0-x64.tar.gz
cd zen-clock-linux-v1.2.0-x64
./zen_clock
```

---

### Windows (Windows 10 / 11)

#### Option 1: Setup Installer (`.exe`)
Download and run `ZenClock-Setup-v1.0.1.exe` from [GitHub Releases](https://github.com/vathsathya/zen-clock/releases) to install desktop shortcuts and autostart capabilities.

#### Option 2: Portable ZIP Archive
Extract `zen-clock-windows-v1.2.0-x64.zip` and run `zen_clock.exe`.

---

### Android Mobile & Tablet

Download `zen-clock-v1.2.0.apk` from [GitHub Releases](https://github.com/vathsathya/zen-clock/releases), open the APK on your Android device, and grant installation permissions.

---

## 🚀 Building from Source (ការបង្កើតចេញពី Source Code)

### Prerequisites for Linux (GTK Build)
Before building on Linux (Ubuntu/Debian), install all required C/C++ compiler and audio/video development headers:
```bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  clang \
  cmake \
  ninja-build \
  pkg-config \
  libgtk-3-dev \
  liblzma-dev \
  libstdc++6 \
  libayatana-appindicator3-dev \
  libdbus-1-dev \
  libglib2.0-dev \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  dpkg-dev
```

### Build Commands

```bash
git clone https://github.com/vathsathya/zen-clock.git
cd zen-clock

# Clean & fetch dependencies
flutter clean
flutter pub get

# 1. Linux Desktop Release Build
flutter build linux --release

# 2. Windows Release Build
flutter build windows --release

# 3. Android Release Build (APK & App Bundle)
flutter build apk --release
flutter build appbundle --release

# 4. Web Production PWA Build
flutter build web --release

# 5. Automated Multi-Platform Build Script
chmod +x build.sh
./build.sh
```

---

## 🤖 Automated CI/CD Workflow

Zen Clock uses **GitHub Actions** (`.github/workflows/build-production.yml`) to automatically compile, package, and publish release artifacts upon tagging (`v*`) or pushing to `main`:
- **Linux**: Compiles GTK binary & packages `.deb` installer + `.tar.gz` archive.
- **Windows**: Compiles Win32 executable & builds Inno Setup installer (`.exe`) + `.zip` archive.
- **Android**: Compiles release `.apk` and App Bundle (`.aab`).
- **Web**: Compiles Web PWA distribution package (`.tar.gz`).
- **Release**: Automatically drafts and publishes GitHub Releases via `softprops/action-gh-release@v2`.

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.
