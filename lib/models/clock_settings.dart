import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import '../services/tray_service.dart';

enum ThemePreset {
  // 25 Cambodian Provinces Theme Series (២៥ ខេត្តក្រុង នៃព្រះរាជាណាចក្រកម្ពុជា)
  battambang,       // 🍌 ខេត្តបាត់ដំបង (Ta Dambong & Golden Oranges) - HIGHLIGHT!
  siemReap,         // 🏛️ ខេត្តសៀមរាប (Angkor Wat Heritage)
  phnomPenh,        // 👑 រាជធានីភ្នំពេញ (Royal Palace & Riverside Glow)
  kep,              // 🦀 ខេត្តកែប (Kep Crab & Blue Sea)
  sihanoukville,    // 🏖️ ខេត្តព្រះសីហនុ (Golden Lions & Turquoise Beach)
  kampot,           // 🌶️ ខេត្តកំពត (Kampot Black Pepper & Bokor Mist)
  mondulkiri,       // 🐘 ខេត្តមណ្ឌលគិរី (Pine Forest & Waterfalls)
  ratanakiri,       // 💎 ខេត្តរតនគិរី (Red Earth & Zircon Gems)
  preahVihear,      // 🏔️ ខេត្តព្រះវិហារ (Mountain Cliff Temple)
  kampongChhnang,   // 🏺 ខេត្តកំពង់ឆ្នាំង (Khmer Pottery & Floating Village)
  kampongSpeu,      // 🌴 ខេត្តកំពង់ស្ពឺ (Palm Sugar Gold)
  kampongThom,      // 🐟 ខេត្តកំពង់ធំ (Sambor Prei Kuk Brick)
  kampongCham,      // 🛥️ ខេត្តកំពង់ចាម (Bamboo Bridge & Mekong River)
  kratie,           // 🎋 ខេត្តក្រចេះ (Irrawaddy Dolphin & Sunset Mekong)
  stungTreng,       // 🌿 ខេត្តស្ទឹងត្រែង (Sekong River & Wetlands)
  preyVeng,         // 🌾 ខេត្តព្រៃវែង (Fertile Paddy Fields)
  svayRieng,        // 🚣 ខេត្តស្វាយរៀង (Border Sun & Lotus Ponds)
  takeo,            // 🏺 ខេត្តតាកែវ (Phnom Chisor Ancient Cradle)
  pursat,           // ⛰️ ខេត្តពោធិ៍សាត់ (Cardamom Mountains & Marble)
  banteayMeanchey,  // 🌾 ខេត្តបន្ទាយមានជ័យ (Banteay Chhmar Ruins)
  oddarMeanchey,   // 🍃 ខេត្តឧត្តរមានជ័យ (Dangrek Mountain Range)
  pailin,           // 🌳 ខេត្តប៉ៃលិន (Pailin Gemstones & Peacock)
  kohKong,          // 🌄 ខេត្តកោះកុង (Mangrove Forests & Estuary)
  tboungKhmum,      // 🌾 ខេត្តត្បូងឃ្មុំ (Rubber Plantation Emerald)
  kandal            // 🏛️ ខេត្តកណ្តាល (Koh Dach Silk Island)
}

enum DisplayMode { clock, calendar }
enum LiveWallpaperMode { off, auraPulse, cosmicStars, gentleRain }
enum OrientationMode { auto, horizontal, vertical }
enum DisplayTarget { secondary, primary }
enum TimeFormat { h12, h24 }

class ClockSettings extends ChangeNotifier {
  ThemePreset _themePreset = ThemePreset.battambang; // Highlight Battambang by Default!
  DisplayMode _displayMode = DisplayMode.clock;
  LiveWallpaperMode _liveWallpaperMode = LiveWallpaperMode.auraPulse;
  OrientationMode _orientationMode = OrientationMode.auto;
  DisplayTarget _displayTarget = DisplayTarget.secondary;
  TimeFormat _timeFormat = TimeFormat.h12;

  bool _showSeconds = true;
  bool _showDate = true;
  bool _useKhmerDigits = true;
  bool _showWeather = true;
  bool _showProverb = true;
  bool _showKhmerZodiac = true;
  bool _showKhmerHolidays = true;
  bool _showKhmerHolyDays = true;
  bool _oledPixelShift = true;
  bool _preventDisplaySleep = true;
  bool _alwaysOnTop = true;
  bool _autoSecondaryDisplay = true;
  double _glassOpacity = 0.65;
  String _fontFamily = 'Kantumruy Pro';

  ThemePreset get themePreset => _themePreset;
  DisplayMode get displayMode => _displayMode;
  LiveWallpaperMode get liveWallpaperMode => _liveWallpaperMode;
  OrientationMode get orientationMode => _orientationMode;
  DisplayTarget get displayTarget => _displayTarget;
  TimeFormat get timeFormat => _timeFormat;
  bool get showSeconds => _showSeconds;
  bool get showDate => _showDate;
  bool get useKhmerDigits => _useKhmerDigits;
  bool get showWeather => _showWeather;
  bool get showProverb => _showProverb;
  bool get showKhmerZodiac => _showKhmerZodiac;
  bool get showKhmerHolidays => _showKhmerHolidays;
  bool get showKhmerHolyDays => _showKhmerHolyDays;
  bool get oledPixelShift => _oledPixelShift;
  bool get preventDisplaySleep => _preventDisplaySleep;
  bool get alwaysOnTop => _alwaysOnTop;
  bool get autoSecondaryDisplay => _autoSecondaryDisplay;
  double get glassOpacity => _glassOpacity;
  String get fontFamily => _fontFamily;

