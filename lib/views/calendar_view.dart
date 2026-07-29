import 'package:flutter/material.dart';
import '../services/khmer_culture_service.dart';
import '../services/font_service.dart';
import '../services/weather_service.dart';
import '../utils/khmer_string_utils.dart';

class CalendarView extends StatefulWidget {
  final Color textColor;
  final Color bgColor;
  final Color primaryColor;
  final bool useKhmerDigits;
  final String fontFamily;
  final WeatherInfo? weatherInfo;

  const CalendarView({
    super.key,
    required this.textColor,
    required this.bgColor,
    this.primaryColor = const Color(0xFFFF9500),
    required this.useKhmerDigits,
    required this.fontFamily,
    this.weatherInfo,
  });

  @override
  State<CalendarView> createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  late DateTime _focusedMonth;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(_today.year, _today.month, 1);
  }

  void previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  void jumpToToday() {
    setState(() {
      _focusedMonth = DateTime(_today.year, _today.month, 1);
    });
  }

  String _toKhmerDigits(String input) => KhmerStringUtils.toKhmerDigits(input);

  String _getMonthName(int month) =>
      KhmerStringUtils.getMonthName(month, useKhmerDigits: widget.useKhmerDigits);

  void _showDayDetails(DateTime date) {
    final isToday = date.year == _today.year && date.month == _today.month && date.day == _today.day;
    final isHolyDay = KhmerCultureService.isKhmerHolyDay(date);
    final holidayName = KhmerCultureService.getHolidayName(date, useKhmerDigits: widget.useKhmerDigits);
    final dateStr = KhmerCultureService.getKhmerLunarDayString(date, useKhmerDigits: widget.useKhmerDigits);
    final zodiacStr = KhmerCultureService.getKhmerZodiacAndEra(date.year, useKhmerDigits: widget.useKhmerDigits);
    final isKhmer = widget.useKhmerDigits;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withOpacity(0.12), width: 1.0),
          ),
          title: Text(
            isKhmer ? "📅 កាលបរិច្ឆេទ" : "📅 Date Details",
            style: FontService.getTextStyle(
              widget.fontFamily,
              TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isKhmer ? "ថ្ងៃ ${_toKhmerDigits(date.day.toString())} ខែ${_getMonthName(date.month)} ឆ្នាំ${_toKhmerDigits(date.year.toString())}" : "${_getMonthName(date.month)} ${date.day}, ${date.year}",
                style: FontService.getTextStyle(
                  widget.fontFamily,
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${isKhmer ? 'ថ្ងៃចន្ទគតិ ៖' : 'Lunar Phase:'} $dateStr",
                style: FontService.getTextStyle(
                  widget.fontFamily,
                  TextStyle(
                    fontSize: 16,
                    color: widget.textColor.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${isKhmer ? 'ឆ្នាំរាសី ៖' : 'Zodiac & Era:'} $zodiacStr",
                style: FontService.getTextStyle(
                  widget.fontFamily,
                  TextStyle(
                    fontSize: 16,
                    color: widget.textColor.withOpacity(0.85),
                  ),
                ),
              ),
              if (isHolyDay) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isKhmer ? "🌕 ថ្ងៃសីលចន្ទគតិខ្មែរ" : "🌕 Khmer Holy Day",
                    style: FontService.getTextStyle(
                      widget.fontFamily,
                      TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
              if (holidayName != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "🇰🇭 $holidayName",
                    style: FontService.getTextStyle(
                      widget.fontFamily,
                      TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                ),
              ],
              if (widget.weatherInfo != null && isToday) ...[
                const SizedBox(height: 14),
                Divider(color: widget.textColor.withOpacity(0.2)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(widget.weatherInfo!.conditionIcon, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      "${isKhmer ? _toKhmerDigits(widget.weatherInfo!.temperature.toStringAsFixed(0)) : widget.weatherInfo!.temperature.toStringAsFixed(0)}°C ${widget.weatherInfo!.getLocationName(useKhmerDigits: isKhmer)}",
                      style: FontService.getTextStyle(
                        widget.fontFamily,
                        TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: widget.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                isKhmer ? "បិទ" : "Close",
                style: FontService.getTextStyle(
                  widget.fontFamily,
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday;
    final startOffset = firstWeekday % 7;
    final totalCells = startOffset + daysInMonth;
    final rowCount = (totalCells / 7).ceil();
    final totalGridItems = rowCount * 7;
    final prevMonthDaysInMonth = DateTime(year, month, 0).day;
    final isKhmer = widget.useKhmerDigits;

    final monthTitleStr = isKhmer
        ? "ខែ${_getMonthName(month)} ឆ្នាំ${_toKhmerDigits(year.toString())}"
        : "${_getMonthName(month)} $year";

    final zodiacStr = KhmerCultureService.getKhmerZodiacAndEra(year, useKhmerDigits: isKhmer);

    final weekdaysHeader = isKhmer
        ? ['អាទិត្យ', 'ច័ន្ទ', 'អង្គារ', 'ពុធ', 'ព្រហស្បតិ៍', 'សុក្រ', 'សៅរ៍']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final monthlyHolidays = KhmerCultureService.getMonthlyHolidays(year, month, useKhmerDigits: isKhmer);
        final availableHeight = constraints.maxHeight - 200;
        final cellHeight = (availableHeight / rowCount) - 10;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Header Navigation Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: previousMonth,
                    icon: Icon(Icons.chevron_left_rounded, color: widget.textColor, size: 36),
                    tooltip: isKhmer ? 'ខែមុន' : 'Previous Month',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    monthTitleStr,
                    style: FontService.getTextStyle(
                      widget.fontFamily,
                      TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: nextMonth,
                    icon: Icon(Icons.chevron_right_rounded, color: widget.textColor, size: 36),
                    tooltip: isKhmer ? 'ខែបន្ទាប់' : 'Next Month',
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "•   $zodiacStr",
                    style: FontService.getTextStyle(
                      widget.fontFamily,
                      TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: widget.primaryColor.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),

              if (KhmerCultureService.getUpcomingHolidayCountdown(_today, useKhmerDigits: isKhmer) != null) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.primaryColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        KhmerCultureService.getUpcomingHolidayCountdown(_today, useKhmerDigits: isKhmer)!,
                        style: FontService.getTextStyle(
                          widget.fontFamily,
                          TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: widget.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 18),

              // Weekdays Header Row
              Row(
                children: weekdaysHeader.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final day = entry.value;
                  final isSunday = idx == 0;
                  final isSaturday = idx == 6;
                  final dayColor = isSunday
                      ? widget.primaryColor
                      : isSaturday
                          ? widget.primaryColor.withOpacity(0.85)
                          : widget.textColor.withOpacity(0.9);
                  return Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: FontService.getTextStyle(
                          widget.fontFamily,
                          TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: dayColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Main Calendar Grid View
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisExtent: cellHeight.clamp(72.0, 116.0),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: totalGridItems,
                  itemBuilder: (context, index) {
                    final bool isPrevMonth = index < startOffset;
                    final bool isNextMonth = index >= startOffset + daysInMonth;
                    final bool isCurrentMonth = !isPrevMonth && !isNextMonth;

                    final DateTime cellDate;
                    final int dayNum;

                    if (isPrevMonth) {
                      dayNum = prevMonthDaysInMonth - startOffset + index + 1;
                      cellDate = DateTime(year, month - 1, dayNum);
                    } else if (isNextMonth) {
                      dayNum = index - (startOffset + daysInMonth) + 1;
                      cellDate = DateTime(year, month + 1, dayNum);
                    } else {
                      dayNum = index - startOffset + 1;
                      cellDate = DateTime(year, month, dayNum);
                    }

                    final isToday = isCurrentMonth && cellDate.year == _today.year && cellDate.month == _today.month && cellDate.day == _today.day;
                    final isHolyDay = isCurrentMonth && KhmerCultureService.isKhmerHolyDay(cellDate);
                    final isNationalHoliday = isCurrentMonth && KhmerCultureService.getHolidayName(cellDate) != null;

                    final dayDisplay = isKhmer ? _toKhmerDigits(dayNum.toString()) : dayNum.toString();
                    final lunarDisplay = KhmerCultureService.getKhmerLunarDayString(cellDate, useKhmerDigits: isKhmer);
                    final cellOpacity = isCurrentMonth ? 1.0 : 0.22;

                    return _CalendarDayCellWidget(
                      cellDate: cellDate,
                      dayDisplay: dayDisplay,
                      lunarDisplay: lunarDisplay,
                      isToday: isToday,
                      isHolyDay: isHolyDay,
                      isNationalHoliday: isNationalHoliday,
                      cellOpacity: cellOpacity,
                      textColor: widget.textColor,
                      primaryColor: widget.primaryColor,
                      fontFamily: widget.fontFamily,
                      onTap: () => _showDayDetails(cellDate),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Bottom Legend Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isKhmer
                        ? "🌕 ថ្ងៃសីលចន្ទគតិ ៖ ៨កើត, ១៥កើត, ៨រោច, ១៥រោច"
                        : "🌕 Khmer Holy Days: 8th & 15th Waxing / Waning",
                    style: FontService.getTextStyle(
                      widget.fontFamily,
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ),
                  if (monthlyHolidays.isNotEmpty) ...[
                    Text(
                      "   •   ",
                      style: TextStyle(color: widget.textColor.withOpacity(0.4)),
                    ),
                    ...monthlyHolidays.map((h) {
                      final hDayNum = isKhmer ? _toKhmerDigits(h.date.day.toString()) : h.date.day.toString();
                      return Text(
                        isKhmer
                            ? "🇰🇭 ថ្ងៃទី$hDayNum ៖ ${h.getName(isKhmer)}"
                            : "🇰🇭 Day $hDayNum: ${h.getName(isKhmer)}",
                        style: FontService.getTextStyle(
                          widget.fontFamily,
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.textColor.withOpacity(0.9),
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarDayCellWidget extends StatefulWidget {
  final DateTime cellDate;
  final String dayDisplay;
  final String lunarDisplay;
  final bool isToday;
  final bool isHolyDay;
  final bool isNationalHoliday;
  final double cellOpacity;
  final Color textColor;
  final Color primaryColor;
  final String fontFamily;
  final VoidCallback onTap;

  const _CalendarDayCellWidget({
    required this.cellDate,
    required this.dayDisplay,
    required this.lunarDisplay,
    required this.isToday,
    required this.isHolyDay,
    required this.isNationalHoliday,
    required this.cellOpacity,
    required this.textColor,
    required this.primaryColor,
    required this.fontFamily,
    required this.onTap,
  });

  @override
  State<_CalendarDayCellWidget> createState() => _CalendarDayCellWidgetState();
}

class _CalendarDayCellWidgetState extends State<_CalendarDayCellWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeTextColor = _isHovered
        ? widget.primaryColor
        : (widget.isToday
            ? Colors.black
            : (widget.isHolyDay ? widget.primaryColor : widget.textColor.withOpacity(0.95)));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: widget.cellOpacity,
          child: AnimatedScale(
            scale: _isHovered ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: _isHovered ? widget.primaryColor.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.isToday ? widget.primaryColor : Colors.transparent,
                      shape: BoxShape.circle,
                      boxShadow: widget.isToday
                          ? [
                              BoxShadow(
                                color: widget.primaryColor.withOpacity(0.5),
                                blurRadius: 18,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      widget.dayDisplay,
                      style: FontService.getTextStyle(
                        widget.fontFamily,
                        TextStyle(
                          fontSize: 28,
                          fontWeight: (widget.isToday || _isHovered) ? FontWeight.w900 : FontWeight.bold,
                          color: activeTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isHolyDay) ...[
                        const Text('🌕 ', style: TextStyle(fontSize: 12)),
                      ],
                      Text(
                        widget.lunarDisplay,
                        style: FontService.getTextStyle(
                          widget.fontFamily,
                          TextStyle(
                            fontSize: 15,
                            fontWeight: (widget.isHolyDay || _isHovered) ? FontWeight.bold : FontWeight.w500,
                            color: _isHovered
                                ? Colors.white
                                : (widget.isToday
                                    ? widget.primaryColor
                                    : (widget.isHolyDay ? widget.primaryColor : widget.textColor.withOpacity(0.65))),
                          ),
                        ),
                      ),
                      if (widget.isNationalHoliday) ...[
                        const SizedBox(width: 4),
                        const Text('🇰🇭', style: TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
