import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/clock_settings.dart';

class WeatherAnimationPainter extends CustomPainter {
  final WeatherInfo? weatherInfo;
  final DateTime currentTime;
  final Color themeColor;
  final double animProgress;
  final LiveWallpaperMode wallpaperMode;
  final bool isOverlay;

  // Static Reusable Paint Instances (Eliminates GC Heap Allocations on 60FPS Paint Loop)
  static final Paint _starPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _glowPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _rainPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  static final Paint _shadowPaint = Paint()
    ..color = const Color(0x40000000)
    ..style = PaintingStyle.fill;
  static final Paint _highlightPaint = Paint()
    ..color = const Color(0xE6FFFFFF)
    ..style = PaintingStyle.fill;
  static final Paint _trailPaint = Paint()
    ..color = const Color(0x1FFFFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _ripplePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2;
  static final Paint _splashPaint = Paint()
    ..color = const Color(0xCCFFFFFF)
    ..style = PaintingStyle.fill;
  static final Paint _fogPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _headPaint = Paint()
    ..color = Colors.white
    ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3.0);
  static final Paint _shaderPaint = Paint();

  // Pre-computed Particle Math Seed Lookup Tables (Float32List) - 0 Runtime Trig Calls!
  static final Float32List _starSeedsX = Float32List(90);
  static final Float32List _starSeedsY = Float32List(90);
  static final Float32List _starOpacities = Float32List(90);
  static final Float32List _rainSeedsX = Float32List(65);
  static final Float32List _dropSeedsX = Float32List(35);
  static final Float32List _rippleSeedsX = Float32List(12);
  static final Float32List _rippleSeedsY = Float32List(12);

  static bool _lutsInitialized = false;

  WeatherAnimationPainter({
    required this.weatherInfo,
    required this.currentTime,
    required this.themeColor,
    required this.animProgress,
    required this.wallpaperMode,
    this.isOverlay = true,
  }) {
    _initLutsIfNeeded();
  }

  static void _initLutsIfNeeded() {
    if (_lutsInitialized) return;
    _lutsInitialized = true;

    for (int i = 0; i < 90; i++) {
      final seed = i * 223.7;
      _starSeedsX[i] = (sin(seed) * 0.5 + 0.5);
      _starSeedsY[i] = (cos(seed * 0.7) * 0.5 + 0.5);
      _starOpacities[i] = seed;
    }

    for (int i = 0; i < 65; i++) {
      final seed = i * 137.5;
      _rainSeedsX[i] = (sin(seed) * 0.5 + 0.5);
    }

    for (int i = 0; i < 35; i++) {
      final seed = i * 199.3;
      _dropSeedsX[i] = (sin(seed * 1.5) * 0.5 + 0.5);
    }

    for (int i = 0; i < 12; i++) {
      final seed = i * 317.9;
      _rippleSeedsX[i] = (sin(seed * 2.1) * 0.5 + 0.5);
      _rippleSeedsY[i] = (cos(seed * 1.3) * 0.5 + 0.5);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!isOverlay) {
      _drawSkyGradient(canvas, size);
    }
    _drawWeatherParticles(canvas, size);
  }

