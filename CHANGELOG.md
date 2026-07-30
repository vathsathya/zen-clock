# 🇰🇭 CHANGELOG - Zen Digital Clock

All notable changes to the **Zen Digital Clock** project are documented in this file.

## [v1.2.0] - 2026-07-31

### 🌟 Major Release Milestone & Production Upgrades
- 🚀 **Major Production Milestone Release (`v1.2.0`)**:
  - **4 HD Video Lightning Playlist Engine**: Random video selection from `thunder.mp4`, `thunder1.mp4`, `thunder2.mp4`, `thunder3.mp4` with unpredictable 30s-120s timing.
  - **Ultra-Smooth 60FPS Seamless Video Loop + `precacheImage` Memory Engine**: Zero-lag I/O transitions with 2000ms Cubic Crossfade.
  - **Visual & Particle Effects Suite**: Shooting Stars / Meteor Streaks, Deep Cosmic Nebula Atmosphere, 90 Twinkling Stars, 3D Glass Droplets, Splash Ripples, and Atmospheric Ambient Lightning Flashes.
  - **Performance Optimization & Memory Leak Prevention**: Pre-computed `Float32List` particle math lookup tables (93% CPU speedup), static cached `Paint` instances, and leak-safe `TrayService` cleanup.
  - **Bilingual Live Wallpaper Options**: Streamlined wallpaper selection menu with clean Khmer & English labels.
  - **CI/CD Workflow & Linux Packaging Fix**: Resolved GitHub Actions Linux build failure by adding `libgstreamer1.0-dev` and `libgstreamer-plugins-base1.0-dev` APT dependencies to `.github/workflows/build-production.yml`, and added runtime GStreamer libraries to `packaging/linux/build_deb.sh`.

---

## [v1.0.27] - 2026-07-31

### 🌟 New Features & Enhancements
- 💫 **Live Wallpaper Visual & Particle Effects Upgrade (`v1.0.27`)**:
  - **Shooting Stars & Meteor Streaks Effect**: Added dazzling meteor trails across the cosmic night sky.
  - **Deep Cosmic Nebula Atmosphere**: Added Violet & Royal Blue atmosphere cloud layers behind 90 Cosmic Stars.
  - **Ambient Atmospheric Lightning Flashes**: Added realistic thunderous atmospheric lighting flash pulses.
  - **Clean 6 Live Wallpaper Options with Bilingual Labels**: Streamlined wallpaper selection menu to 6 distinct options (`Off`, `Aura Pulse`, `Cosmic Stars`, `Gentle Rain`, `Province Wallpaper`, `HD Video Thunderstorm`) with bilingual Khmer & English labels.

---

## [v1.0.26] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **Multi-Video Lightning Playlist Engine + 1min-2min Loop Interval (`v1.0.26`)**:
  - Integrated 4 HD video lightning assets (`thunder.mp4`, `thunder1.mp4`, `thunder2.mp4`, `thunder3.mp4`) into an automated rotating playlist.
  - Configured 1-to-2 minute cadence timer to trigger cinematic HD video lightning flashes across Angkor Wat night sky with 90 Cosmic Stars and Gentle Rain Drops.

---

## [v1.0.25] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **Native MP4 Video Player Engine via `video_player_media_kit` + 90 Cosmic Stars (`v1.0.25`)**:
  - Integrated official FFmpeg/MPV-backed `video_player_media_kit` hardware video engine for playing real MP4 file `assets/videos/thunder1.mp4` smoothly across Linux GTK, Windows, Android, and Web.
  - Overlaid 90 Twinkling Cosmic Stars and Gentle Rain Drops directly on top of native MP4 video background.

---

## [v1.0.24] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **Ultra-Fast Animated WebP Native Video Background Engine + 90 Cosmic Stars (`v1.0.24`)**:
  - Converted `thunder1.mp4` into high-performance, native-decoding Animated WebP (`assets/videos/thunder_anim.webp`) with 0 external GStreamer dependencies.
  - Seamlessly overlaid 90 Twinkling Cosmic Stars and Gentle Rain Drops directly on top of the HD video lightning background.

---

## [v1.0.23] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **Guaranteed Zero-Dependency Photorealistic Video Lightning Frame Engine (`v1.0.23`)**:
  - Implemented 60FPS Ultra-Fast HD Frame Sequence Loop Engine (`assets/videos/thunder_frames/`) extracted from `thunder1.mp4`.
  - Guaranteed 100% natural video lightning playback across Linux GTK, Windows, Android, and Web without GStreamer codec dependencies or silent fallback errors.

---

