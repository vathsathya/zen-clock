import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

class DisplayService {
  static final DisplayService instance = DisplayService._internal();

  DisplayService._internal();

  Timer? _monitorTimer;
  int _lastDisplayCount = -1;
  bool _isProcessing = false;

  void init() {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS) return;
    // Periodically monitor display count changes (instant hot-plugging of 2nd monitor)
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_isProcessing) {
        checkAndApplyDisplayPolicy();
      }
    });
  }

  Future<void> checkAndApplyDisplayPolicy() async {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS) return;
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      List<Display> displays = await screenRetriever.getAllDisplays();
      
      if (displays.length != _lastDisplayCount) {
        if (displays.length >= 2) {
          // Secondary Screen Exists! Automatically Move & Show Fullscreen on Screen #2
          Display secondaryDisplay = displays[1];
          double x = secondaryDisplay.visiblePosition?.dx ?? 0;
          double y = secondaryDisplay.visiblePosition?.dy ?? 0;
          double width = secondaryDisplay.size.width;
          double height = secondaryDisplay.size.height;

          await windowManager.setBounds(Rect.fromLTWH(x, y, width, height));
          await windowManager.setAsFrameless();
          await windowManager.setFullScreen(true);
          await windowManager.setAlwaysOnTop(true);
          
          bool isVisible = await windowManager.isVisible();
          if (!isVisible) {
            await windowManager.show();
            await windowManager.focus();
          }
        }
        _lastDisplayCount = displays.length;
      }
    } catch (e) {
      debugPrint('DisplayService check error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void dispose() {
    _monitorTimer?.cancel();
  }
}
