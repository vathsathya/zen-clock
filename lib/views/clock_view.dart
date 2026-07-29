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
    "សន្តិភាពចាប់ផ្តើមពីក្នុងចិត្ត"
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

    // Fetch Live Weather
    _loadWeather();

    // OLED Pixel Shift every 5 minutes
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
      case ThemePreset.nordic:
        return const ClockStyleData(
          name: "🌿 Nordic Zen",
          bgColor: Color(0xFF0F172A),
          cardColor: Color(0xFF1E293B),
          textColor: Colors.white,
          accentColor: Color(0xFF38BDF8),
          borderColor: Colors.white10,
          shadows: [Shadow(color: Color(0x6638BDF8), blurRadius: 20)],
        );
      case ThemePreset.cyberpunk:
        return const ClockStyleData(
          name: "🌃 Cyberpunk Neon",
          bgColor: Colors.black,
          cardColor: Color(0xFF0D0D15),
          textColor: Color(0xFF00F3FF),
          accentColor: Color(0xFFFF0055),
          borderColor: Color(0xFF00F3FF),
          shadows: [Shadow(color: Color(0xFF00F3FF), blurRadius: 35)],
        );
      case ThemePreset.flip:
        return const ClockStyleData(
          name: "📜 Retro Flip Clock",
          bgColor: Color(0xFF111827),
          cardColor: Color(0xFF1F2937),
          textColor: Color(0xFFF59E0B),
          accentColor: Color(0xFFFBBF24),
          borderColor: Colors.white12,
          shadows: [],
        );
      case ThemePreset.oled:
        return const ClockStyleData(
          name: "🖤 OLED Pure Black",
          bgColor: Colors.black,
          cardColor: Colors.black,
          textColor: Colors.white,
          accentColor: Colors.white70,
          borderColor: Colors.transparent,
          shadows: [],
        );
      case ThemePreset.glass:
        return const ClockStyleData(
          name: "🪟 Glassmorphism",
          bgColor: Color(0xFF0284C7),
          cardColor: Color(0x33FFFFFF),
          textColor: Colors.white,
          accentColor: Color(0xFFBAE6FD),
          borderColor: Colors.white24,
          shadows: [Shadow(color: Colors.black26, blurRadius: 15)],
        );
      default:
        return const ClockStyleData(
          name: "🌿 Nordic Zen",
          bgColor: Color(0xFF0F172A),
          cardColor: Color(0xFF1E293B),
          textColor: Colors.white,
          accentColor: Color(0xFF38BDF8),
          borderColor: Colors.white10,
          shadows: [],
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

    final hours = settings.useKhmerDigits ? _toKhmerDigits(rawHours) : rawHours;
    final minutes = settings.useKhmerDigits ? _toKhmerDigits(rawMinutes) : rawMinutes;
    final seconds = settings.useKhmerDigits ? _toKhmerDigits(rawSeconds) : rawSeconds;

    // Date formatting
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
              color: style.cardColor.withOpacity(settings.themePreset == ThemePreset.oled ? 1.0 : settings.glassOpacity),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: style.borderColor, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Theme Name Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: style.textColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: style.textColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    style.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: style.textColor, letterSpacing: 1.1),
                  ),
                ),

                if (!isPortrait) ...[
                  // Landscape Layout
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$hours:$minutes",
                        style: TextStyle(
                          fontSize: 120,
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
                            fontSize: 48,
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
                  // Portrait Layout
                  Text(
                    hours,
                    style: TextStyle(fontSize: 130, fontWeight: FontWeight.w900, color: style.textColor, shadows: style.shadows),
                  ),
                  Container(width: 80, height: 4, color: style.accentColor, margin: const EdgeInsets.symmetric(vertical: 8)),
                  Text(
                    minutes,
                    style: TextStyle(fontSize: 130, fontWeight: FontWeight.w900, color: style.textColor, shadows: style.shadows),
                  ),
                ],

                // Live Weather & Date Display
                if (settings.showDate) ...[
                  const SizedBox(height: 16),
                  Text(
                    settings.useKhmerDigits ? khmerDateStr : "WED, JUL 30, 2026",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: style.textColor.withOpacity(0.8), letterSpacing: 1.1),
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
                        "${settings.useKhmerDigits ? _toKhmerDigits(_weatherInfo!.temperature.toStringAsFixed(0)) : _weatherInfo!.temperature.toStringAsFixed(0)}°C ${_weatherInfo!.locationName} (${_weatherInfo!.conditionName})",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: style.accentColor),
                      ),
                    ],
                  ),
                ],

                // Khmer Proverb / Zen Quote Display
                if (settings.showProverb) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: style.textColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: style.textColor.withOpacity(0.15)),
                    ),
                    child: Text(
                      "📜 \"$dailyProverb\"",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: style.textColor.withOpacity(0.9), fontStyle: FontStyle.italic),
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