  ClockSettings() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt('themePreset') ?? ThemePreset.battambang.index;
    if (themeIndex >= 0 && themeIndex < ThemePreset.values.length) {
      _themePreset = ThemePreset.values[themeIndex];
    }
    int displayModeIndex = prefs.getInt('displayMode') ?? DisplayMode.clock.index;
    if (displayModeIndex >= 0 && displayModeIndex < DisplayMode.values.length) {
      _displayMode = DisplayMode.values[displayModeIndex];
    }
    int liveWallpaperIndex = prefs.getInt('liveWallpaperMode') ?? LiveWallpaperMode.auraPulse.index;
    if (liveWallpaperIndex >= 0 && liveWallpaperIndex < LiveWallpaperMode.values.length) {
      _liveWallpaperMode = LiveWallpaperMode.values[liveWallpaperIndex];
    }
    int timeFormatIndex = prefs.getInt('timeFormat') ?? TimeFormat.h12.index;
    if (timeFormatIndex >= 0 && timeFormatIndex < TimeFormat.values.length) {
      _timeFormat = TimeFormat.values[timeFormatIndex];
    }
    _showSeconds = prefs.getBool('showSeconds') ?? true;
    _showDate = prefs.getBool('showDate') ?? true;
    _useKhmerDigits = prefs.getBool('useKhmerDigits') ?? true;
    _showWeather = prefs.getBool('showWeather') ?? true;
    _showProverb = prefs.getBool('showProverb') ?? true;
    _showKhmerZodiac = prefs.getBool('showKhmerZodiac') ?? true;
    _showKhmerHolidays = prefs.getBool('showKhmerHolidays') ?? true;
    _showKhmerHolyDays = prefs.getBool('showKhmerHolyDays') ?? true;
    _oledPixelShift = prefs.getBool('oledPixelShift') ?? true;
    _preventDisplaySleep = prefs.getBool('preventDisplaySleep') ?? true;
    _autoSecondaryDisplay = prefs.getBool('autoSecondaryDisplay') ?? true;
    _fontFamily = prefs.getString('fontFamily') ?? 'Kantumruy Pro';

    try {
      await TrayService.instance.updateMenu(useKhmerDigits: _useKhmerDigits, displayMode: _displayMode);
    } catch (_) {}

    notifyListeners();
  }

  void setDisplayMode(DisplayMode mode) async {
    _displayMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('displayMode', mode.index);
    try {
      await TrayService.instance.updateMenu(useKhmerDigits: _useKhmerDigits, displayMode: mode);
    } catch (_) {}
    notifyListeners();
  }

  void setLiveWallpaperMode(LiveWallpaperMode mode) async {
    _liveWallpaperMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('liveWallpaperMode', mode.index);
    notifyListeners();
  }

  void setFontFamily(String font) async {
    _fontFamily = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', font);
    notifyListeners();
  }

  void setTheme(ThemePreset preset) async {
    _themePreset = preset;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themePreset', preset.index);
    notifyListeners();
  }

  void setTimeFormat(TimeFormat format) async {
    _timeFormat = format;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeFormat', format.index);
    notifyListeners();
  }

  void toggleShowSeconds(bool val) async {
    _showSeconds = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showSeconds', val);
    notifyListeners();
  }

  void toggleShowDate(bool val) async {
    _showDate = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDate', val);
    notifyListeners();
  }

  void toggleShowWeather(bool val) async {
    _showWeather = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showWeather', val);
    notifyListeners();
  }

  void toggleShowProverb(bool val) async {
    _showProverb = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showProverb', val);
    notifyListeners();
  }

  void toggleShowKhmerZodiac(bool val) async {
    _showKhmerZodiac = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showKhmerZodiac', val);
    notifyListeners();
  }

  void toggleShowKhmerHolidays(bool val) async {
    _showKhmerHolidays = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showKhmerHolidays', val);
    notifyListeners();
  }

  void toggleShowKhmerHolyDays(bool val) async {
    _showKhmerHolyDays = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showKhmerHolyDays', val);
    notifyListeners();
  }

  void toggleKhmerDigits(bool val) async {
    _useKhmerDigits = val;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('useKhmerDigits', val);
      await TrayService.instance.updateMenu(useKhmerDigits: val, displayMode: _displayMode);
    } catch (e) {
      debugPrint('Error persisting language setting: $e');
    }
  }

  void toggleOledPixelShift(bool val) async {
    _oledPixelShift = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('oledPixelShift', val);
    notifyListeners();
  }

  void toggleAlwaysOnTop(bool val) async {
    _alwaysOnTop = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alwaysOnTop', val);
    try {
      await windowManager.setAlwaysOnTop(val);
    } catch (_) {}
    notifyListeners();
  }

  void toggleAutoSecondaryDisplay(bool val) async {
    _autoSecondaryDisplay = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoSecondaryDisplay', val);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _themePreset = ThemePreset.battambang;
    _timeFormat = TimeFormat.h12;
    _showSeconds = true;
    _showDate = true;
    _useKhmerDigits = true;
    _showWeather = true;
    _showProverb = true;
    _oledPixelShift = true;
    _preventDisplaySleep = true;
    _alwaysOnTop = true;
    try {
      await windowManager.setAlwaysOnTop(true);
    } catch (_) {}
    notifyListeners();
  }
}
