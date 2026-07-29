import 'package:flutter/material.dart';
import '../models/clock_settings.dart';
import '../services/font_service.dart';

class DigitalClockDisplay extends StatelessWidget {
  final ClockSettings settings;
  final String hours;
  final String minutes;
  final String seconds;
  final String amPm;
  final Color primaryColor;
  final Color textColor;
  final bool isPortrait;
  final int currentSecond;

  const DigitalClockDisplay({
    super.key,
    required this.settings,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.amPm,
    required this.primaryColor,
    required this.textColor,
    required this.isPortrait,
    required this.currentSecond,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Dynamically scale font sizes to fit phone, tablet, and desktop screens seamlessly
    final double baseFontSize = isPortrait
        ? (screenWidth * 0.35).clamp(120.0, 260.0)
        : (screenHeight * 0.45).clamp(140.0, 360.0);
    final double clockFontSize = baseFontSize;

    final hourStyle = FontService.getTextStyle(
      settings.fontFamily,
      TextStyle(
        fontSize: clockFontSize,
        fontWeight: settings.useKhmerDigits ? FontWeight.w700 : FontWeight.w900,
        letterSpacing: settings.useKhmerDigits ? 1.5 : 0.0,
        color: textColor,
        height: 1.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );

    final minuteStyle = FontService.getTextStyle(
      settings.fontFamily,
      TextStyle(
        fontSize: clockFontSize,
        fontWeight: settings.useKhmerDigits ? FontWeight.w700 : FontWeight.w900,
        letterSpacing: settings.useKhmerDigits ? 1.5 : 0.0,
        color: primaryColor,
        height: 1.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );

    final secondsStyle = FontService.getTextStyle(
      settings.fontFamily,
      TextStyle(
        fontSize: isPortrait ? 48.0 : 64.0,
        fontWeight: settings.useKhmerDigits ? FontWeight.w700 : FontWeight.w800,
        color: primaryColor,
        height: 1.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );

    final amPmStyle = FontService.getTextStyle(
      settings.fontFamily,
      TextStyle(
        fontSize: isPortrait ? 36.0 : 48.0,
        fontWeight: FontWeight.bold,
        color: textColor.withOpacity(0.9),
        height: 1.0,
      ),
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(hours, style: hourStyle),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: (currentSecond % 2 != 0) ? 0.25 : 1.0,
            child: Text(':', style: minuteStyle),
          ),
          Text(minutes, style: minuteStyle),
          if (settings.showSeconds || amPm.isNotEmpty) ...[
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (settings.showSeconds) ...[
                    Text(seconds, style: secondsStyle),
                    if (amPm.isNotEmpty) const SizedBox(width: 10),
                  ],
                  if (amPm.isNotEmpty)
                    Text(amPm, style: amPmStyle),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
