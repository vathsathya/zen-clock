import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clock_settings.dart';
import '../services/weather_service.dart';

class ClockStyleData {
  final Color bgColor;
  final Color cardColor;
  final Color textColor;
  final Color accentColor;
  final Color borderColor;
  final List<Shadow> shadows;
  final String name;

  const ClockStyleData({
    required this.bgColor,
    required this.cardColor,
    required this.textColor,
    required this.accentColor,
    required this.borderColor,
    required this.shadows,
    required this.name,
  });
}

class ClockView extends StatefulWidget {
  const ClockView({super.key});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  late DateTime _now;
  Timer? _timer;
  int _shiftX = 0;
  int _shiftY = 0;

  WeatherInfo? _weatherInfo;

  static const List<String> _khmerDays = [
    'ថ្ងៃច័ន្ទ', 'ថ្ងៃអង្គារ', 'ថ្ងៃពុធ', 'ថ្ងៃព្រហស្បតិ៍', 'ថ្ងៃសុក្រ', 'ថ្ងៃសៅរ៍', 'ថ្ងៃអាទិត្យ'
  ];

  static const List<String> _khmerMonths = [
    'មករា', 'កុម្ភៈ', 'មីនា', 'មេសា', 'ឧសភា', 'មិថុនា', 'កក្កដា', 'សីហា', 'កញ្ញា', 'តុលា', 'វិច្ឆិកា', 'ធ្នូ'
  ];

