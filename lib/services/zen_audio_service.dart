import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum ZenAmbientSound {
  off,
  gentleRain,
  softWind,
  oceanWaves,
  forestStream,
}

class ZenAudioService {
  static final ZenAudioService _instance = ZenAudioService._internal();
  static ZenAudioService get instance => _instance;

  ZenAudioService._internal();

  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _chimePlayer = AudioPlayer();

  ZenAmbientSound _currentAmbient = ZenAmbientSound.off;
  double _volume = 0.5;
  bool _isMuted = false;

  ZenAmbientSound get currentAmbient => _currentAmbient;
  double get volume => _volume;
  bool get isMuted => _isMuted;

  // Stream URLs for ambient soundscapes (high quality royalty-free Zen sounds)
  final Map<ZenAmbientSound, String> _ambientUrls = {
    ZenAmbientSound.gentleRain:
        'https://actions.google.com/sounds/v1/weather/rain_heavy_loud.ogg',
    ZenAmbientSound.softWind:
        'https://actions.google.com/sounds/v1/weather/wind_heavy.ogg',
    ZenAmbientSound.oceanWaves:
        'https://actions.google.com/sounds/v1/water/ocean_waves.ogg',
    ZenAmbientSound.forestStream:
        'https://actions.google.com/sounds/v1/water/stream_water.ogg',
  };

  // Sound chime URL for timer alerts / notifications
  static const String _chimeUrl =
      'https://actions.google.com/sounds/v1/alarms/beep_short.ogg';

  Future<void> init() async {
    try {
      await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
      await _ambientPlayer.setVolume(_volume);
      await _chimePlayer.setVolume(_volume);
    } catch (e) {
      debugPrint('ZenAudioService init error: $e');
    }
  }

  Future<void> playAmbient(ZenAmbientSound sound) async {
    if (_currentAmbient == sound && sound != ZenAmbientSound.off) return;

    _currentAmbient = sound;
    if (sound == ZenAmbientSound.off || _isMuted) {
      await stopAmbient();
      return;
    }

    final url = _ambientUrls[sound];
    if (url != null) {
      try {
        await _ambientPlayer.stop();
        await _ambientPlayer.play(UrlSource(url));
        await _ambientPlayer.setVolume(_isMuted ? 0.0 : _volume);
      } catch (e) {
        debugPrint('Error playing ambient sound: $e');
      }
    }
  }

  Future<void> stopAmbient() async {
    try {
      await _ambientPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping ambient sound: $e');
    }
  }

  Future<void> playChime() async {
    if (_isMuted) return;
    try {
      await _chimePlayer.stop();
      await _chimePlayer.play(UrlSource(_chimeUrl));
      await _chimePlayer.setVolume(_volume);
    } catch (e) {
      debugPrint('Error playing chime: $e');
    }
  }

  Future<void> setVolume(double vol) async {
    _volume = vol.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _ambientPlayer.setVolume(_volume);
      await _chimePlayer.setVolume(_volume);
    }
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (_isMuted) {
      await _ambientPlayer.setVolume(0.0);
      await _chimePlayer.setVolume(0.0);
    } else {
      await _ambientPlayer.setVolume(_volume);
      await _chimePlayer.setVolume(_volume);
      if (_currentAmbient != ZenAmbientSound.off) {
        playAmbient(_currentAmbient);
      }
    }
  }

  void dispose() {
    _ambientPlayer.dispose();
    _chimePlayer.dispose();
  }
}
