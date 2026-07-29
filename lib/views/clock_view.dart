import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clock_settings.dart';

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

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ClockSettings>(context);
    final hours = settings.timeFormat == TimeFormat.h12 
        ? (_now.hour % 12 == 0 ? 12 : _now.hour % 12).toString().padLeft(2, '0')
        : _now.hour.toString().padLeft(2, '0');
    final minutes = _now.minute.toString().padLeft(2, '0');
    final seconds = _now.second.toString().padLeft(2, '0');
    final amPm = settings.timeFormat == TimeFormat.h12 ? (_now.hour >= 12 ? 'PM' : 'AM') : '';

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || settings.orientationMode == OrientationMode.vertical;

    return Scaffold(
      backgroundColor: settings.themePreset == ThemePreset.oled ? Colors.black : const Color(0xFF0F172A),
      body: Transform.translate(
        offset: Offset(_shiftX.toDouble(), _shiftY.toDouble()),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: settings.themePreset == ThemePreset.oled 
                  ? Colors.black 
                  : const Color(0xFF1E293B).withOpacity(settings.glassOpacity),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                          color: settings.themePreset == ThemePreset.cyberpunk ? const Color(0xFF00F3FF) : Colors.white,
                          shadows: settings.themePreset == ThemePreset.cyberpunk
                              ? [const Shadow(color: Color(0xFF00F3FF), blurRadius: 30)]
                              : [],
                        ),
                      ),
                      if (settings.showSeconds) ...[
                        const SizedBox(width: 16),
                        Text(
                          seconds,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: settings.themePreset == ThemePreset.cyberpunk ? const Color(0xFFFF0055) : const Color(0xFF38BDF8),
                          ),
                        ),
                      ],
                      if (amPm.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Text(
                          amPm,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70),
                        ),
                      ]
                    ],
                  ),
                ] else ...[
                  // Portrait Layout (Stacked Digits)
                  Text(
                    hours,
                    style: const TextStyle(fontSize: 130, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  Container(width: 80, height: 4, color: const Color(0xFF38BDF8), margin: const EdgeInsets.symmetric(vertical: 8)),
                  Text(
                    minutes,
                    style: const TextStyle(fontSize: 130, fontWeight: FontWeight.w900, color: Colors.white),
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