  static const List<String> _khmerProverbs = [
    "ការអត់ធ្មត់ជាដើមទុននៃជោគជ័យ",
    "ចេះពីរៀន មានពីរកែ",
    "ចំណេះជាទ្រព្យជាប់កាយ",
    "ស្ទឹងជ្រៅស្ងាត់ជ្រងំ អ្នកប្រាជ្ញស្ងៀមស្ងាត់",
    "ធ្វើល្អបានល្អ ធ្វើអាក្រក់បានអាក្រក់",
    "សន្តិភាពចាប់ផ្តើមពីក្នុងចិត្ត",
    "ចំណេះជាអាវក្រោះការពារខ្លួន"
  ];

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });

    _loadWeather();

    Timer.periodic(const Duration(minutes: 5), (timer) {
      final settings = Provider.of<ClockSettings>(context, listen: false);
      if (settings.oledPixelShift) {
        setState(() {
          _shiftX = (_shiftX + 2) % 6 - 3;
          _shiftY = (_shiftY + 1) % 6 - 3;
        });
      }
    });
  }

  Future<void> _loadWeather() async {
    final weather = await WeatherService.fetchLiveWeather();
    if (mounted) {
      setState(() {
        _weatherInfo = weather;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _toKhmerDigits(String input) {
    const arabic = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const khmer = ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'];
    String result = input;
    for (int i = 0; i < arabic.length; i++) {
      result = result.replaceAll(arabic[i], khmer[i]);
    }
    return result;
  }

  ClockStyleData _getStyleData(ThemePreset preset) {
    switch (preset) {
      case ThemePreset.khmerAngkor:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍អង្គរមាស (Khmer Angkor Gold)",
          bgColor: Color(0xFF0B132B),
          cardColor: Color(0xFF1C2541),
          textColor: Color(0xFFFFD700),
          accentColor: Color(0xFFE5C158),
          borderColor: Color(0xFFFFD700),
          shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 25)],
        );
      case ThemePreset.khmerKbach:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ក្បាច់បុរាណ (Khmer Kbach Silk)",
          bgColor: Color(0xFF3D0007),
          cardColor: Color(0xFF5E000C),
          textColor: Color(0xFFFBE8A6),
          accentColor: Color(0xFFD4AF37),
          borderColor: Color(0xFFD4AF37),
          shadows: [Shadow(color: Color(0xFFD4AF37), blurRadius: 20)],
        );
      case ThemePreset.khmerBayon:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ប្រាសាទបាយ័ន (Khmer Bayon Stone)",
          bgColor: Color(0xFF1A1D20),
          cardColor: Color(0xFF2B303A),
          textColor: Color(0xFFD1D5DB),
          accentColor: Color(0xFF7C9885),
          borderColor: Color(0xFF7C9885),
          shadows: [Shadow(color: Color(0xFF7C9885), blurRadius: 15)],
        );
      case ThemePreset.khmerBanteaySrei:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍បន្ទាយស្រី (Banteay Srei Pink Sandstone)",
          bgColor: Color(0xFF3B1E1B),
          cardColor: Color(0xFF5C2D27),
          textColor: Color(0xFFFFC6FF),
          accentColor: Color(0xFFD48C84),
          borderColor: Color(0xFFD48C84),
          shadows: [Shadow(color: Color(0xFFD48C84), blurRadius: 20)],
        );
      case ThemePreset.khmerHolPhamuong:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ហូលផាមួងខ្មែរ (Khmer Hol Phamuong)",
          bgColor: Color(0xFF1D0047),
          cardColor: Color(0xFF3A0CA3),
          textColor: Color(0xFFF72585),
          accentColor: Color(0xFF4CC9F0),
          borderColor: Color(0xFFF72585),
          shadows: [Shadow(color: Color(0xFFF72585), blurRadius: 25)],
        );
      case ThemePreset.khmerTonleSap:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍បឹងទន្លេសាប (Tonle Sap Water Blue)",
          bgColor: Color(0xFF03045E),
          cardColor: Color(0xFF0077B6),
          textColor: Color(0xFF90E0EF),
          accentColor: Color(0xFFFFB703),
          borderColor: Color(0xFF90E0EF),
          shadows: [Shadow(color: Color(0xFF90E0EF), blurRadius: 20)],
        );
      case ThemePreset.khmerKrama:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ក្រមាខ្មែរ (Khmer Krama Red & White)",
          bgColor: Color(0xFF2B090A),
          cardColor: Color(0xFF5E0B0E),
          textColor: Color(0xFFFDF0D5),
          accentColor: Color(0xFFC1121F),
          borderColor: Color(0xFFC1121F),
          shadows: [Shadow(color: Color(0xFFC1121F), blurRadius: 20)],
        );
      case ThemePreset.khmerSiemRiver:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ដងស្ទឹងសៀមរាប (Siem Reap River)",
          bgColor: Color(0xFF0D1B2A),
          cardColor: Color(0xFF1B263B),
          textColor: Color(0xFF52B788),
          accentColor: Color(0xFFE0E1DD),
          borderColor: Color(0xFF52B788),
          shadows: [Shadow(color: Color(0xFF52B788), blurRadius: 20)],
        );
      case ThemePreset.khmerPhnomKulen:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ភ្នំគូលែន (Phnom Kulen Mountain)",
          bgColor: Color(0xFF0F201B),
          cardColor: Color(0xFF1E352F),
          textColor: Color(0xFFA3E635),
          accentColor: Color(0xFF34D399),
          borderColor: Color(0xFFA3E635),
          shadows: [Shadow(color: Color(0xFFA3E635), blurRadius: 20)],
        );
      case ThemePreset.khmerLotus:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ផ្កាឈូកខ្មែរ (Khmer Lotus Flower)",
          bgColor: Color(0xFF26101B),
          cardColor: Color(0xFF3D182B),
          textColor: Color(0xFFFF85A1),
          accentColor: Color(0xFF38B000),
          borderColor: Color(0xFFFF85A1),
          shadows: [Shadow(color: Color(0xFFFF85A1), blurRadius: 20)],
        );
      case ThemePreset.khmerApsara:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍របាំអប្សរា (Apsara Dance Gold)",
          bgColor: Color(0xFF1C2526),
          cardColor: Color(0xFF264653),
          textColor: Color(0xFFF4A261),
          accentColor: Color(0xFFE76F51),
          borderColor: Color(0xFFF4A261),
          shadows: [Shadow(color: Color(0xFFF4A261), blurRadius: 25)],
        );
      case ThemePreset.khmerKepOcean:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍សមុទ្រកែប (Kep Ocean Breeze)",
          bgColor: Color(0xFF0A192F),
          cardColor: Color(0xFF172A45),
          textColor: Color(0xFF64FFDA),
          accentColor: Color(0xFFF4A261),
          borderColor: Color(0xFF64FFDA),
          shadows: [Shadow(color: Color(0xFF64FFDA), blurRadius: 20)],
        );
      case ThemePreset.khmerWatPhnom:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍វត្តភ្នំ (Wat Phnom Heritage)",
          bgColor: Color(0xFF1A1615),
          cardColor: Color(0xFF2D2421),
          textColor: Color(0xFFD4A373),
          accentColor: Color(0xFFFAEDCD),
          borderColor: Color(0xFFD4A373),
          shadows: [],
        );
      case ThemePreset.khmerMangoHarvest:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ស្វាយកែវរៀត (Golden Mango Harvest)",
          bgColor: Color(0xFF1F1A0A),
          cardColor: Color(0xFF382F12),
          textColor: Color(0xFFFFB703),
          accentColor: Color(0xFF2A9D8F),
          borderColor: Color(0xFFFFB703),
          shadows: [Shadow(color: Color(0xFFFFB703), blurRadius: 25)],
        );
      case ThemePreset.khmerRoyalPalace:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ព្រះបរមរាជវាំង (Royal Palace Night)",
          bgColor: Color(0xFF1F002B),
          cardColor: Color(0xFF38004D),
          textColor: Color(0xFFFFD700),
          accentColor: Color(0xFFF72585),
          borderColor: Color(0xFFFFD700),
          shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 30)],
        );
      case ThemePreset.khmerPreahVihear:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ប្រាសាទព្រះវិហារ (Preah Vihear Cliff)",
          bgColor: Color(0xFF131924),
          cardColor: Color(0xFF212C3D),
          textColor: Color(0xFFE0FBFC),
          accentColor: Color(0xFF3D5A80),
          borderColor: Color(0xFFE0FBFC),
          shadows: [Shadow(color: Color(0xFFE0FBFC), blurRadius: 20)],
        );
      case ThemePreset.khmerSbekThom:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ស្បែកធំ (Sbek Thom Shadow Puppet)",
          bgColor: Color(0xFF121212),
          cardColor: Color(0xFF212121),
          textColor: Color(0xFFF97316),
          accentColor: Color(0xFFFB923C),
          borderColor: Color(0xFFF97316),
          shadows: [Shadow(color: Color(0xFFF97316), blurRadius: 25)],
        );
      case ThemePreset.khmerGoldenStupa:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ចេតិយមាស (Golden Stupa)",
          bgColor: Color(0xFF0D1117),
          cardColor: Color(0xFF161B22),
          textColor: Color(0xFFE5A93C),
          accentColor: Color(0xFFF3D280),
          borderColor: Color(0xFFE5A93C),
          shadows: [Shadow(color: Color(0xFFE5A93C), blurRadius: 20)],
        );
      case ThemePreset.khmerRiceField:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍ស្រូវវស្សាខ្មែរ (Golden Rice Field)",
          bgColor: Color(0xFF1C1914),
          cardColor: Color(0xFF332D24),
          textColor: Color(0xFFE9C46A),
          accentColor: Color(0xFF2A9D8F),
          borderColor: Color(0xFFE9C46A),
          shadows: [Shadow(color: Color(0xFFE9C46A), blurRadius: 20)],
        );
      case ThemePreset.khmerPhnomPenhNight:
        return const ClockStyleData(
          name: "🇰🇭 ស្ទាយ៍រាត្រីភ្នំពេញ (Phnom Penh Night Glow)",
          bgColor: Color(0xFF090A0F),
          cardColor: Color(0xFF121524),
          textColor: Color(0xFF00F3FF),
          accentColor: Color(0xFFD62828),
          borderColor: Color(0xFF00F3FF),
          shadows: [Shadow(color: Color(0xFF00F3FF), blurRadius: 30)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ClockSettings>(context);
    final style = _getStyleData(settings.themePreset);

    String rawHours = settings.timeFormat == TimeFormat.h12 
        ? (_now.hour % 12 == 0 ? 12 : _now.hour % 12).toString().padLeft(2, '0')
        : _now.hour.toString().padLeft(2, '0');
    String rawMinutes = _now.minute.toString().padLeft(2, '0');
    String rawSeconds = _now.second.toString().padLeft(2, '0');
    String amPm = settings.timeFormat == TimeFormat.h12 ? (_now.hour >= 12 ? 'PM' : 'AM') : '';

    final hours = _toKhmerDigits(rawHours);
    final minutes = _toKhmerDigits(rawMinutes);
    final seconds = _toKhmerDigits(rawSeconds);

    // Khmer Date formatting
    final khmerDay = _khmerDays[_now.weekday - 1];
    final khmerMonth = _khmerMonths[_now.month - 1];
    final khmerYear = _toKhmerDigits(_now.year.toString());
    final khmerDateStr = "$khmerDay, ទី${_toKhmerDigits(_now.day.toString())} ខែ$khmerMonth ឆ្នាំ$khmerYear";

    // Daily Khmer Proverb
    final proverbIndex = _now.day % _khmerProverbs.length;
    final dailyProverb = _khmerProverbs[proverbIndex];

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || settings.orientationMode == OrientationMode.vertical;

    return Scaffold(
      backgroundColor: style.bgColor,
      body: Transform.translate(
        offset: Offset(_shiftX.toDouble(), _shiftY.toDouble()),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
            decoration: BoxDecoration(
              color: style.cardColor.withOpacity(settings.glassOpacity),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: style.borderColor, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Khmer Theme Name Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: style.textColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: style.textColor.withOpacity(0.35)),
                  ),
                  child: Text(
                    style.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: style.textColor, letterSpacing: 1.1),
                  ),
                ),

                if (!isPortrait) ...[
                  // Landscape Layout (Khmer Digits)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$hours:$minutes",
                        style: TextStyle(
                          fontSize: 125,
                          fontWeight: FontWeight.w900,
                          color: style.textColor,
                          shadows: style.shadows,
                        ),
                      ),
                      if (settings.showSeconds) ...[
                        const SizedBox(width: 16),
                        Text(
                          seconds,
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: style.accentColor,
                          ),
                        ),
                      ],
                      if (amPm.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Text(
                          amPm,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: style.textColor.withOpacity(0.7)),
                        ),
                      ]
                    ],
                  ),
                ] else ...[
                  // Portrait Layout (Stacked Digits)
                  Text(
                    hours,
                    style: TextStyle(fontSize: 135, fontWeight: FontWeight.w900, color: style.textColor, shadows: style.shadows),
                  ),
                  Container(width: 80, height: 4, color: style.accentColor, margin: const EdgeInsets.symmetric(vertical: 8)),
                  Text(
                    minutes,
                    style: TextStyle(fontSize: 135, fontWeight: FontWeight.w900, color: style.textColor, shadows: style.shadows),
                  ),
                ],

                // Live Weather & Khmer Date Display
                if (settings.showDate) ...[
                  const SizedBox(height: 18),
                  Text(
                    khmerDateStr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: style.textColor.withOpacity(0.85), letterSpacing: 1.1),
                  ),
                ],

                // Live Weather Widget
                if (settings.showWeather && _weatherInfo != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_weatherInfo!.conditionIcon, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        "${_toKhmerDigits(_weatherInfo!.temperature.toStringAsFixed(0))}°C ${_weatherInfo!.locationName} (${_weatherInfo!.conditionName})",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: style.accentColor),
                      ),
                    ],
                  ),
                ],

                // Daily Khmer Proverb Display
                if (settings.showProverb) ...[
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    decoration: BoxDecoration(
                      color: style.textColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: style.textColor.withOpacity(0.18)),
                    ),
                    child: Text(
                      "📜 \"$dailyProverb\"",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: style.textColor.withOpacity(0.95)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
