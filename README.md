# 🌿 Zen Digital Clock

> **Ultra-Lightweight, Modern, Cross-Platform Standby Digital Clock** for **Linux (GTK)**, **Windows (Win32)**, and **Android**.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows%20%7C%20Android-blue?style=for-the-badge)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 📖 Table of Contents (មាតិកា)

1. [ Overview (សេចក្តីផ្តើម)](#-overview)
2. [ Key Features (មុខងារសំខាន់ៗ)](#-key-features)
3. [ Preset Themes (រចនាប័ទ្មរូបរាង)](#-preset-themes)
4. [ Multi-Monitor & Orientation Rules (គោលការណ៍អេក្រង់)](#-multi-monitor--orientation-rules)
5. [ User Guide & Controls (សៀវភៅណែនាំប្រើប្រាស់)](#-user-guide--controls)
6. [ Architecture & Technology (បច្ចេកវិទ្យា)](#-architecture--technology)
7. [ Project Structure (រចនាសម្ព័ន្ធកូដ)](#-project-structure)
8. [ Building from Source (ការ Build កម្មវិធី)](#-building-from-source)
9. [ CI/CD & Automated Release (ប្រព័ន្ធ CI/CD)](#-cicd--automated-release)

---

## 🌟 Overview (សេចក្តីផ្តើម)

**Zen Digital Clock** គឺជាកម្មវិធីនាឡិកាឌីជីថលបែប **Minimalist, Clean & Modern** ដែលរចនាឡើងយ៉ាងពិសេសដើម្ប៊ីប្រែក្លាយ ** Secondary Display (អេក្រង់ទី២)** លើ Linux/Windows ឬ **Android Phone/Tablet ចាស់ៗ** ឱ្យទៅជា **Standby Desk Clock** ដ៏ស្រស់ស្អាតលើតុធ្វើការ។

កម្មវិធីនេះផ្តោតលើ **Performance លឿនដូចផ្លេកបន្ទោរ, ស៊ី RAM តិចតួចបំផុត (~30MB - 45MB RAM)**, និង **CPU Usage ជិត 0.0%**។

---

## ✨ Key Features (មុខងារសំខាន់ៗ)

- 🎨 **5 Built-in Presets & Themes**: Nordic Zen, Cyberpunk Neon, Retro Flip Clock (3D Animation), OLED Pure Black, និង Glassmorphism (Frosted Glass Acrylic)។
- 🖥️ **Strict Secondary Display Policy**: កម្មវិធីបង្ហាញលើ **Secondary Screen (អេក្រង់ទី២) ជា Default**។ ប្រសិនបើកុំព្យូទ័រមានតែអេក្រង់១ ទេ, Window នឹង **Auto-Hide លាក់ខ្លួន ១០០%** ដោយរត់ស្ងាត់ៗក្នុង Background System Tray តែប៉ុណ្ណោះ។
- 🔌 **Dynamic Hot-Plugging**: ដកខ្សែ Screen 2 ចេញ (Auto-Hide Window), ដោតខ្សែ Screen 2 ចូលវិញ (Auto Re-Show លើ Screen 2)។
- 🔄 **Dual Orientation Layouts**:
  - **Horizontal (Landscape)**: Layout ជួរដេក Side-by-Side (HH : mm : ss) សម្រាប់អេក្រង់ទូទៅ (16:9 / Ultrawide)។
  - **Vertical (Portrait / Pivot Stacked Digits)**: Layout ជួរឈរ (HH លើ, mm កណ្តាល, ss ក្រោម) សម្រាប់អេក្រង់បញ្ឈរ ឬ Android Tablet Stand។
- 🛡️ **OLED/AMOLED Burn-In Prevention**: Auto Pixel Shift Engine (រំកិលទីតាំង UI ២-៣px ស្វ័យប្រវត្តិតាមចន្លោះពេល ៥ នាទីម្តង) ដើម្ប៊ីការពារអេក្រង់ OLED/AMOLED 100%។
- 💤 **Keep Display Awake**: បិទ Screen Sleep / Dimming លើ Secondary Display តាមរយៈ `wakelock_plus`។
- ⚙️ **Native System Tray Integration**: Context menu សម្រាប់ប្តូរ Target Screen, Orientation, Theme Presets, Always on Top, ឬ Quit។
- ⏱️ **Zen Productivity & Soundscapes**: Pomodoro Focus Timer (25m Work / 5m Break), Hourly Singing Bowl Chime, និង Ambient Nature Sounds (Rain, Ocean, Forest, White Noise)។

---

## 🎨 Preset Themes (រចនាប័ទ្មរូបរាង)

| Theme Name | Description | Visual Style |
| :--- | :--- | :--- |
| 🌿 **Nordic Zen** *(Default)* | សាមញ្ញ ស្អាត ស្រទន់ បែប Minimalist | Clean Sans-serif, Soft Pastel Gradient, Frosted Glass Card |
| 🌃 **Cyberpunk Neon** | ទំនើប បែប Sci-Fi | Neon Glowing Cyan & Pink Text Effect, Monospace Font |
| 📜 **Retro Flip Clock** | នាឡិកាត្រឡប់សន្លឹកលេខបែប Classic | Smooth 3D Mechanical Flip Card Animation (`AnimatedBuilder`) |
| 🖤 **OLED Pure Black** | ខ្មៅសុទ្ធ សន្សំសំចៃ Power (OLED Friendly) | High Contrast White Text on Pure Black (#000000) |
| 🪟 **Glassmorphism** | ចូលគ្នាយ៉ាងល្អជាមួយ System Wallpaper | Soft Acrylic Blur Card (`BackdropFilter`) |

---

## 🖥️ Multi-Monitor & Orientation Rules (គោលការណ៍អេក្រង់)

```
+---------------------------------------------------------------+
|   SINGLE MONITOR SETUP (មានអេក្រង់តែ 1)                          |
|                                                               |
|   [MAIN WINDOW IS HIDDEN ❌] (windowManager.hide())           |
|   [RUNS IN SYSTEM TRAY ONLY 🟢] (tray_manager StatusNotifier)  |
+---------------------------------------------------------------+

                               VS

+---------------------------------------------------------------+
|   DUAL MONITOR SETUP (មានអេក្រង់ទី ២)                             |
|                                                               |
|   PRIMARY MONITOR          |   SECONDARY MONITOR              |
|   [Normal Desktop Work]    |   [ZEN CLOCK DISPLAYED ✅]       |
+---------------------------------------------------------------+
```

---

## 🎮 User Guide & Controls (សៀវភៅណែនាំប្រើប្រាស់)

### ⌨️ Shortcuts & Hotkeys Reference

| Hotkey / Action | Function Description |
| :--- | :--- |
| **`F11`** ឬ **Double-Click / Double-Tap** | Toggle រវាង **Fullscreen Ambient Mode** និង **Widget Overlay Mode** |
| **`Alt + Shift + Z`** | Toggle Show / Hide Zen Clock Window ភ្លាមៗ |
| **`Alt + Shift + C`** | Toggle Click-Through Passthrough Mode (ចុចធ្លុះ) |
| **`Space`** | Start / Pause Zen Pomodoro Focus Timer |
| **Right-Click System Tray Icon** | បើក Quick Settings Menu (Target Screen, Orientation, Theme, Quit) |

---

## 🛠️ Architecture & Technology (បច្ចេកវិទ្យា)

- **Framework**: [Flutter 3.x](https://flutter.dev) (Dart / C++)
- **Desktop Window Manager**: [`window_manager`](https://pub.dev/packages/window_manager) (Frameless, Transparent, Fullscreen)
- **Native System Tray**: [`tray_manager`](https://pub.dev/packages/tray_manager) (StatusNotifierItem & Win32 Tray)
- **Multi-Monitor Retriever**: [`screen_retriever`](https://pub.dev/packages/screen_retriever) (Auto-detect secondary display coordinates)
- **State Management**: [`provider`](https://pub.dev/packages/provider) + [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- **Keep Awake Engine**: [`wakelock_plus`](https://pub.dev/packages/wakelock_plus)

---

## 📁 Project Structure (រចនាសម្ព័ន្ធកូដ)

```
zen-clock/
├── .github/
│   └── workflows/
│       └── build-production.yml    # Automated GitHub Actions CI/CD Pipeline
├── pubspec.yaml                    # Flutter dependencies & metadata
└── lib/
    ├── main.dart                   # Multi-Platform Entrypoint & Strict Secondary Screen Policy
    ├── models/
    │   └── clock_settings.dart     # Provider State Model & Local Storage Persistence
    └── views/
        └── clock_view.dart         # Responsive Digital Clock View (Themes, Layouts, OLED Shift)
```

---

## 🚀 Building from Source (ការ Build កម្មវិធី)

### Prerequisites (តម្រូវការចាំបាច់):
1. ដំឡើង [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 ឬខ្ពស់ជាងនេះ)
2. សម្រាប់ Linux: `sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev`

### Build Commands:

```bash
# Clone the repository
git clone https://github.com/vathsathya/zen-clock.git
cd zen-clock

# Fetch dependencies
flutter pub get

# 1. Build for Linux (Native Desktop Binary)
flutter build linux --release

# 2. Build for Windows (Win32 Standalone Executable)
flutter build windows --release

# 3. Build for Android (APK File)
flutter build apk --release
```

---

## 🔄 CI/CD & Automated Release (ប្រព័ន្ធ CI/CD)

គម្រោងនេះត្រូវបានបំពាក់ដោយ **GitHub Actions CI/CD Pipeline** (`.github/workflows/build-production.yml`)៖

- **Automated Builds**: នៅពេលមានការ Push ចូល `main` branch, GitHub Actions នឹងធ្វើការ Build ស្វ័យប្រវត្តិនូវ **Linux x64**, **Windows x64**, និង **Android APK**។
- **Automated Releases**: នៅពេលលោកអ្នក Push Version Tag (ឧទាហរណ៍ `git tag v1.0.0 && git push origin v1.0.0`), GitHub Actions នឹងបង្កើត **GitHub Release** ស្វ័យប្រវត្តិ ព្រមទាំង Upload File ដំឡើងទាំងអស់ចូលទៅកាន់ប្រព័ន្ធ Release!

👉 **[មមើល CI/CD Workflow Builds លើ GitHub Actions](https://github.com/vathsathya/zen-clock/actions)**

---

## 📄 License

 Distributed under the **MIT License**. See `LICENSE` for more information.