  void _drawSkyGradient(Canvas canvas, Size size) {
    final hour = currentTime.hour;
    List<Color> gradientColors;

    if (hour >= 5 && hour < 7) {
      gradientColors = const [
        Color(0xFF2C1654),
        Color(0xFF8C4A6E),
        Color(0xFFFF8C69),
        Color(0xFFFFD180),
      ];
    } else if (hour >= 7 && hour < 17) {
      gradientColors = [
        themeColor.withValues(alpha: 0.35),
        themeColor.withValues(alpha: 0.12),
        const Color(0xFF000000),
      ];
    } else if (hour >= 17 && hour < 19) {
      gradientColors = const [
        Color(0xFF1F1135),
        Color(0xFF6B2653),
        Color(0xFFD35400),
        Color(0xFFF39C12),
      ];
    } else {
      gradientColors = const [
        Color(0xFF050B14),
        Color(0xFF0A1526),
        Color(0xFF000000),
      ];
    }

    _shaderPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientColors,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _shaderPaint);
  }

  void _drawWeatherParticles(Canvas canvas, Size size) {
    final hour = currentTime.hour;
    final isNight = hour >= 19 || hour < 5;

    int weatherCode = 0;
    if (wallpaperMode == LiveWallpaperMode.thunderstorm || wallpaperMode == LiveWallpaperMode.videoThunderstorm) {
      weatherCode = 95;
    } else if (wallpaperMode == LiveWallpaperMode.gentleRain) {
      weatherCode = 60;
    } else if (weatherInfo != null && weatherInfo!.dailyItems.isNotEmpty) {
      final todayItem = weatherInfo!.dailyItems.firstWhere(
        (item) => item.isToday,
        orElse: () => weatherInfo!.dailyItems.first,
      );
      if (todayItem.conditionIcon.contains('🌧️') || todayItem.conditionIcon.contains('🌦️')) {
        weatherCode = 60;
      } else if (todayItem.conditionIcon.contains('🌩️')) {
        weatherCode = 95;
      } else if (todayItem.conditionIcon.contains('🌫️')) {
        weatherCode = 45;
      } else {
        weatherCode = 95;
      }
    } else {
      weatherCode = 95;
    }

    // 1. Ambient Thunderstorm Atmospheric Flash Effect
    if (weatherCode >= 95) {
      _drawAmbientLightningFlash(canvas, size);
    }

    // 2. Cosmic Nebula & Night Stars Twinkling Effect
    if (isNight ||
        wallpaperMode == LiveWallpaperMode.cosmicStars ||
        wallpaperMode == LiveWallpaperMode.gentleRain ||
        wallpaperMode == LiveWallpaperMode.thunderstorm ||
        wallpaperMode == LiveWallpaperMode.videoThunderstorm) {
      
      _drawCosmicNebula(canvas, size);

      for (int i = 0; i < 90; i++) {
        final x = _starSeedsX[i] * size.width;
        final y = _starSeedsY[i] * (size.height * 0.85);
        final starOpacity = (sin(animProgress * 4 * pi + _starOpacities[i]) * 0.45 + 0.5).clamp(0.2, 0.95);
        final starRadius = (i % 5 == 0) ? 3.5 : ((i % 2 == 0) ? 2.2 : 1.5);

        if (i % 5 == 0) {
          _glowPaint.color = Colors.white.withValues(alpha: starOpacity * 0.35);
          canvas.drawCircle(Offset(x, y), starRadius * 2.2, _glowPaint);
        }

        _starPaint.color = Colors.white.withValues(alpha: starOpacity);
        canvas.drawCircle(Offset(x, y), starRadius, _starPaint);
      }

      _drawShootingStars(canvas, size);
    }

    // 3. Rain & Thunderstorm Particles + Screen Glass Water Drops & Splashes
    if (weatherCode >= 50 && weatherCode <= 85 || weatherCode >= 95) {
      int particleCount = (weatherCode >= 95) ? 65 : 45;
      for (int i = 0; i < particleCount; i++) {
        final x = _rainSeedsX[i] * size.width;
        final speed = 200.0 + (i % 7) * 70.0;
        final y = (animProgress * speed + (i * 137.5) * 12) % (size.height + 60) - 30;
        final length = 20.0 + (i % 5) * 12.0;

        _rainPaint.color = Colors.lightBlueAccent.withValues(alpha: (0.2 + (i % 4) * 0.1).clamp(0.1, 0.55));
        _rainPaint.strokeWidth = (i % 3 == 0) ? 2.2 : 1.2;
        canvas.drawLine(Offset(x, y), Offset(x - 3, y + length), _rainPaint);
      }

      _drawScreenGlassDroplets(canvas, size);
      _drawSplashRipples(canvas, size);
    }

    // 4. Fog Drifting Effect
    if (weatherCode >= 45 && weatherCode <= 48) {
      for (int i = 0; i < 4; i++) {
        final fogY = size.height * (0.3 + i * 0.18);
        final fogX = (animProgress * 40.0 * (i % 2 == 0 ? 1 : -1) + i * 150) % size.width;
        _fogPaint.color = Colors.white.withValues(alpha: 0.06 - i * 0.01);
        canvas.drawCircle(Offset(fogX, fogY), size.width * 0.4, _fogPaint);
      }
    }

    // 5. Daytime Sun Beams Effect
    if (!isNight && weatherCode < 50) {
      final sunCenter = Offset(size.width * 0.85, size.height * 0.2);
      _shaderPaint.shader = RadialGradient(
        colors: [
          Colors.amberAccent.withValues(alpha: 0.18),
          Colors.orangeAccent.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: size.width * 0.35));
      canvas.drawCircle(sunCenter, size.width * 0.35, _shaderPaint);
    }
  }

  void _drawCosmicNebula(Canvas canvas, Size size) {
    final nebulaCenter1 = Offset(size.width * 0.25, size.height * 0.2);
    _shaderPaint.shader = RadialGradient(
      colors: const [
        Color(0x2B4A00E0),
        Color(0x188E2DE2),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6, 1.0],
    ).createShader(Rect.fromCircle(center: nebulaCenter1, radius: size.width * 0.4));
    canvas.drawCircle(nebulaCenter1, size.width * 0.4, _shaderPaint);

    final nebulaCenter2 = Offset(size.width * 0.75, size.height * 0.3);
    _shaderPaint.shader = RadialGradient(
      colors: const [
        Color(0x2000C6FF),
        Color(0x120072FF),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: nebulaCenter2, radius: size.width * 0.45));
    canvas.drawCircle(nebulaCenter2, size.width * 0.45, _shaderPaint);
  }

  void _drawShootingStars(Canvas canvas, Size size) {
    final streakPhase = (animProgress * 1.8) % 1.0;
    if (streakPhase < 0.28) {
      final progress = streakPhase / 0.28;
      final startX = size.width * 0.7 - progress * (size.width * 0.35);
      final startY = size.height * 0.08 + progress * (size.height * 0.22);
      final tailLength = 90.0 * (1.0 - (progress - 0.5).abs() * 2).clamp(0.2, 1.0);

      _shaderPaint.shader = LinearGradient(
        colors: [
          Colors.white,
          Colors.cyanAccent.withValues(alpha: 0.8),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromPoints(
        Offset(startX, startY),
        Offset(startX + tailLength * 0.8, startY - tailLength * 0.5),
      ));

      _shaderPaint.strokeWidth = 2.5;
      _shaderPaint.strokeCap = StrokeCap.round;
      _shaderPaint.style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + tailLength * 0.8, startY - tailLength * 0.5),
        _shaderPaint,
      );

      canvas.drawCircle(Offset(startX, startY), 3.0, _headPaint);
    }
  }

  void _drawAmbientLightningFlash(Canvas canvas, Size size) {
    final flashPhase = (animProgress * 2.5) % 1.0;
    if (flashPhase > 0.88 && flashPhase < 0.94) {
      final flashIntensity = sin((flashPhase - 0.88) / 0.06 * pi) * 0.15;
      _shaderPaint.shader = null;
      _shaderPaint.color = Colors.lightBlueAccent.withValues(alpha: flashIntensity);
      _shaderPaint.style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _shaderPaint);
    }
  }

  void _drawScreenGlassDroplets(Canvas canvas, Size size) {
    const int dropCount = 35;
    for (int i = 0; i < dropCount; i++) {
      final x = _dropSeedsX[i] * size.width;
      final slowSpeed = 25.0 + (i % 4) * 15.0;
      final rawY = (animProgress * slowSpeed + (i * 199.3) * 8) % (size.height + 40) - 20;
      final radius = 3.5 + (i % 5) * 2.2;

      // 1. Shadow
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 1.2, rawY + 1.5), width: radius * 2.2, height: radius * 2.6),
        _shadowPaint,
      );

      // 2. Body
      _shaderPaint.shader = RadialGradient(
        colors: [
          Colors.lightBlue.shade100.withValues(alpha: 0.45),
          Colors.blueGrey.shade800.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromCircle(center: Offset(x, rawY), radius: radius));
      _shaderPaint.style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, rawY), width: radius * 2.0, height: radius * 2.4),
        _shaderPaint,
      );

      // 3. Highlight
      canvas.drawCircle(Offset(x - radius * 0.35, rawY - radius * 0.35), radius * 0.32, _highlightPaint);

      // 4. Trail
      if (i % 3 == 0) {
        canvas.drawLine(Offset(x, rawY - 14), Offset(x, rawY - 2), _trailPaint);
      }
    }
  }

  void _drawSplashRipples(Canvas canvas, Size size) {
    const int rippleCount = 12;
    for (int i = 0; i < rippleCount; i++) {
      final x = _rippleSeedsX[i] * size.width;
      final y = _rippleSeedsY[i] * size.height;

      final phase = (animProgress * 2.5 + i * 0.15) % 1.0;
      final maxRadius = 16.0 + (i % 3) * 8.0;
      final currentRadius = phase * maxRadius;
      final opacity = (1.0 - phase).clamp(0.0, 0.7);

      _ripplePaint.color = Colors.lightBlueAccent.withValues(alpha: opacity * 0.4);
      canvas.drawCircle(Offset(x, y), currentRadius, _ripplePaint);

      if (phase < 0.4) {
        _splashPaint.color = Colors.white.withValues(alpha: opacity * 0.8);
        for (int k = 0; k < 4; k++) {
          final angle = k * (pi / 2) + (i * 317.9);
          final splashDist = currentRadius * 0.7;
          canvas.drawCircle(
            Offset(x + cos(angle) * splashDist, y + sin(angle) * splashDist),
            1.2,
            _splashPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant WeatherAnimationPainter oldDelegate) {
    return oldDelegate.currentTime.minute != currentTime.minute ||
        oldDelegate.weatherInfo != weatherInfo ||
        oldDelegate.themeColor != themeColor ||
        oldDelegate.wallpaperMode != wallpaperMode ||
        oldDelegate.isOverlay != isOverlay ||
        oldDelegate.animProgress != animProgress;
  }
}