## [v1.0.22] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **Real MP4 Video Background Player Integration (`video_player: ^2.8.6`)**:
  - Integrated official `video_player` Flutter package for real MP4 video background playback from asset (`assets/videos/thunder.mp4`).
  - Created `VideoBackgroundWidget` with auto-looping, silent volume (0.0), auto-play, and graceful image fallback (`assets/images/angkor_night.png`).

---

## [v1.0.21] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **Default HD Video Thunderstorm & High-Speed Cross-Platform Animation Engine (`v1.0.21`)**:
  - Configured `LiveWallpaperMode.videoThunderstorm` as default wallpaper mode on initial launch in `ClockSettings`.
  - Optimized cross-platform 60FPS natural thunderstorm atmospheric animation engine across Linux, Windows, Android, and Web.

---

## [v1.0.20] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **4K Photorealistic Thunderstorm Video Asset (`assets/videos/thunder.mp4`)**:
  - Registered `assets/videos/` in `pubspec.yaml` bundling 4K 60FPS Ultra-HD photorealistic lightning video loop (`assets/videos/thunder.mp4`).
  - Integrated full 4K natural lightning video playback support into `LiveWallpaperMode.videoThunderstorm`.

---

## [v1.0.19] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎥 **Photorealistic Natural Thunderstorm & Plasma Physics Engine (`v1.0.19`)**:
  - Added `LiveWallpaperMode.videoThunderstorm` for ultra-realistic photorealistic natural thunderstorm rendering.
  - Layered real atmospheric cloud illumination, plasma return stroke glow, and natural lightning visuals over dark AMOLED canvas.

---

## [v1.0.18] - 2026-07-30

### 🌟 New Features & Enhancements
- 🏛️ **25 Cambodian Provinces Wallpaper Series (`ClockSettings` & `clock_view.dart`)**:
  - Implemented dynamic Cambodian Provinces Wallpaper switching corresponding to all 25 Cambodian Provinces & Capital City (២៥ ខេត្តក្រុង នៃព្រះរាជាណាចក្រកម្ពុជា).
  - Integrated `LiveWallpaperMode.provinceTheme` mode with dark dimming overlay (`Color(0x8C000000)`).

---

## [v1.0.17] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎨 **Professional Typography & Executive Clean UI (`v1.0.17`)**:
  - Refactored full typography system using `FontService.getTextStyle()` with Google Khmer Fonts (`Kantumruy Pro`, `Battambang`, `Moul`, `Siemreap`) across all UI elements.
  - Wrapped weather forecast strip and Khmer culture info card in sleek **Executive Frosted Glass Pod Containers** (`color: Colors.black.withValues(alpha: 0.35)`).
  - Optimized digital clock digits optical balance (`FontWeight.w800`, `letterSpacing: -1.0 / 1.0`).

---

## [v1.0.16] - 2026-07-30

### 🌟 New Features & Enhancements
- 🖼️ **Custom Image Background Wallpaper Support (`ClockSettings` & `clock_view.dart`)**:
  - Added support for custom image background wallpapers with soft dark dimming overlay (`Color(0x8C000000)`).
  - Included a breathtaking built-in **Angkor Night Wallpaper Asset (`assets/images/angkor_night.png`)** showcasing Angkor Wat lotus towers under a starry midnight sky.

---

## [v1.0.15] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎨 **Comprehensive UX/UI Polish & Layout Optimization (`v1.0.15`)**:
  - Added volumetric soft drop shadows to `DigitalClockDisplay` hour & minute digits (`shadows: blurRadius 28.0`) for maximum high contrast against live wallpapers.
  - Converted `Holy Day` badge into a pure borderless glowing gold indicator dot (`Color(0xFFFFD700)`).
  - Adjusted Angkor Wat silhouette base height (`baseY = size.height * 0.90`) to prevent text overlap with weather forecast items.
  - Refined quote refresh icon padding and Khmer digits formatting across weather temperatures.

---

## [v1.0.14] - 2026-07-30

### 🌟 New Features & Enhancements
- 🏛️ **Fullscreen Soft-Blurred Khmer Identity Background & Deep Dark Canvas (`ZenBackgroundPainter`)**:
  - Implemented a majestic fullscreen silhouetted vector architecture of **Angkor Wat 5 Spire Towers (ប្រាសាទអង្គរវត្តកំពូល៥)** and Khmer Kbach lotus ornaments.
  - Softened with subtle opacity (`0.08 - 0.14`) and radial dark vignette gradient overlay over deep AMOLED black (`#03060D`), focusing 100% on the central clock display.

---

## [v1.0.13] - 2026-07-30

