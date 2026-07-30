# 🇰🇭 PROJECT RULES & ARCHITECTURAL GUIDELINES: ZEN CLOCK

## 1. MANDATORY IMPLEMENTATION PLAN PROTOCOL
- For every user prompt or request, you MUST ALWAYS create an implementation plan (`implementation_plan.md`) first and obtain explicit user approval before making any code modifications or proceeding with execution.

## 2. ARCHITECTURE & STATE ISOLATION
- State Management: All application state (Theme, DisplayMode, Language, Font, FocusTimer, Audio Settings, Weather options) MUST be encapsulated within `ClockSettings` (`ChangeNotifier`).
- Persistence: Any newly introduced preference MUST be asynchronously persisted to `SharedPreferences` with default fallbacks and broadcasted via `notifyListeners()`.
- Unidirectional Data Flow: Views and widgets must reactively listen to `ClockSettings` state via `Provider` or `Consumer`.

## 3. LOCALIZATION & KHMER DIGITS INTEGRITY (i18n)
- Numeric Conversion: Every number displayed in the UI (clock digits, dates, weather temperatures, timer countdowns, list badges) MUST respect the `useKhmerDigits` setting via `KhmerStringUtils`.
- Bilingual Strings: All user-facing UI labels must provide bilingual support for Khmer (primary) and English (secondary).
- Typography: Always use `FontService.getTextStyle()` when creating TextStyles to support dynamic Google Khmer Fonts loading seamlessly.

## 4. CROSS-PLATFORM & DESKTOP SYSTEM TRAY SAFETY
- Desktop-Only Checks: Always verify `Platform.isLinux || Platform.isWindows || Platform.isMacOS` before calling desktop plugins (`windowManager`, `trayManager`).
- Async Safety: Wrap all UI updates following async operations with `if (mounted)` checks to prevent memory leaks and crashes.
- Immersive Mode: On Android/Mobile, maintain sticky immersive fullscreen and wake lock management.

## 5. OLED DISPLAY PROTECTION & PERFORMANCE
- Anti-Burn-In: Long-running clock views must utilize `oledPixelShift` periodic timer offsets to protect OLED/AMOLED screens.
- Animation Efficiency: Keep Live Wallpaper particle animations, tickers, and opacity transitions lightweight to minimize CPU and GPU overhead on all target platforms.

## 6. AUTOMATED BUILD & RUN COMMAND PROTOCOL
- Pre-Build Cleanup: Before executing any production build, ALWAYS clean up the project first (e.g. `flutter clean` and `flutter pub get`).
- Build Execution: After executing any approved implementation plan, ALWAYS perform a production build (e.g. `./build.sh` or `flutter build linux --release`).
- Run Command Output: Always provide the exact shell command to launch the updated app binary (e.g., `./build/linux/x64/release/bundle/zen_clock` or `sudo dpkg -i dist/zen-clock_1.0.6_amd64.deb`) so the user can immediately test the result.

## 7. VERSION BUMP PROTOCOL
- New Features: Whenever adding a NEW feature or functionality, ALWAYS bump the version in `pubspec.yaml` (e.g., from `1.0.6+6` to `1.0.7+7`).
- Code Refactoring & Bug Fixes: If only refactoring, polishing, or bug-fixing existing code without adding new features, DO NOT bump the version.

## 8. DEEP REVIEW & VERIFICATION REPORT PROTOCOL
- Deep Review & Verification: After executing any implementation plan, ALWAYS perform a deep review of all modified code components, verify generated production artifacts in `./dist/`, and present a comprehensive report summarizing recent achievements, current build status, and exact execution commands.

## 9. DOCUMENTATION MAINTENANCE PROTOCOL
- Documentation Upgrade: After completing a deep review and verification, ALWAYS update and upgrade project documentation (such as `README.md`, `CHANGELOG.md`, and inline docs) to accurately reflect all newly added features, version bumps, build instructions, and execution commands.
