import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../models/clock_settings.dart';
import '../services/weather_service.dart';
import '../services/tray_service.dart';
import '../services/font_service.dart';
import '../services/zen_audio_service.dart';
import '../utils/khmer_string_utils.dart';
import '../widgets/digital_clock_display.dart';
import '../widgets/khmer_culture_card.dart';
import '../widgets/quick_control_bar.dart';
import '../widgets/weather_animation_painter.dart';
import '../widgets/video_background_widget.dart';
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
    ZenAudioService.instance.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final settings = Provider.of<ClockSettings>(context, listen: false);
        _loadWeatherForTheme(settings.themePreset);
      }
    });

    _wallpaperAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
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

  void _toggleOverlayControls() {
    setState(() {
      _showOverlayControls = !_showOverlayControls;
    });
    if (_showOverlayControls) {
      _startHideControlsTimer();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _toggleFullScreen() async {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      try {
        await windowManager.setFullScreen(_isFullScreen);
      } catch (_) {}
    } else {
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pixelShiftTimer?.cancel();
    _hideControlsTimer?.cancel();
    _weatherTimer?.cancel();
    _wallpaperAnimController.dispose();
    _focusNode.dispose();
    TrayService.instance.onOpenSettings = null;
    TrayService.instance.onChangeDisplayMode = null;
    TrayService.instance.onToggleLanguage = null;
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
    if (!settings.showWeather) {
      return const SizedBox(height: 24);
    }

    final info = _weatherInfo ?? WeatherService.getFallbackWeather(settings.themePreset);
    if (info.dailyItems.isEmpty) {
      return const SizedBox(height: 24);
    }

    final isKhmer = settings.useKhmerDigits;
    final locName = info.getLocationName(useKhmerDigits: isKhmer);

    int todayIndex = info.dailyItems.indexWhere((item) => item.isToday);
    if (todayIndex == -1) todayIndex = 0;

    int endIndex = min(todayIndex + 5, info.dailyItems.length);
    final displayItems = info.dailyItems.sublist(todayIndex, endIndex);

    final screenWidth = MediaQuery.of(context).size.width;
    final locFontSize = (screenWidth * 0.016).clamp(16.0, 22.0);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locName,
              style: FontService.getTextStyle(
                settings.fontFamily,
                TextStyle(
                  fontSize: locFontSize,
                  color: style.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
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
                  onTap: () {
                    _toggleOverlayControls();
                  },
                  onPanStart: (details) {
                    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
                      try {
                        windowManager.startDragging();
                      } catch (_) {}
                    }
                  },
                  onDoubleTap: () {
                    _toggleFullScreen();
                  },
                  child: AnimatedBuilder(
                    animation: _wallpaperAnimController,
                    builder: (context, child) {
                      if (settings.liveWallpaperMode == LiveWallpaperMode.videoThunderstorm ||
                          settings.liveWallpaperMode == LiveWallpaperMode.thunderstorm ||
                          settings.liveWallpaperMode == LiveWallpaperMode.gentleRain) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            const Positioned.fill(
                              child: VideoBackgroundWidget(
                                fallbackImagePath: 'assets/images/angkor_night.png',
                              ),
                            ),
                            Positioned.fill(
                              child: CustomPaint(
                                painter: WeatherAnimationPainter(
                                  weatherInfo: _weatherInfo,
                                  currentTime: _now,
                                  themeColor: style.primaryColor,
                                  animProgress: _wallpaperAnimController.value,
                                  wallpaperMode: settings.liveWallpaperMode,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      if (settings.liveWallpaperMode == LiveWallpaperMode.customImage ||
                          settings.liveWallpaperMode == LiveWallpaperMode.provinceTheme) {
                        final imagePath = settings.liveWallpaperMode == LiveWallpaperMode.customImage
                            ? settings.customImagePath
                            : ClockSettings.getProvinceWallpaperPath(settings.themePreset);

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) {
                                return Image.asset('assets/images/angkor_night.png', fit: BoxFit.cover);
                              },
                            ),
                            // Soft Dark Overlay for Maximum High Contrast Digits Readability
                            Container(
                              color: Colors.black.withValues(alpha: 0.55),
                            ),
                          ],
                        );
                      }
                      if (settings.liveWallpaperMode == LiveWallpaperMode.off) {
                        return CustomPaint(
                          painter: ZenBackgroundPainter(
                            themeColor: style.primaryColor,
                            wallpaperMode: settings.liveWallpaperMode,
                            animProgress: _wallpaperAnimController.value,
                          ),
                        );
                      }
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          const VideoBackgroundWidget(
                            fallbackImagePath: 'assets/images/angkor_night.png',
                          ),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: WeatherAnimationPainter(
                                weatherInfo: _weatherInfo,
                                currentTime: _now,
                                themeColor: style.primaryColor,
                                animProgress: _wallpaperAnimController.value,
                                wallpaperMode: settings.liveWallpaperMode,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: ZenBackgroundPainter(
                                themeColor: style.primaryColor,
                                wallpaperMode: settings.liveWallpaperMode,
                                animProgress: _wallpaperAnimController.value,
                              ),
                            ),
                          ),
                        ],
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
                                : LayoutBuilder(
                                    builder: (context, constraints) {
                                      final verticalGap = (constraints.maxHeight * 0.02).clamp(4.0, 16.0);
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Spacer(flex: 3),

                                          // Digital Clock Display (Perfect Dead Center Alignment)
                                          Center(
                                            child: DigitalClockDisplay(
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
                                          ),

                                          SizedBox(height: verticalGap),

                                          // Weather Strip Directly Below Digital Clock
                                          _buildHorizontalWeatherStrip(settings, style),

                                          const Spacer(flex: 2),

                                          // Khmer Culture Info Card
                                          KhmerCultureCard(
                                            settings: settings,
                                            date: _now,
                                            primaryColor: style.primaryColor,
                                            cardColor: style.cardColor,
                                          ),

                                          SizedBox(height: verticalGap),
                                        ],
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ),
                ),
              ),

              // Top-Most Weather & Lightning Overlay Painter (On Top of Clock Digits & UI Text)
              if (settings.liveWallpaperMode != LiveWallpaperMode.off &&
                  settings.liveWallpaperMode != LiveWallpaperMode.videoThunderstorm)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _wallpaperAnimController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: WeatherAnimationPainter(
                            weatherInfo: _weatherInfo,
                            currentTime: _now,
                            themeColor: style.primaryColor,
                            animProgress: _wallpaperAnimController.value,
                            wallpaperMode: settings.liveWallpaperMode,
                            isOverlay: true,
                          ),
                        );
                      },
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
                      onExitApp: () {
                        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
                          try {
                            windowManager.close();
                          } catch (_) {
                            exit(0);
                          }
                        } else {
                          SystemNavigator.pop();
                        }
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
    // 1. Ultra Dark Deep Canvas Base
    final deepDarkBase = Paint()..color = const Color(0xFF03060D);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), deepDarkBase);

    // 2. Fullscreen Soft-Blurred Khmer Identity Background (ប្រាសាទអង្គរវត្តកំពូល៥ ពេញអេក្រង់)
    _drawKhmerIdentityFullscreenBackground(canvas, size);

    if (wallpaperMode == LiveWallpaperMode.auraPulse) {
      final pulseFactor = 0.08 + sin(animProgress * 2 * pi) * 0.035;
      final centerAuraPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            themeColor.withValues(alpha: pulseFactor),
            themeColor.withValues(alpha: pulseFactor * 0.3),
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

        starPaint.color = themeColor.withValues(alpha: starOpacity * 0.6);
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

        rainPaint.color = themeColor.withValues(alpha: (0.12 + (i % 3) * 0.08).clamp(0.06, 0.25));
        rainPaint.strokeWidth = (i % 2 == 0) ? 1.5 : 1.0;
        canvas.drawLine(Offset(x, y), Offset(x - 2, y + length), rainPaint);
      }
    }

    // 3. Focal Dark Vignette Radial Gradient (Focuses 100% on central clock digits)
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.85,
        colors: [
          Colors.transparent,
          const Color(0xBF000000),
          const Color(0xF2000000),
        ],
        stops: const [0.35, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignettePaint);
  }

  /// Draws a majestic, soft-blurred silhouetted Angkor Wat 5 Towers & Khmer motif spanning the fullscreen background
  void _drawKhmerIdentityFullscreenBackground(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final baseY = size.height * 0.90;
    final scale = (size.width / 1200.0).clamp(0.7, 2.2);

    // Soft Blurred Silhouette Paint (Theme Tinted)
    final silhouettePaint = Paint()
      ..color = themeColor.withValues(alpha: 0.09)
      ..style = PaintingStyle.fill;

    final glowBorderPaint = Paint()
      ..color = themeColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale;

    final path = Path();

    // Base Gallery Terrace
    path.moveTo(centerX - 480 * scale, baseY);
    path.lineTo(centerX + 480 * scale, baseY);
    path.lineTo(centerX + 480 * scale, baseY - 35 * scale);
    path.lineTo(centerX - 480 * scale, baseY - 35 * scale);
    path.close();

    // Second Terrace
    path.moveTo(centerX - 380 * scale, baseY - 35 * scale);
    path.lineTo(centerX + 380 * scale, baseY - 35 * scale);
    path.lineTo(centerX + 380 * scale, baseY - 80 * scale);
    path.lineTo(centerX - 380 * scale, baseY - 80 * scale);
    path.close();

    // Central & Side 5 Spire Towers (ប្រាសាទអង្គរវត្តកំពូល៥)
    _addAngkorSpire(path, centerX, baseY - 80 * scale, 95 * scale, 340 * scale); // Tower 1: Main Central Spire
    _addAngkorSpire(path, centerX - 160 * scale, baseY - 80 * scale, 75 * scale, 240 * scale); // Tower 2: Middle Left
    _addAngkorSpire(path, centerX + 160 * scale, baseY - 80 * scale, 75 * scale, 240 * scale); // Tower 3: Middle Right
    _addAngkorSpire(path, centerX - 320 * scale, baseY - 80 * scale, 60 * scale, 180 * scale); // Tower 4: Outer Left
    _addAngkorSpire(path, centerX + 320 * scale, baseY - 80 * scale, 60 * scale, 180 * scale); // Tower 5: Outer Right

    // Draw Background Silhouette & Soft Outer Glow Stroke
    canvas.drawPath(path, silhouettePaint);
    canvas.drawPath(path, glowBorderPaint);

    // Subtle Khmer Kbach Lotus Petal Halo Atmosphere Ornaments
    final kbachPaint = Paint()
      ..color = themeColor.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = -3; i <= 3; i++) {
      if (i == 0) continue;
      final kx = centerX + i * 220 * scale;
      final ky = size.height * 0.28;
      canvas.drawCircle(Offset(kx, ky), 70 * scale, kbachPaint);
      canvas.drawCircle(Offset(kx, ky), 40 * scale, kbachPaint);
    }
  }

  /// Helper to generate iconic tiered lotus spire tower geometry of Angkor Wat
  void _addAngkorSpire(Path path, double cx, double baseY, double width, double height) {
    final hw = width / 2;
    path.moveTo(cx - hw, baseY);
    
    // Tiered Lotus Tower Base Steps
    double curY = baseY;
    double curW = hw;
    final tiers = 6;
    final tierH = height / tiers;

    for (int t = 0; t < tiers; t++) {
      curY -= tierH;
      curW *= 0.86;
      path.lineTo(cx - curW, curY + tierH * 0.3);
      path.lineTo(cx - curW, curY);
    }

    // Lotus Bud Tip Finial
    path.quadraticBezierTo(cx - curW * 0.5, curY - tierH * 0.5, cx, curY - tierH * 0.8);
    path.quadraticBezierTo(cx + curW * 0.5, curY - tierH * 0.5, cx + curW, curY);

    for (int t = tiers - 1; t >= 0; t--) {
      path.lineTo(cx + curW, curY + tierH);
      curW /= 0.86;
      curY += tierH;
      path.lineTo(cx + curW, curY);
    }

    path.lineTo(cx - hw, baseY);
    path.close();
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
    final activeColor = _isHovered ? widget.style.primaryColor : (isToday ? widget.style.primaryColor : Colors.white.withValues(alpha:0.85));

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
                  color: _isHovered ? Colors.white : (isToday ? Colors.white : Colors.white.withValues(alpha:0.75)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
