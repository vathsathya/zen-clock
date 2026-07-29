import 'package:flutter/material.dart';
import '../models/clock_settings.dart';
import '../services/khmer_culture_service.dart';
import '../services/font_service.dart';

class KhmerCultureCard extends StatefulWidget {
  final ClockSettings settings;
  final DateTime date;
  final Color primaryColor;
  final Color cardColor;

  const KhmerCultureCard({
    super.key,
    required this.settings,
    required this.date,
    required this.primaryColor,
    required this.cardColor,
  });

  @override
  State<KhmerCultureCard> createState() => _KhmerCultureCardState();
}

class _KhmerCultureCardState extends State<KhmerCultureCard> {
  int _quoteOffset = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isHolyDay = KhmerCultureService.isKhmerHolyDay(widget.date);
    final lunarDayStr = KhmerCultureService.getKhmerLunarDayString(widget.date, useKhmerDigits: widget.settings.useKhmerDigits);
    final lunarMonthStr = KhmerCultureService.getKhmerLunarMonth(widget.date, useKhmerDigits: widget.settings.useKhmerDigits);
    final zodiacStr = KhmerCultureService.getKhmerZodiacAndEra(widget.date.year, useKhmerDigits: widget.settings.useKhmerDigits);
    final quote = KhmerCultureService.getDailyDhammaQuote(widget.date.add(Duration(days: _quoteOffset)));
    final upcomingHoliday = KhmerCultureService.getUpcomingHolidayCountdown(widget.date, useKhmerDigits: widget.settings.useKhmerDigits);

    final lunarFontSize = (screenWidth * 0.022).clamp(16.0, 26.0);
    final zodiacFontSize = (screenWidth * 0.017).clamp(14.0, 20.0);
    final holyDayFontSize = (screenWidth * 0.016).clamp(14.0, 20.0);
    final proverbFontSize = (screenWidth * 0.016).clamp(14.0, 20.0);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Centered Header Row: Lunar Date • Zodiac • Holy Day Badge
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 6,
            children: [
              // Lunar Month & Day
              Text(
                "🌙 $lunarDayStr $lunarMonthStr",
                style: FontService.getTextStyle(
                  widget.settings.fontFamily,
                  TextStyle(
                    fontSize: lunarFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              Text(
                "•",
                style: TextStyle(fontSize: zodiacFontSize, color: Colors.white.withOpacity(0.4)),
              ),

              // Zodiac Animal & Era
              Text(
                zodiacStr,
                style: FontService.getTextStyle(
                  widget.settings.fontFamily,
                  TextStyle(
                    fontSize: zodiacFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),

              // Holy Day Badge (ថ្ងៃសីល)
              if (isHolyDay && widget.settings.showKhmerHolyDays) ...[
                Text(
                  "•",
                  style: TextStyle(fontSize: zodiacFontSize, color: Colors.white.withOpacity(0.4)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🌕', style: TextStyle(fontSize: holyDayFontSize)),
                      const SizedBox(width: 6),
                      Text(
                        widget.settings.useKhmerDigits ? "ថ្ងៃសីល" : "Holy Day",
                        style: FontService.getTextStyle(
                          widget.settings.fontFamily,
                          TextStyle(
                            fontSize: holyDayFontSize,
                            fontWeight: FontWeight.bold,
                            color: widget.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          if (upcomingHoliday != null || widget.settings.showProverb) ...[
            const SizedBox(height: 10),
            if (upcomingHoliday != null)
              Text(
                upcomingHoliday,
                style: FontService.getTextStyle(
                  widget.settings.fontFamily,
                  TextStyle(
                    fontSize: proverbFontSize,
                    fontWeight: FontWeight.w600,
                    color: widget.primaryColor,
                  ),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            else if (widget.settings.showProverb)
              InkWell(
                onTap: () {
                  setState(() {
                    _quoteOffset = (_quoteOffset + 1) % 365;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          "“${quote.khmer}” — ${quote.english}",
                          style: FontService.getTextStyle(
                            widget.settings.fontFamily,
                            TextStyle(
                              fontSize: proverbFontSize + 2,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.95),
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.refresh_rounded,
                        size: proverbFontSize,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    ),
    );
  }
}
