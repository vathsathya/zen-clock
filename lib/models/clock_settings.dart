import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreset { nordic, cyberpunk, flip, oled, glass }
enum DisplayMode { fullscreen, widget }
enum OrientationMode { auto, horizontal, vertical }
enum DisplayTarget { secondary, primary }
enum TimeFormat { h12, h24 }

class ClockSettings extends ChangeNotifier {
  ThemePreset _themePreset = ThemePreset.nordic;
  DisplayMode _displayMode = DisplayMode.fullscreen;
  OrientationMode _orientationMode = OrientationMode.auto;
  DisplayTarget _displayTarget = DisplayTarget.secondary;
  TimeFormat _timeFormat = TimeFormat.h12;

  bool _showSeconds = true;
  bool _showDate = true;
  bool _oledPixelShift = true;
  bool _preventDisplaySleep = true;
  bool _alwaysOnTop = true;
  double _glassOpacity = 0.65;
  String _fontFamily = 'Outfit';

  ThemePreset get themePreset => _themePreset;
  DisplayMode get displayMode => _displayMode;
  OrientationMode get orientationMode => _orientationMode;
  DisplayTarget get displayTarget => _displayTarget;
  TimeFormat get timeFormat => _timeFormat;
  bool get showSeconds => _showSeconds;
  bool get showDate => _showDate;
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
    _oledPixelShift = prefs.getBool('oledPixelShift') ?? true;
    _preventDisplaySleep = prefs.getBool('preventDisplaySleep') ?? true;
    _alwaysOnTop = prefs.getBool('alwaysOnTop') ?? true;
    _fontFamily = prefs.getString('fontFamily') ?? 'Outfit';
    notifyListeners();
  }

  void setTheme(ThemePreset preset) {
    _themePreset = preset;
    notifyListeners();
  }

  void setDisplayMode(DisplayMode mode) {
    _displayMode = mode;
    notifyListeners();
  }

  void setOrientation(OrientationMode mode) {
    _orientationMode = mode;
    notifyListeners();
  }

  void setDisplayTarget(DisplayTarget target) {
    _displayTarget = target;
    notifyListeners();
  }

  void toggleShowSeconds(bool val) {
    _showSeconds = val;
    notifyListeners();
  }

  void toggleOledPixelShift(bool val) {
    _oledPixelShift = val;
    notifyListeners();
  }
}
