import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

enum DisplayMode { fullscreen, widget }
enum OrientationMode { auto, horizontal, vertical }
enum DisplayTarget { secondary, primary }
enum TimeFormat { h12, h24 }

class ClockSettings extends ChangeNotifier {
  ThemePreset _themePreset = ThemePreset.battambang; // Highlight Battambang by Default!
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
