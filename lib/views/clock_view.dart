import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clock_settings.dart';

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

  static const List<String> _khmerDays = [
    'ថ្ងៃច័ន្ទ', 'ថ្ងៃអង្គារ', 'ថ្ងៃពុធ', 'ថ្ងៃព្រហស្បតិ៍', 'ថ្ងៃសុក្រ', 'ថ្ងៃសៅរ៍', 'ថ្ងៃអាទិត្យ'
  ];

  static const List<String> _khmerMonths = [
    'មករា', 'កុម្ភៈ', 'មីនា', 'មេសា', 'ឧសភា', 'មិថុនា', 'កក្កដា', 'សីហា', 'កញ្ញា', 'តុលា', 'វិច្ឆិកា', 'ធ្នូ'
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
      // Khmer Cultural Themes
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

      // Original 5 Themes
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

      // 20 New Themes
      case ThemePreset.vaporwave:
        return const ClockStyleData(
          name: "🌆 Sunset Vaporwave",
          bgColor: Color(0xFF1A002C),
          cardColor: Color(0xFF2D004B),
          textColor: Color(0xFFFF007F),
          accentColor: Color(0xFFFF8C00),
          borderColor: Color(0xFFFF007F),
          shadows: [Shadow(color: Color(0xFFFF007F), blurRadius: 30)],
        );
      case ThemePreset.aurora:
        return const ClockStyleData(
          name: "🌌 Deep Space Aurora",
          bgColor: Color(0xFF0B0F19),
          cardColor: Color(0xFF151D2A),
          textColor: Color(0xFF00FFAB),
          accentColor: Color(0xFF7B2CBF),
          borderColor: Color(0xFF00FFAB),
          shadows: [Shadow(color: Color(0xFF00FFAB), blurRadius: 25)],
        );
      case ThemePreset.forest:
        return const ClockStyleData(
          name: "🍃 Forest Bamboo Zen",
          bgColor: Color(0xFF1B2A1C),
          cardColor: Color(0xFF2C402E),
          textColor: Color(0xFFA8E6CF),
          accentColor: Color(0xFF56AB2F),
          borderColor: Color(0xFF56AB2F),
          shadows: [Shadow(color: Color(0xFF56AB2F), blurRadius: 15)],
        );
      case ThemePreset.matcha:
        return const ClockStyleData(
          name: "🍵 Japanese Matcha",
          bgColor: Color(0xFFF7F4EA),
          cardColor: Color(0xFFE8E5DA),
          textColor: Color(0xFF354F52),
          accentColor: Color(0xFF84A98C),
          borderColor: Color(0xFFCAD2C5),
          shadows: [],
        );
      case ThemePreset.goldenHour:
        return const ClockStyleData(
          name: "🌅 Golden Hour Sunrise",
          bgColor: Color(0xFF1C1300),
          cardColor: Color(0xFF332400),
          textColor: Color(0xFFFFB703),
          accentColor: Color(0xFFFB8500),
          borderColor: Color(0xFFFFB703),
          shadows: [Shadow(color: Color(0xFFFFB703), blurRadius: 25)],
        );
      case ThemePreset.oceanAbyss:
        return const ClockStyleData(
          name: "🌊 Ocean Deep Abyss",
          bgColor: Color(0xFF03045E),
          cardColor: Color(0xFF0077B6),
          textColor: Color(0xFF90E0EF),
          accentColor: Color(0xFF00B4D8),
          borderColor: Color(0xFF90E0EF),
          shadows: [Shadow(color: Color(0xFF90E0EF), blurRadius: 20)],
        );
      case ThemePreset.espresso:
        return const ClockStyleData(
          name: "☕ Espresso Roast",
          bgColor: Color(0xFF1C120C),
          cardColor: Color(0xFF2B1B17),
          textColor: Color(0xFFFAEDCD),
          accentColor: Color(0xFFD4A373),
          borderColor: Color(0xFFD4A373),
          shadows: [],
        );
      case ThemePreset.pixel8bit:
        return const ClockStyleData(
          name: "👾 Arcade 8-Bit Pixel",
          bgColor: Colors.black,
          cardColor: Color(0xFF051C05),
          textColor: Color(0xFF00FF66),
          accentColor: Color(0xFF33FF00),
          borderColor: Color(0xFF00FF66),
          shadows: [Shadow(color: Color(0xFF00FF66), blurRadius: 20)],
        );
      case ThemePreset.luxuryGold:
        return const ClockStyleData(
          name: "💎 Luxury Gold & Marble",
          bgColor: Color(0xFF121212),
          cardColor: Color(0xFF1E1E1E),
          textColor: Color(0xFFFFD700),
          accentColor: Color(0xFFDAA520),
          borderColor: Color(0xFFFFD700),
          shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 20)],
        );
      case ThemePreset.sakura:
        return const ClockStyleData(
          name: "🌸 Cherry Sakura",
          bgColor: Color(0xFF2A1B24),
          cardColor: Color(0xFF3D2835),
          textColor: Color(0xFFFFB7B2),
          accentColor: Color(0xFFFFDAC1),
          borderColor: Color(0xFFFFB7B2),
          shadows: [Shadow(color: Color(0xFFFFB7B2), blurRadius: 15)],
        );
      case ThemePreset.matrix:
        return const ClockStyleData(
          name: "🦾 Neo Industrial Matrix",
          bgColor: Colors.black,
          cardColor: Color(0xFF001100),
          textColor: Color(0xFF00FF41),
          accentColor: Color(0xFF008F11),
          borderColor: Color(0xFF00FF41),
          shadows: [Shadow(color: Color(0xFF00FF41), blurRadius: 20)],
        );
      case ThemePreset.plasma:
        return const ClockStyleData(
          name: "⚡ Electrified Plasma",
          bgColor: Color(0xFF10002B),
          cardColor: Color(0xFF240046),
          textColor: Color(0xFF9D4EDD),
          accentColor: Color(0xFFE0AAFF),
          borderColor: Color(0xFF9D4EDD),
          shadows: [Shadow(color: Color(0xFF9D4EDD), blurRadius: 30)],
        );
      case ThemePreset.midnightBerry:
        return const ClockStyleData(
          name: "🫐 Midnight Berry",
          bgColor: Color(0xFF1A001E),
          cardColor: Color(0xFF2B0938),
          textColor: Color(0xFFF72585),
          accentColor: Color(0xFF7209B7),
          borderColor: Color(0xFFF72585),
          shadows: [Shadow(color: Color(0xFFF72585), blurRadius: 25)],
        );
      case ThemePreset.arcticFrost:
        return const ClockStyleData(
          name: "❄️ Arctic Frost Ice",
          bgColor: Color(0xFF101B2B),
          cardColor: Color(0xFF1D2D44),
          textColor: Color(0xFFE0FBFC),
          accentColor: Color(0xFF98C1D9),
          borderColor: Color(0xFFE0FBFC),
          shadows: [Shadow(color: Color(0xFFE0FBFC), blurRadius: 20)],
        );
      case ThemePreset.neoBrutalism:
        return const ClockStyleData(
          name: "📐 Neo Brutalism",
          bgColor: Color(0xFFF4F4F0),
          cardColor: Color(0xFFFFD000),
          textColor: Color(0xFF1A1A1A),
          accentColor: Color(0xFFFF0055),
          borderColor: Color(0xFF1A1A1A),
          shadows: [],
        );
      case ThemePreset.romanSlate:
        return const ClockStyleData(
          name: "🏛️ Classic Roman Slate",
          bgColor: Color(0xFF19232A),
          cardColor: Color(0xFF2F3E46),
          textColor: Color(0xFFCAD2C5),
          accentColor: Color(0xFF84A98C),
          borderColor: Color(0xFFCAD2C5),
          shadows: [],
        );
      case ThemePreset.campfire:
        return const ClockStyleData(
          name: "⛺ Campfire Twilight",
          bgColor: Color(0xFF1C1917),
          cardColor: Color(0xFF292524),
          textColor: Color(0xFFF97316),
          accentColor: Color(0xFFC2410C),
          borderColor: Color(0xFFF97316),
          shadows: [Shadow(color: Color(0xFFF97316), blurRadius: 20)],
        );
      case ThemePreset.saturnMinimal:
        return const ClockStyleData(
          name: "🪐 Saturn Rings Minimal",
          bgColor: Color(0xFF090D16),
          cardColor: Color(0xFF121B2D),
          textColor: Color(0xFFE2B961),
          accentColor: Color(0xFFF8FAFC),
          borderColor: Color(0xFFE2B961),
          shadows: [Shadow(color: Color(0xFFE2B961), blurRadius: 15)],
        );
      case ThemePreset.summerPop:
        return const ClockStyleData(
          name: "🍉 Summer Pop",
          bgColor: Color(0xFF2A1324),
          cardColor: Color(0xFF3F1D36),
          textColor: Color(0xFFFF6B6B),
          accentColor: Color(0xFFFFE66D),
          borderColor: Color(0xFFFF6B6B),
          shadows: [Shadow(color: Color(0xFFFF6B6B), blurRadius: 20)],
        );
      case ThemePreset.chakra:
        return const ClockStyleData(
          name: "🧘 Chakra Meditation",
          bgColor: Color(0xFF191228),
          cardColor: Color(0xFF2A1E40),
          textColor: Color(0xFFC8B6FF),
          accentColor: Color(0xFFE7C6FF),
          borderColor: Color(0xFFC8B6FF),
          shadows: [Shadow(color: Color(0xFFC8B6FF), blurRadius: 20)],
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

    // Date formatting (Khmer vs English)
    final khmerDay = _khmerDays[_now.weekday - 1];
    final khmerMonth = _khmerMonths[_now.month - 1];
    final khmerYear = _toKhmerDigits(_now.year.toString());
    final khmerDateStr = "$khmerDay, ទី${_toKhmerDigits(_now.day.toString())} ខែ$khmerMonth ឆ្នាំ$khmerYear";

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
              boxShadow: settings.themePreset == ThemePreset.neoBrutalism 
                  ? [const BoxShadow(color: Colors.black, offset: Offset(8, 8), blurRadius: 0)]
                  : [],
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
                  // Portrait Layout (Stacked Digits)
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

                // Date Display (Khmer Date / Standard Date)
                if (settings.showDate) ...[
                  const SizedBox(height: 16),
                  Text(
                    settings.useKhmerDigits ? khmerDateStr : "WED, JUL 30, 2026",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: style.textColor.withOpacity(0.8), letterSpacing: 1.1),
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
