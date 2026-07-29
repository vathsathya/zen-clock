import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../models/clock_settings.dart';
import '../services/weather_service.dart';
import '../services/tray_service.dart';
import '../services/font_service.dart';
import '../utils/khmer_string_utils.dart';
import '../widgets/digital_clock_display.dart';
import '../widgets/khmer_culture_card.dart';
import '../widgets/quick_control_bar.dart';
import 'settings_view.dart';
import 'calendar_view.dart';
import 'focus_timer_view.dart';
import 'weather_forecast_dialog.dart';

class ClockStyleData {
  final Color bgColor;
  final Color textColor;
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;
  final Color secondaryTextColor;

  const ClockStyleData({
    required this.bgColor,
    required this.textColor,
    required this.primaryColor,
    required this.accentColor,
    required this.cardColor,
    required this.secondaryTextColor,
  });
}

class ClockView extends StatefulWidget {
  const ClockView({super.key});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> with TickerProviderStateMixin {
  late DateTime _now;
  Timer? _timer;
  Timer? _pixelShiftTimer;
  Timer? _hideControlsTimer;
  Timer? _weatherTimer;
  late AnimationController _wallpaperAnimController;

  bool _isFullScreen = true;
  bool _showOverlayControls = true;
  bool _isFocusTimerMode = false;
  int _shiftX = 0;
  int _shiftY = 0;

  WeatherInfo? _weatherInfo;
  ThemePreset? _lastFetchedTheme;

  final GlobalKey<CalendarViewState> _calendarKey = GlobalKey<CalendarViewState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _wallpaperAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final newNow = DateTime.now();
        final settings = Provider.of<ClockSettings>(context, listen: false);
        if (!settings.showSeconds && newNow.minute == _now.minute && newNow.hour == _now.hour) {
          return;
        }
        setState(() {
          _now = newNow;
        });
      }
    });

    _weatherTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      final settings = Provider.of<ClockSettings>(context, listen: false);
      _loadWeatherForTheme(settings.themePreset);
    });

    _pixelShiftTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      final settings = Provider.of<ClockSettings>(context, listen: false);
      if (settings.oledPixelShift && mounted) {
        setState(() {
          _shiftX = (_shiftX + 2) % 6 - 3;
          _shiftY = (_shiftY + 1) % 6 - 3;
        });
      }
    });

    TrayService.instance.onOpenSettings = () {
      if (mounted) {
        final settings = Provider.of<ClockSettings>(context, listen: false);
        final style = _getStyleData(settings.themePreset);
        SettingsDialog.show(context, style.textColor, style.bgColor).then((_) {
          if (mounted) _focusNode.requestFocus();
        });
      }
    };

    TrayService.instance.onChangeDisplayMode = (modeStr) {
      if (mounted) {
        final settings = Provider.of<ClockSettings>(context, listen: false);
        if (modeStr == 'clock') {
          settings.setDisplayMode(DisplayMode.clock);
          setState(() => _isFocusTimerMode = false);
        } else if (modeStr == 'calendar') {
          settings.setDisplayMode(DisplayMode.calendar);
        }
      }
    };

    TrayService.instance.onToggleLanguage = (useKhmer) {
      if (mounted) {
        final settings = Provider.of<ClockSettings>(context, listen: false);
        settings.toggleKhmerDigits(useKhmer);
      }
    };

    _startHideControlsTimer();
  }

  void _loadWeatherForTheme(ThemePreset theme) async {
    _lastFetchedTheme = theme;
    final info = await WeatherService.fetchLiveWeatherForTheme(theme);
    if (mounted) {
      setState(() {
        _weatherInfo = info;
      });
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showOverlayControls = false;
        });
      }
    });
  }

  void _onHover(PointerEvent event) {
    if (!_showOverlayControls) {
      setState(() {
        _showOverlayControls = true;
      });
    }
    _startHideControlsTimer();
  }

  void _toggleFullScreen() async {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    await windowManager.setFullScreen(_isFullScreen);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pixelShiftTimer?.cancel();
    _hideControlsTimer?.cancel();
    _weatherTimer?.cancel();
    _wallpaperAnimController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final settings = Provider.of<ClockSettings>(context, listen: false);
      final style = _getStyleData(settings.themePreset);

      if (event.logicalKey == LogicalKeyboardKey.keyS) {
        SettingsDialog.show(context, style.textColor, style.bgColor).then((_) {
          if (mounted) _focusNode.requestFocus();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
        setState(() => _isFocusTimerMode = false);
        if (settings.displayMode == DisplayMode.clock) {
          settings.setDisplayMode(DisplayMode.calendar);
        } else {
          settings.setDisplayMode(DisplayMode.clock);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.keyT) {
        if (settings.displayMode == DisplayMode.calendar) {
          _calendarKey.currentState?.jumpToToday();
        } else {
          setState(() {
            _isFocusTimerMode = !_isFocusTimerMode;
          });
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (settings.displayMode == DisplayMode.calendar) {
          _calendarKey.currentState?.previousMonth();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (settings.displayMode == DisplayMode.calendar) {
          _calendarKey.currentState?.nextMonth();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
        int nextIndex = (settings.themePreset.index + 1) % ThemePreset.values.length;
        settings.setTheme(ThemePreset.values[nextIndex]);
      } else if (event.logicalKey == LogicalKeyboardKey.digit1) {
        settings.toggleKhmerDigits(!settings.useKhmerDigits);
      } else if (event.logicalKey == LogicalKeyboardKey.keyF || event.logicalKey == LogicalKeyboardKey.f11) {
        _toggleFullScreen();
      } else if (event.logicalKey == LogicalKeyboardKey.escape && _isFullScreen) {
        _toggleFullScreen();
      }
    }
  }

  ClockStyleData _getStyleData(ThemePreset theme) {
    final Map<ThemePreset, Color> provinceColors = {
      ThemePreset.battambang: const Color(0xFFFF9500),
      ThemePreset.siemReap: const Color(0xFFFFC107),
      ThemePreset.phnomPenh: const Color(0xFFFF3B30),
      ThemePreset.sihanoukville: const Color(0xFF00C7BE),
      ThemePreset.kampot: const Color(0xFF30D158),
      ThemePreset.kep: const Color(0xFF32ADE6),
      ThemePreset.takeo: const Color(0xFFAF52DE),
      ThemePreset.kampongCham: const Color(0xFFFF9500),
      ThemePreset.kandal: const Color(0xFFFF2D55),
      ThemePreset.pursat: const Color(0xFF34C759),
      ThemePreset.kratie: const Color(0xFF5856D6),
      ThemePreset.stungTreng: const Color(0xFF007AFF),
      ThemePreset.ratanakiri: const Color(0xFFFF9500),
      ThemePreset.mondulkiri: const Color(0xFF30D158),
      ThemePreset.preahVihear: const Color(0xFFFFCC00),
      ThemePreset.oddarMeanchey: const Color(0xFF5AC8FA),
      ThemePreset.banteayMeanchey: const Color(0xFFFF9500),
      ThemePreset.pailin: const Color(0xFF00C7BE),
      ThemePreset.kampongChhnang: const Color(0xFFFF9500),
      ThemePreset.kampongSpeu: const Color(0xFF34C759),
      ThemePreset.kampongThom: const Color(0xFFFFCC00),
      ThemePreset.preyVeng: const Color(0xFFFF3B30),
      ThemePreset.svayRieng: const Color(0xFFFF2D55),
      ThemePreset.kohKong: const Color(0xFF00C7BE),
      ThemePreset.tboungKhmum: const Color(0xFF30D158),
    };

    final pColor = provinceColors[theme] ?? const Color(0xFFFF9500);

    return ClockStyleData(
      bgColor: const Color(0xFF000000),
      textColor: const Color(0xFFFFFFFF),
      primaryColor: pColor,
      accentColor: pColor,
      cardColor: const Color(0xFF121212),
      secondaryTextColor: const Color(0xB3FFFFFF),
    );
  }

  Widget _buildHorizontalWeatherStrip(ClockSettings settings, ClockStyleData style) {
    if (!settings.showWeather || _weatherInfo == null || _weatherInfo!.dailyItems.isEmpty) {
      return const SizedBox(height: 24);
    }

    final isKhmer = settings.useKhmerDigits;
    final locName = _weatherInfo!.getLocationName(useKhmerDigits: isKhmer);

    int todayIndex = _weatherInfo!.dailyItems.indexWhere((item) => item.isToday);
    if (todayIndex == -1) todayIndex = 0;

    int endIndex = min(todayIndex + 5, _weatherInfo!.dailyItems.length);
    final displayItems = _weatherInfo!.dailyItems.sublist(todayIndex, endIndex);

    final screenWidth = MediaQuery.of(context).size.width;
    final locFontSize = (screenWidth * 0.016).clamp(16.0, 22.0);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locName,
            style: TextStyle(
              fontSize: locFontSize,
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: displayItems.map((item) {
              return WeatherDayItemWidget(
                item: item,
                isKhmer: isKhmer,
                settings: settings,
                style: style,
                onTap: () {
                  if (_weatherInfo != null) {
                    WeatherForecastDialog.show(context, _weatherInfo!, style.textColor, style.bgColor);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ClockSettings>(context);
    final style = _getStyleData(settings.themePreset);

    if (_lastFetchedTheme != settings.themePreset) {
      _loadWeatherForTheme(settings.themePreset);
    }

    String rawHours = settings.timeFormat == TimeFormat.h12
        ? (_now.hour % 12 == 0 ? 12 : _now.hour % 12).toString().padLeft(2, '0')
        : _now.hour.toString().padLeft(2, '0');
    String rawMinutes = _now.minute.toString().padLeft(2, '0');
    String rawSeconds = _now.second.toString().padLeft(2, '0');
    String amPm = settings.timeFormat == TimeFormat.h12 ? (_now.hour >= 12 ? 'PM' : 'AM') : '';

    final hours = settings.useKhmerDigits ? KhmerStringUtils.toKhmerDigits(rawHours) : rawHours;
    final minutes = settings.useKhmerDigits ? KhmerStringUtils.toKhmerDigits(rawMinutes) : rawMinutes;
    final seconds = settings.useKhmerDigits ? KhmerStringUtils.toKhmerDigits(rawSeconds) : rawSeconds;

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || settings.orientationMode == OrientationMode.vertical;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: style.bgColor,
        body: MouseRegion(
          onHover: _onHover,
          child: Stack(
            children: [
              // Animated Background & Window Dragging Area
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    windowManager.startDragging();
                  },
                  onDoubleTap: () {
                    _toggleFullScreen();
                  },
                  child: AnimatedBuilder(
                    animation: _wallpaperAnimController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ZenBackgroundPainter(
                          themeColor: style.primaryColor,
                          wallpaperMode: settings.liveWallpaperMode,
                          animProgress: _wallpaperAnimController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Main Application Content
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 2400),
                  child: Transform.translate(
                    offset: Offset(_shiftX.toDouble(), _shiftY.toDouble()),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                        child: settings.displayMode == DisplayMode.calendar
                            ? CalendarView(
                                key: _calendarKey,
                                textColor: style.textColor,
                                bgColor: style.bgColor,
                                primaryColor: style.primaryColor,
                                useKhmerDigits: settings.useKhmerDigits,
                                fontFamily: settings.fontFamily,
                                weatherInfo: _weatherInfo,
                              )
                            : _isFocusTimerMode
                                ? FocusTimerView(
                                    settings: settings,
                                    primaryColor: style.primaryColor,
                                    textColor: style.textColor,
                                  )
                                : Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const Spacer(flex: 1),

                                       // Digital Clock Display (Perfectly Centered)
                                       DigitalClockDisplay(
                                         settings: settings,
                                         hours: hours,
                                         minutes: minutes,
                                         seconds: seconds,
                                         amPm: amPm,
                                         primaryColor: style.primaryColor,
                                         textColor: style.textColor,
                                         isPortrait: isPortrait,
                                         currentSecond: _now.second,
                                       ),

                                       const SizedBox(height: 12),

                                       // Weather Strip Directly Below Digital Clock
                                       _buildHorizontalWeatherStrip(settings, style),

                                       const Spacer(flex: 1),

                                       // Khmer Culture Info Card
                                       KhmerCultureCard(
                                         settings: settings,
                                         date: _now,
                                         primaryColor: style.primaryColor,
                                         cardColor: style.cardColor,
                                       ),
                                       const SizedBox(height: 32),
                                     ],
                                   ),
                      ),
                    ),
                  ),
                ),
              ),

              // Quick Control Bar (Floating Navigation Dock - Top Right Corner)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                top: _showOverlayControls ? 20 : -90,
                right: 20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showOverlayControls ? 1.0 : 0.0,
                  child: QuickControlBar(
                      settings: settings,
                      primaryColor: style.primaryColor,
                      isFocusTimerActive: _isFocusTimerMode,
                      onToggleDisplayMode: () {
                        setState(() => _isFocusTimerMode = false);
                        if (settings.displayMode == DisplayMode.clock) {
                          settings.setDisplayMode(DisplayMode.calendar);
                        } else {
                          settings.setDisplayMode(DisplayMode.clock);
                        }
                      },
                      onToggleFocusTimer: () {
                        setState(() {
                          _isFocusTimerMode = !_isFocusTimerMode;
                        });
                      },
                      onNextTheme: () {
                        int nextIndex = (settings.themePreset.index + 1) % ThemePreset.values.length;
                        settings.setTheme(ThemePreset.values[nextIndex]);
                      },
                      onToggleDigits: () {
                        settings.toggleKhmerDigits(!settings.useKhmerDigits);
                      },
                      onOpenSettings: () {
                        SettingsDialog.show(context, style.textColor, style.bgColor);
                      },
                      onToggleFullscreen: _toggleFullScreen,
                      onJumpToToday: () {
                        _calendarKey.currentState?.jumpToToday();
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ZenBackgroundPainter extends CustomPainter {
  final Color themeColor;
  final LiveWallpaperMode wallpaperMode;
  final double animProgress;

  ZenBackgroundPainter({
    required this.themeColor,
    required this.wallpaperMode,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (wallpaperMode == LiveWallpaperMode.off) {
      _drawSilhouettes(canvas, size);
      return;
    }

    if (wallpaperMode == LiveWallpaperMode.auraPulse) {
      final pulseFactor = 0.08 + sin(animProgress * 2 * pi) * 0.035;
      final centerAuraPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            themeColor.withOpacity(pulseFactor),
            themeColor.withOpacity(pulseFactor * 0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width * 0.48,
        ));
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), centerAuraPaint);
    } else if (wallpaperMode == LiveWallpaperMode.cosmicStars) {
      final starPaint = Paint()..style = PaintingStyle.fill;
      for (int i = 0; i < 30; i++) {
        final seed = i * 137.5;
        final x = (sin(seed) * 0.5 + 0.5) * size.width;
        final rawY = (cos(seed) * 0.5 + 0.5) * size.height - (animProgress * 60) % size.height;
        final y = rawY < 0 ? rawY + size.height : rawY;
        final starOpacity = (sin(animProgress * 2 * pi + seed) * 0.35 + 0.45).clamp(0.1, 0.85);

        starPaint.color = themeColor.withOpacity(starOpacity);
        canvas.drawCircle(Offset(x, y), (i % 3 == 0) ? 2.2 : 1.4, starPaint);
      }
    } else if (wallpaperMode == LiveWallpaperMode.gentleRain) {
      final rainPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < 24; i++) {
        final seed = i * 211.3;
        final x = (sin(seed) * 0.5 + 0.5) * size.width;
        final speed = 120.0 + (i % 5) * 40.0;
        final y = (animProgress * speed + seed * 10) % (size.height + 40) - 20;
        final length = 14.0 + (i % 4) * 8.0;

        rainPaint.color = themeColor.withOpacity((0.15 + (i % 3) * 0.1).clamp(0.08, 0.35));
        rainPaint.strokeWidth = (i % 2 == 0) ? 1.5 : 1.0;
        canvas.drawLine(Offset(x, y), Offset(x - 2, y + length), rainPaint);
      }
    }

    _drawSilhouettes(canvas, size);
  }

  void _drawSilhouettes(Canvas canvas, Size size) {
    // 1. Angkor Wat Silhouette (Bottom Left)
    final angkorPaint = Paint()
      ..color = themeColor.withOpacity(0.045)
      ..style = PaintingStyle.fill;

    final path = Path();
    double startX = 20;
    double baseY = size.height;

    path.moveTo(0, baseY);
    path.lineTo(260, baseY);
    path.lineTo(260, baseY - 24);
    path.lineTo(startX, baseY - 24);

    path.lineTo(startX + 30, baseY - 65);
    path.lineTo(startX + 40, baseY - 120);
    path.lineTo(startX + 50, baseY - 65);
    path.lineTo(startX + 85, baseY - 90);
    path.lineTo(startX + 95, baseY - 165);
    path.lineTo(startX + 105, baseY - 90);
    path.lineTo(startX + 140, baseY - 65);
    path.lineTo(startX + 150, baseY - 120);
    path.lineTo(startX + 160, baseY - 65);
    path.lineTo(startX + 195, baseY - 24);
    path.lineTo(0, baseY - 24);
    path.close();

    canvas.drawPath(path, angkorPaint);

    // 2. Seated Buddha Silhouette (Bottom Right)
    final buddhaCenter = Offset(size.width - 120, size.height - 100);

    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [themeColor.withOpacity(0.14), Colors.transparent],
      ).createShader(Rect.fromCircle(center: buddhaCenter, radius: 150));

    canvas.drawCircle(buddhaCenter, 150, auraPaint);

    final buddhaPaint = Paint()
      ..color = themeColor.withOpacity(0.075)
      ..style = PaintingStyle.fill;

    final bPath = Path();
    bPath.addOval(Rect.fromCircle(center: Offset(buddhaCenter.dx, buddhaCenter.dy - 35), radius: 15));
    bPath.moveTo(buddhaCenter.dx - 30, buddhaCenter.dy + 32);
    bPath.quadraticBezierTo(buddhaCenter.dx - 24, buddhaCenter.dy - 10, buddhaCenter.dx - 14, buddhaCenter.dy - 18);
    bPath.quadraticBezierTo(buddhaCenter.dx, buddhaCenter.dy - 24, buddhaCenter.dx + 14, buddhaCenter.dy - 18);
    bPath.quadraticBezierTo(buddhaCenter.dx + 24, buddhaCenter.dy - 10, buddhaCenter.dx + 30, buddhaCenter.dy + 32);
    bPath.quadraticBezierTo(buddhaCenter.dx, buddhaCenter.dy + 40, buddhaCenter.dx - 30, buddhaCenter.dy + 32);
    bPath.close();

    canvas.drawPath(bPath, buddhaPaint);
  }

  @override
  bool shouldRepaint(covariant ZenBackgroundPainter oldDelegate) =>
      oldDelegate.themeColor != themeColor ||
      oldDelegate.wallpaperMode != wallpaperMode ||
      oldDelegate.animProgress != animProgress;
}

class WeatherDayItemWidget extends StatefulWidget {
  final WeatherDailyItem item;
  final bool isKhmer;
  final ClockSettings settings;
  final ClockStyleData style;
  final VoidCallback onTap;

  const WeatherDayItemWidget({
    super.key,
    required this.item,
    required this.isKhmer,
    required this.settings,
    required this.style,
    required this.onTap,
  });

  @override
  State<WeatherDayItemWidget> createState() => _WeatherDayItemWidgetState();
}

class _WeatherDayItemWidgetState extends State<WeatherDayItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dayLabel = widget.item.getDayLabel(useKhmerDigits: widget.isKhmer);
    final maxTempStr = widget.isKhmer
        ? KhmerStringUtils.toKhmerDigits(widget.item.tempMax.toStringAsFixed(0))
        : widget.item.tempMax.toStringAsFixed(0);
    final minTempStr = widget.isKhmer
        ? KhmerStringUtils.toKhmerDigits(widget.item.tempMin.toStringAsFixed(0))
        : widget.item.tempMin.toStringAsFixed(0);

    final isToday = widget.item.isToday;
    final activeColor = _isHovered ? widget.style.primaryColor : (isToday ? widget.style.primaryColor : Colors.white.withOpacity(0.85));

    final dayFontSize = (screenWidth * 0.020).clamp(18.0, 26.0);
    final iconFontSize = (screenWidth * 0.035).clamp(32.0, 46.0);
    final tempFontSize = (screenWidth * 0.016).clamp(16.0, 22.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dayLabel,
                style: FontService.getTextStyle(
                  widget.settings.fontFamily,
                  TextStyle(
                    fontSize: dayFontSize,
                    fontWeight: (isToday || _isHovered) ? FontWeight.bold : FontWeight.w600,
                    color: activeColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedScale(
                scale: _isHovered ? 1.18 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Text(
                  widget.item.conditionIcon,
                  style: TextStyle(fontSize: iconFontSize),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$maxTempStr° / $minTempStr°",
                style: TextStyle(
                  fontSize: tempFontSize,
                  fontWeight: (isToday || _isHovered) ? FontWeight.bold : FontWeight.w600,
                  color: _isHovered ? Colors.white : (isToday ? Colors.white : Colors.white.withOpacity(0.75)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
