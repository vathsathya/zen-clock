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
    "បាត់ដំបងដែនដីអស្ចារ្យ ជង្រុកស្រូវកម្ពុជា"
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
    const khmer = ['<ctrl42>', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'];
    String result = input;
    for (int i = 0; i < arabic.length; i++) {
      result = result.replaceAll(arabic[i], khmer[i]);
    }
    return result;
  }

  ClockStyleData _getStyleData(ThemePreset preset) {
    switch (preset) {
      // 1. Battambang Highlight Theme!
      case ThemePreset.battambang:
        return const ClockStyleData(
          name: "🍌 ខេត្តបាត់ដំបង (Battambang - លោកតាដំបងក្រញូង & ស្វាយ/ក្រូចមាស)",
          bgColor: Color(0xFF140C07),
          cardColor: Color(0xFF26190E),
          textColor: Color(0xFFFF7F00),
          accentColor: Color(0xFF00A86B),
          borderColor: Color(0xFFFF7F00),
          shadows: [Shadow(color: Color(0xFFFF7F00), blurRadius: 30)],
        );

      // 2. Siem Reap
      case ThemePreset.siemReap:
        return const ClockStyleData(
          name: "🏛️ ខេត្តសៀមរាប (Siem Reap - Angkor Wat Heritage)",
          bgColor: Color(0xFF0B132B),
          cardColor: Color(0xFF1C2541),
          textColor: Color(0xFFFFD700),
          accentColor: Color(0xFFE5C158),
          borderColor: Color(0xFFFFD700),
          shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 25)],
        );

      // 3. Phnom Penh Capital
      case ThemePreset.phnomPenh:
        return const ClockStyleData(
          name: "👑 រាជធានីភ្នំពេញ (Phnom Penh Capital - Royal Riverside)",
          bgColor: Color(0xFF1F002B),
          cardColor: Color(0xFF38004D),
          textColor: Color(0xFF00F3FF),
          accentColor: Color(0xFFFFD700),
          borderColor: Color(0xFF00F3FF),
          shadows: [Shadow(color: Color(0xFF00F3FF), blurRadius: 30)],
        );

      // 4. Kep
      case ThemePreset.kep:
        return const ClockStyleData(
          name: "🦀 ខេត្តកែប (Kep Province - Kep Crab & Blue Sea)",
          bgColor: Color(0xFF0A192F),
          cardColor: Color(0xFF172A45),
          textColor: Color(0xFF64FFDA),
          accentColor: Color(0xFFFF6B6B),
          borderColor: Color(0xFF64FFDA),
          shadows: [Shadow(color: Color(0xFF64FFDA), blurRadius: 20)],
        );

      // 5. Sihanoukville
      case ThemePreset.sihanoukville:
        return const ClockStyleData(
          name: "🏖️ ខេត្តព្រះសីហនុ (Preah Sihanouk - Golden Lions)",
          bgColor: Color(0xFF03045E),
          cardColor: Color(0xFF0077B6),
          textColor: Color(0xFF90E0EF),
          accentColor: Color(0xFFFFB703),
          borderColor: Color(0xFF90E0EF),
          shadows: [Shadow(color: Color(0xFF90E0EF), blurRadius: 20)],
        );

      // 6. Kampot
      case ThemePreset.kampot:
        return const ClockStyleData(
          name: "🌶️ ខេត្តកំពត (Kampot - Black Pepper & Bokor Mist)",
          bgColor: Color(0xFF12181F),
          cardColor: Color(0xFF212A35),
          textColor: Color(0xFFD4A373),
          accentColor: Color(0xFFFAEDCD),
          borderColor: Color(0xFFD4A373),
          shadows: [Shadow(color: Color(0xFFD4A373), blurRadius: 15)],
        );

      // 7. Mondulkiri
      case ThemePreset.mondulkiri:
        return const ClockStyleData(
          name: "🐘 ខេត្តមណ្ឌលគិរី (Mondulkiri - Pine Forest)",
          bgColor: Color(0xFF0F201B),
          cardColor: Color(0xFF1E352F),
          textColor: Color(0xFFA3E635),
          accentColor: Color(0xFF90E0EF),
          borderColor: Color(0xFFA3E635),
          shadows: [Shadow(color: Color(0xFFA3E635), blurRadius: 20)],
        );

      // 8. Ratanakiri
      case ThemePreset.ratanakiri:
        return const ClockStyleData(
          name: "💎 ខេត្តរតនគិរី (Ratanakiri - Red Earth & Gems)",
          bgColor: Color(0xFF3B1313),
          cardColor: Color(0xFF5C2323),
          textColor: Color(0xFF06B6D4),
          accentColor: Color(0xFFFCA5A5),
          borderColor: Color(0xFF06B6D4),
          shadows: [Shadow(color: Color(0xFF06B6D4), blurRadius: 20)],
        );

      // 9. Preah Vihear
      case ThemePreset.preahVihear:
        return const ClockStyleData(
          name: "🏔️ ខេត្តព្រះវិហារ (Preah Vihear - Mountain Cliff Temple)",
          bgColor: Color(0xFF131924),
          cardColor: Color(0xFF212C3D),
          textColor: Color(0xFFE0FBFC),
          accentColor: Color(0xFF3D5A80),
          borderColor: Color(0xFFE0FBFC),
          shadows: [Shadow(color: Color(0xFFE0FBFC), blurRadius: 20)],
        );

      // 10. Kampong Chhnang
      case ThemePreset.kampongChhnang:
        return const ClockStyleData(
          name: "🏺 ខេត្តកំពង់ឆ្នាំង (Kampong Chhnang - Khmer Pottery)",
          bgColor: Color(0xFF2A150D),
          cardColor: Color(0xFF452417),
          textColor: Color(0xFFC2410C),
          accentColor: Color(0xFF38BDF8),
          borderColor: Color(0xFFC2410C),
          shadows: [Shadow(color: Color(0xFFC2410C), blurRadius: 20)],
        );

      // 11. Kampong Speu
      case ThemePreset.kampongSpeu:
        return const ClockStyleData(
          name: "🌴 ខេត្តកំពង់ស្ពឺ (Kampong Speu - Palm Sugar Gold)",
          bgColor: Color(0xFF1C1300),
          cardColor: Color(0xFF332400),
          textColor: Color(0xFFD97706),
          accentColor: Color(0xFF15803D),
          borderColor: Color(0xFFD97706),
          shadows: [Shadow(color: Color(0xFFD97706), blurRadius: 20)],
        );

      // 12. Kampong Thom
      case ThemePreset.kampongThom:
        return const ClockStyleData(
          name: "🐟 ខេត្តកំពង់ធំ (Kampong Thom - Sambor Prei Kuk)",
          bgColor: Color(0xFF260D0D),
          cardColor: Color(0xFF421A1A),
          textColor: Color(0xFFF87171),
          accentColor: Color(0xFF9CA3AF),
          borderColor: Color(0xFFF87171),
          shadows: [],
        );

      // 13. Kampong Cham
      case ThemePreset.kampongCham:
        return const ClockStyleData(
          name: "🛥️ ខេត្តកំពង់ចាម (Kampong Cham - Bamboo Bridge)",
          bgColor: Color(0xFF0C1929),
          cardColor: Color(0xFF172B46),
          textColor: Color(0xFFEAB308),
          accentColor: Color(0xFF38BDF8),
          borderColor: Color(0xFFEAB308),
          shadows: [Shadow(color: Color(0xFFEAB308), blurRadius: 20)],
        );

      // 14. Kratie
      case ThemePreset.kratie:
        return const ClockStyleData(
          name: "🎋 ខេត្តក្រចេះ (Kratie - Irrawaddy Dolphin Sunset)",
          bgColor: Color(0xFF21140E),
          cardColor: Color(0xFF3D251A),
          textColor: Color(0xFFF97316),
          accentColor: Color(0xFF94A3B8),
          borderColor: Color(0xFFF97316),
          shadows: [Shadow(color: Color(0xFFF97316), blurRadius: 20)],
        );

      // 15. Stung Treng
      case ThemePreset.stungTreng:
        return const ClockStyleData(
          name: "🌿 ខេត្តស្ទឹងត្រែង (Stung Treng - Sekong River)",
          bgColor: Color(0xFF091F1C),
          cardColor: Color(0xFF133833),
          textColor: Color(0xFF047857),
          accentColor: Color(0xFF22D3EE),
          borderColor: Color(0xFF22D3EE),
          shadows: [Shadow(color: Color(0xFF22D3EE), blurRadius: 20)],
        );

      // 16. Prey Veng
      case ThemePreset.preyVeng:
        return const ClockStyleData(
          name: "🌾 ខេត្តព្រៃវែង (Prey Veng - Fertile Paddy Fields)",
          bgColor: Color(0xFF0D2214),
          cardColor: Color(0xFF193B24),
          textColor: Color(0xFFFACC15),
          accentColor: Color(0xFF4ADE80),
          borderColor: Color(0xFFFACC15),
          shadows: [Shadow(color: Color(0xFFFACC15), blurRadius: 20)],
        );

      // 17. Svay Rieng
      case ThemePreset.svayRieng:
        return const ClockStyleData(
          name: "🚣 ខេត្តស្វាយរៀង (Svay Rieng - Lotus Ponds)",
          bgColor: Color(0xFF24101B),
          cardColor: Color(0xFF3B1B2D),
          textColor: Color(0xFFEC4899),
          accentColor: Color(0xFF10B981),
          borderColor: Color(0xFFEC4899),
          shadows: [Shadow(color: Color(0xFFEC4899), blurRadius: 20)],
        );

      // 18. Takeo
      case ThemePreset.takeo:
        return const ClockStyleData(
          name: "🏺 ខេត្តតាកែវ (Takeo - Phnom Chisor Ancient Cradle)",
          bgColor: Color(0xFF1C140D),
          cardColor: Color(0xFF332317),
          textColor: Color(0xFFB45309),
          accentColor: Color(0xFFFBBF24),
          borderColor: Color(0xFFB45309),
          shadows: [],
        );

      // 19. Pursat
      case ThemePreset.pursat:
        return const ClockStyleData(
          name: "⛰️ ខេត្តពោធិ៍សាត់ (Pursat - Cardamom Mountains)",
          bgColor: Color(0xFF0A1F1B),
          cardColor: Color(0xFF173630),
          textColor: Color(0xFFF1F5F9),
          accentColor: Color(0xFF10B981),
          borderColor: Color(0xFFF1F5F9),
          shadows: [Shadow(color: Color(0xFFF1F5F9), blurRadius: 15)],
        );

      // 20. Banteay Meanchey
      case ThemePreset.banteayMeanchey:
        return const ClockStyleData(
          name: "🌾 ខេត្តបន្ទាយមានជ័យ (Banteay Meanchey)",
          bgColor: Color(0xFF1C1B14),
          cardColor: Color(0xFF333124),
          textColor: Color(0xFFEAB308),
          accentColor: Color(0xFF9CA3AF),
          borderColor: Color(0xFFEAB308),
          shadows: [Shadow(color: Color(0xFFEAB308), blurRadius: 20)],
        );

      // 21. Oddar Meanchey
      case ThemePreset.oddarMeanchey:
        return const ClockStyleData(
          name: "🍃 ខេត្តឧត្តរមានជ័យ (Oddar Meanchey - Dangrek Range)",
          bgColor: Color(0xFF0F1F17),
          cardColor: Color(0xFF1D382B),
          textColor: Color(0xFF67E8F9),
          accentColor: Color(0xFF4ADE80),
          borderColor: Color(0xFF67E8F9),
          shadows: [Shadow(color: Color(0xFF67E8F9), blurRadius: 20)],
        );

      // 22. Pailin
      case ThemePreset.pailin:
        return const ClockStyleData(
          name: "🌳 ខេត្តប៉ៃលិន (Pailin - Sapphire & Ruby Gems)",
          bgColor: Color(0xFF0C1426),
          cardColor: Color(0xFF182643),
          textColor: Color(0xFF3B82F6),
          accentColor: Color(0xFFEF4444),
          borderColor: Color(0xFF3B82F6),
          shadows: [Shadow(color: Color(0xFF3B82F6), blurRadius: 25)],
        );

      // 23. Koh Kong
      case ThemePreset.kohKong:
        return const ClockStyleData(
          name: "🌄 ខេត្តកោះកុង (Koh Kong - Mangrove & Estuary)",
          bgColor: Color(0xFF051D1A),
          cardColor: Color(0xFF0F3631),
          textColor: Color(0xFF22D3EE),
          accentColor: Color(0xFF34D399),
          borderColor: Color(0xFF22D3EE),
          shadows: [Shadow(color: Color(0xFF22D3EE), blurRadius: 20)],
        );

      // 24. Tboung Khmum
      case ThemePreset.tboungKhmum:
        return const ClockStyleData(
          name: "🌾 ខេត្តត្បូងឃ្មុំ (Tboung Khmum - Rubber Plantation)",
          bgColor: Color(0xFF0C1F17),
          cardColor: Color(0xFF17382B),
          textColor: Color(0xFF059669),
          accentColor: Color(0xFFF8FAFC),
          borderColor: Color(0xFF059669),
          shadows: [Shadow(color: Color(0xFF059669), blurRadius: 20)],
        );

      // 25. Kandal
      case ThemePreset.kandal:
        return const ClockStyleData(
          name: "🏛️ ខេត្តកណ្តាល (Kandal - Koh Dach Silk Island)",
          bgColor: Color(0xFF220D21),
          cardColor: Color(0xFF3D1A3B),
          textColor: Color(0xFFC026D3),
          accentColor: Color(0xFFF59E0B),
          borderColor: Color(0xFFC026D3),
          shadows: [Shadow(color: Color(0xFFC026D3), blurRadius: 25)],
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

    final khmerDay = _khmerDays[_now.weekday - 1];
    final khmerMonth = _khmerMonths[_now.month - 1];
    final khmerYear = _toKhmerDigits(_now.year.toString());
    final khmerDateStr = "$khmerDay, ទី${_toKhmerDigits(_now.day.toString())} ខែ$khmerMonth ឆ្នាំ$khmerYear";

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
                // Province Theme Name Badge
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
                  // Landscape Layout
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
