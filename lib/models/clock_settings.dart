import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreset {
  // Khmer Cultural Themes
  khmerAngkor, khmerKbach,

  // Original 5 Themes
  nordic, cyberpunk, flip, oled, glass,
  
  // 20 New Themes
  vaporwave, aurora, forest, matcha, goldenHour,
  oceanAbyss, espresso, pixel8bit, luxuryGold, sakura,
  matrix, plasma, midnightBerry, arcticFrost, neoBrutalism,
  romanSlate, campfire, saturnMinimal, summerPop, chakra
}

enum DisplayMode { fullscreen, widget }
enum OrientationMode { auto, horizontal, vertical }
enum DisplayTarget { secondary, primary }
enum TimeFormat { h12, h24 }

class ClockSettings extends ChangeNotifier {
  ThemePreset _themePreset = ThemePreset.khmerAngkor;
  DisplayMode _displayMode = DisplayMode.fullscreen;
  OrientationMode _orientationMode = OrientationMode.auto;
  DisplayTarget _displayTarget = DisplayTarget.secondary;
  TimeFormat _timeFormat = TimeFormat.h12;

  bool _showSeconds = true;
  bool _showDate = true;
  bool _useKhmerDigits = true;
  bool _showWeather = true;
  bool _showProverb = true;
  bool _oledPixelShift = true;
  bool _preventDisplaySleep = true;
  bool _alwaysOnTop = true;
  double _glassOpacity = 0.65;
  String _fontFamily = 'Kantumruy Pro';
  String _secondaryTimezone = 'New York (UTC-4)';

  ThemePreset get themePreset => _themePreset;
  DisplayMode get displayMode => _displayMode;
  OrientationMode get orientationMode => _orientationMode;
  DisplayTarget get displayTarget => _displayTarget;
  TimeFormat get timeFormat => _timeFormat;
  bool get showSeconds => _showSeconds;
  bool get showDate => _showDate;
  bool get useKhmerDigits => _useKhmerDigits;
  bool get showWeather => _showWeather;
  bool get showProverb => _showProverb;
  bool get oledPixelShift => _oledPixelShift;
  bool get preventDisplaySleep => _preventDisplaySleep;
  bool get alwaysOnTop => _alwaysOnTop;
  double get glassOpacity => _glassOpacity;
  String get fontFamily => _fontFamily;
  String get secondaryTimezone => _secondaryTimezone;

  ClockSettings() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _showSeconds = prefs.getBool('showSeconds') ?? true;
    _showDate = prefs.getBool('showDate') ?? true;
    _useKhmerDigits = prefs.getBool('useKhmerDigits') ?? true;
    _showWeather = prefs.getBool('showWeather') ?? true;
    _showProverb = prefs.getBool('showProverb') ?? true;
    _oledPixelShift = prefs.getBool('oledPixelShift') ?? true;
    _preventDisplaySleep = prefs.getBool('preventDisplaySleep') ?? true;
    _alwaysOnTop = prefs.getBool('alwaysOnTop') ?? true;
    _fontFamily = prefs.getString('fontFamily') ?? 'Kantumruy Pro';
    _secondaryTimezone = prefs.getString('secondaryTimezone') ?? 'New York (UTC-4)';
    notifyListeners();
  }

  void setTheme(ThemePreset preset) {
    _themePreset = preset;
    if (preset == ThemePreset.khmerAngkor || preset == ThemePreset.khmerKbach) {
      _useKhmerDigits = true;
    }
    notifyListeners();
  }

  void toggleShowWeather(bool val) {
    _showWeather = val;
    notifyListeners();
  }

  void toggleShowProverb(bool val) {
    _showProverb = val;
    notifyListeners();
  }

  void toggleKhmerDigits(bool val) {
    _useKhmerDigits = val;
    notifyListeners();
  }

  void toggleOledPixelShift(bool val) {
    _oledPixelShift = val;
    notifyListeners();
  }
}
