import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreset {
  // 20 100% Khmer Cultural Themes
  khmerAngkor,       // ស្ទាយ៍អង្គរមាស
  khmerKbach,        // ស្ទាយ៍ក្បាច់បុរាណ
  khmerBayon,        // ស្ទាយ៍ប្រាសាទបាយ័ន
  khmerBanteaySrei,  // ស្ទាយ៍បន្ទាយស្រី
  khmerHolPhamuong,  // ស្ទាយ៍ហូលផាមួងខ្មែរ
  khmerTonleSap,     // ស្ទាយ៍បឹងទន្លេសាប
  khmerKrama,        // ស្ទាយ៍ក្រមាខ្មែរ
  khmerSiemRiver,    // ស្ទាយ៍ដងស្ទឹងសៀមរាប
  khmerPhnomKulen,   // ស្ទាយ៍ភ្នំគូលែន
  khmerLotus,        // ស្ទាយ៍ផ្កាឈូកខ្មែរ
  khmerApsara,       // ស្ទាយ៍របាំអប្សរា
  khmerKepOcean,     // ស្ទាយ៍សមុទ្រកែប
  khmerWatPhnom,     // ស្ទាយ៍វត្តភ្នំ
  khmerMangoHarvest, // ស្ទាយ៍ស្វាយកែវរៀត
  khmerRoyalPalace,  // ស្ទាយ៍ព្រះបរមរាជវាំង
  khmerPreahVihear,  // ស្ទាយ៍ប្រាសាទព្រះវិហារ
  khmerSbekThom,     // ស្ទាយ៍ស្បែកធំ
  khmerGoldenStupa,  // ស្ទាយ៍ចេតិយមាស
  khmerRiceField,    // ស្ទាយ៍ស្រូវវស្សាខ្មែរ
  khmerPhnomPenhNight// ស្ទាយ៍រាត្រីភ្នំពេញ
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
  bool _useKhmerDigits = true; // Always true for Khmer cultural themes
  bool _showWeather = true;
  bool _showProverb = true;
  bool _oledPixelShift = true;
  bool _preventDisplaySleep = true;
  bool _alwaysOnTop = true;
  double _glassOpacity = 0.65;
  String _fontFamily = 'Kantumruy Pro';

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
    notifyListeners();
  }

  void setTheme(ThemePreset preset) {
    _themePreset = preset;
    _useKhmerDigits = true;
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