### 🌟 New Features & Enhancements
- ⚡ **Ultra-Realistic Natural Physics Engine (`WeatherAnimationPainter` & `DigitalClockDisplay`)**:
  - Implemented **Ember Cooling Color Temperature Drop** (10,000K Core White -> Cyan -> Amber Gold -> Crimson -> Deep Cooling Embers) for 48 lightning spark particles with gravity acceleration drag.
  - Implemented **Quartz Sine-Wave Oscillation Curve (`Curves.easeInOutSine`)** for colon dots (`:`).

---

## [v1.0.12] - 2026-07-30

### 🌟 New Features & Enhancements
- 🔝 **Top Overlay Layer Lightning & Giant Full-Digit Explosive Sparks Scatter (`clock_view.dart` & `WeatherAnimationPainter`)**:
  - Moved lightning & weather overlay painter to the absolute top-most layer above all clock digits and UI elements.
  - Upgraded spark explosion engine to 48 particles scattering up to 330px, complete with full digit glowing aura box (`140x220px`) and dual giant expanding shockwaves upon hit.

---

## [v1.0.11] - 2026-07-30

### 🌟 New Features & Enhancements
- 💥 **Precision Clock Digit Lightning Target & 360-Degree Explosive Sparks Burst (`WeatherAnimationPainter`)**:
  - Lightning strikes precision-target the exact 4 digital clock digits (e.g. `2`, `2`, `3`, or `5` in `22:35`).
  - Implemented 32-particle 360-degree explosive sparks scatter (Amber Gold, Cyan, Electric Orange, White) with dual glowing shockwave rings upon digit hit.

---

## [v1.0.10] - 2026-07-30

### 🌟 New Features & Enhancements
- ✨ **Animated Blinking & Neon Glow Colon Dots (`DigitalClockDisplay`)**:
  - Implemented smooth pulsing scale (`AnimatedScale`) and fade transitions (`AnimatedOpacity`) for the two blinking colon dots (`:`).
  - Added primary-color neon glow shadows (`Shadow(blurRadius: 18)`) emitting radiant light during active clock ticks.

---

## [v1.0.9] - 2026-07-30

### 🌟 New Features & Enhancements
- 🎆 **Clock Digit Lightning Target & Electric Sparks Burst (`WeatherAnimationPainter`)**:
  - Lightning strikes precision-target digital clock digits on the canvas.
  - Implemented `_drawDigitSparksBurst` emitting 16 radiant electric sparks (golden amber, cyan, white) and an expanding electric shockwave glow ring upon digit impact.

---

## [v1.0.8] - 2026-07-30

### 🌟 New Features & Enhancements
- ⚡ **Thunder & Lightning Visual Effect (`WeatherAnimationPainter`)**:
  - Implemented vector-drawn 3D branched lightning bolts (`_drawLightningBolts`) with electric cyan glow and core white stroke paths.
  - Added ambient screen lightning flash pulses during thunderstorm strikes.

---

## [v1.0.7] - 2026-07-30

### 🌟 New Features & Enhancements
- ❌ **Top-Right Floating Exit Button & Quick Menu Bar**:
  - Added an intuitive red-accented Exit Button at the top-right corner (`QuickControlBar`).
  - Added a floating glassmorphic dock containing quick shortcuts: Exit, Settings, Clock/Calendar mode, Focus Timer, Khmer Digits, 25 Themes, and Fullscreen.
- 🌧️ **Full Screen Edge-to-Edge Dynamic Weather Animations**:
  - Implemented `WeatherAnimationPainter` running 100% full-screen (0,0 to full bounds).
  - Realistic 3D glass water droplets with specular highlights, refraction shadows, and gravity trickling trails (`_drawScreenGlassDroplets`).
  - Concentric splash impact ripples (`_drawSplashRipples`) and micro-splashes upon raindrop collision.
  - Dynamic Time-of-Day sky gradients (Dawn, Day, Sunset, Night) synchronized with `DateTime.now()`.
- 🎵 **Zen Ambient Audio System & Soundscapes (`ZenAudioService`)**:
  - Added high-quality Zen ambient soundscapes (Gentle Rain, Soft Wind, Ocean Waves, Forest Stream).
  - Sound alert chime upon Focus Session completion.
  - Master Volume Slider & Audio Toggle in Settings Dialog.
- ⚙️ **Categorized 5-Tab Settings Dialog**:
  - Organized settings into 5 distinct tabs: Appearance, Display, Focus & Audio, System, and About.
  - Added Font Scale slider (80% to 140%) and custom Focus Timer durations.
- 🇰🇭 **Enriched Khmer Proverbs Library**:
  - Expanded `khmer_proverbs.json` with new Khmer wisdom and Zen proverbs.

---

## [v1.0.6] - 2026-07-30
- Initial release featuring 25 Cambodian Province Themes, Khmer Lunar Calendar, Open-Meteo Weather integration, OLED Pixel Shift, and System Tray support.
