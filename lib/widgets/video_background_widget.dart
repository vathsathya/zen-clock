import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class VideoBackgroundWidget extends StatefulWidget {
  final String fallbackImagePath;

  const VideoBackgroundWidget({
    super.key,
    this.fallbackImagePath = 'assets/images/angkor_night.png',
  });

  @override
  State<VideoBackgroundWidget> createState() => _VideoBackgroundWidgetState();
}

class _VideoBackgroundWidgetState extends State<VideoBackgroundWidget> {
  final List<Map<String, String>> _playlist = const [
    {
      'mp4': 'assets/videos/thunder.mp4',
      'webp': 'assets/videos/thunder_full.webp',
    },
    {
      'mp4': 'assets/videos/thunder1.mp4',
      'webp': 'assets/videos/thunder1_full.webp',
    },
    {
      'mp4': 'assets/videos/thunder2.mp4',
      'webp': 'assets/videos/thunder2_full.webp',
    },
    {
      'mp4': 'assets/videos/thunder3.mp4',
      'webp': 'assets/videos/thunder3_full.webp',
    },
  ];

  int _currentIndex = 0;
  Timer? _intervalTimer;
  final Random _random = Random();
  bool _hasPrecached = false;

  @override
  void initState() {
    super.initState();
    // Pick initial random video
    _currentIndex = _random.nextInt(_playlist.length);
    _scheduleNextRandomStrike();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPrecached) {
      _hasPrecached = true;
      // Pre-cache all 4 WebP assets and fallback image into Memory Cache for 100% stutter-free zero-lag transitions!
      for (final item in _playlist) {
        precacheImage(AssetImage(item['webp']!), context);
      }
      precacheImage(AssetImage(widget.fallbackImagePath), context);
    }
  }

  void _scheduleNextRandomStrike() {
    _intervalTimer?.cancel();
    // Random duration between 30s and 120s for natural unpredictable thunderstorm pacing
    final randomIntervalSeconds = 30 + _random.nextInt(91);
    _intervalTimer = Timer(Duration(seconds: randomIntervalSeconds), () {
      if (mounted) {
        setState(() {
          // Select a random video index from playlist without repeating the exact same video
          int nextIndex;
          do {
            nextIndex = _random.nextInt(_playlist.length);
          } while (nextIndex == _currentIndex && _playlist.length > 1);
          _currentIndex = nextIndex;
        });
        _scheduleNextRandomStrike();
      }
    });
  }

  @override
  void dispose() {
    _intervalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _playlist[_currentIndex];
    final webpPath = currentItem['webp']!;

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Persistent Base Image Layer (Prevents any black flicker during decode or switch)
          Image.asset(
            widget.fallbackImagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 2000),
            switchInCurve: Curves.easeInOutCubic,
            switchOutCurve: Curves.easeInOutCubic,
            layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            child: SizedBox.expand(
              key: ValueKey<String>(webpPath),
              child: Image.asset(
                webpPath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                gaplessPlayback: true,
                errorBuilder: (ctx, err, stack) {
                  return Image.asset(
                    widget.fallbackImagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
