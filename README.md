# 🌿 Zen Digital Clock

> **Ultra-Lightweight, Modern, Cross-Platform Standby Digital Clock** for **Linux (GTK)**, **Windows (Win32)**, and **Android**.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows%20%7C%20Android-blue?style=for-the-badge)
![Themes](https://img.shields.io/badge/Themes-25%20Styles-purple?style=for-the-badge)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 🎨 25 Unique Theme Presets (រចនាប័ទ្មរូបរាងទាំង ២៥)

| # | Theme Name | Description | Color Palette |
| :--- | :--- | :--- | :--- |
| 1 | 🌿 **Nordic Zen** | Soft pastel minimalist design | Slate Dark & Sky Blue |
| 2 | 🌃 **Cyberpunk Neon** | Sci-Fi Glowing Neon Cyan & Pink | Cyan Glow & Magenta |
| 3 | 📜 **Retro Flip Clock** | Classic 3D Mechanical Card Flip | Matte Card & Warm Amber |
| 4 | 🖤 **OLED Pure Black** | High-contrast power saver for AMOLED | Pure Black & Pure White |
| 5 | 🪟 **Glassmorphism** | Frosted Acrylic Glass with Blur | Soft White & Ice Cyan |
| 6 | 🌆 **Sunset Vaporwave** | Retro 80s Cyberpunk Aesthetic | Deep Purple & Orange Glow |
| 7 | 🌌 **Deep Space Aurora** | Cosmic Aurora Borealis Glow | Navy Blue & Emerald Glow |
| 8 | 🍃 **Forest Bamboo Zen** | Calming Natural Bamboo Serenity | Sage Green & Soft Lime |
| 9 | 🍵 **Japanese Matcha** | Minimalist Wabi-Sabi Tea Aesthetic | Creamy Ivory & Soft Green |
| 10 | 🌅 **Golden Hour Sunrise** | Warm Morning Sun Glow | Dark Amber & Golden Yellow |
| 11 | 🌊 **Ocean Deep Abyss** | Oceanic Deep Blue Wave | Abyss Navy & Light Aqua |
| 12 | ☕ **Espresso Roast** | Warm Coffee House Warmth | Dark Cocoa & Caramel |
| 13 | 👾 **Arcade 8-Bit Pixel** | Retro Arcade CRT Television Scanline | Terminal CRT Green |
| 14 | 💎 **Luxury Gold & Marble** | Imperial Metallic Gold & Marble | Dark Slate & Pure Gold |
| 15 | 🌸 **Cherry Sakura** | Japanese Cherry Blossom Petals | Soft Rose & Pastel Pink |
| 16 | 🦾 **Neo Industrial Matrix** | Cyber Hacker Code Terminal | Pure Black & Matrix Green |
| 17 | ⚡ **Electrified Plasma** | High Energy Electric Glow | Violet & Plasma Blue |
| 18 | 🫐 **Midnight Berry** | Deep Blackberry & Plum Magic | Berry Plum & Magenta Glow |
| 19 | ❄️ **Arctic Frost Ice** | Crystal Glacier Ice | Deep Ice & Frost Blue |
| 20 | 📐 **Neo Brutalism** | High-Contrast Bold Drop Shadows | Off-Black & Canary Yellow |
| 21 | 🏛️ **Classic Roman Slate** | Elegant Antique Serif Slate | Slate Gray & Bone White |
| 22 | ⛺ **Campfire Twilight** | Evening Fireplace Warm Ember | Charcoal & Fire Orange |
| 23 | 🪐 **Saturn Rings Minimal** | Celestial Cosmos Rings | Cosmos Dark & Ring Gold |
| 24 | 🍉 **Summer Pop** | Playful Summer Coral & Yellow | Coral Pink & Sunshine Yellow |
| 25 | 🧘 **Chakra Meditation** | Serene Lotus Meditation Glow | Lavender & Lotus Pink |

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

## 🚀 Building from Source

```bash
git clone https://github.com/vathsathya/zen-clock.git
cd zen-clock

# 1. Linux Release Build
flutter build linux --release

# 2. Windows Release Build
flutter build windows --release

# 3. Android Release Build
flutter build apk --release
```

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.
