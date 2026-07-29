import 'dart:async';
import 'package:flutter/material.dart';
import '../models/clock_settings.dart';
import '../services/font_service.dart';
import '../utils/khmer_string_utils.dart';

enum TimerState { stopped, running, paused }
enum TimerMode { focus, shortBreak, longBreak }

class FocusTimerView extends StatefulWidget {
  final ClockSettings settings;
  final Color primaryColor;
  final Color textColor;

  const FocusTimerView({
    super.key,
    required this.settings,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  State<FocusTimerView> createState() => _FocusTimerViewState();
}

class _FocusTimerViewState extends State<FocusTimerView> {
  TimerMode _mode = TimerMode.focus;
  TimerState _state = TimerState.stopped;
  late int _remainingSeconds;
  Timer? _timer;

  static const int focusDuration = 25 * 60;
  static const int shortBreakDuration = 5 * 60;
  static const int longBreakDuration = 15 * 60;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _totalDuration {
    switch (_mode) {
      case TimerMode.focus:
        return focusDuration;
      case TimerMode.shortBreak:
        return shortBreakDuration;
      case TimerMode.longBreak:
        return longBreakDuration;
    }
  }

  void _switchMode(TimerMode newMode) {
    _timer?.cancel();
    setState(() {
      _mode = newMode;
      _state = TimerState.stopped;
      _remainingSeconds = _totalDuration;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _state = TimerState.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _state = TimerState.stopped);
        _showCompletedDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _state = TimerState.paused);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _state = TimerState.stopped;
      _remainingSeconds = _totalDuration;
    });
  }

  void _showCompletedDialog() {
    final isKhmer = widget.settings.useKhmerDigits;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: widget.primaryColor.withOpacity(0.4)),
        ),
        title: Text(
          isKhmer ? "🎉 សម្រេចការផ្ដោតអារម្មណ៍!" : "🎉 Focus Completed!",
          style: FontService.getTextStyle(
            widget.settings.fontFamily,
            TextStyle(color: widget.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          isKhmer
              ? "អ្នកបានសម្រេចវគ្គផ្ដោតអារម្មណ៍ Zen Focus ដោយជោគជ័យ! សូមសម្រាកបន្តិច។"
              : "Great job! You have successfully completed your Zen Focus session.",
          style: FontService.getTextStyle(
            widget.settings.fontFamily,
            const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isKhmer ? "យល់ព្រម" : "OK",
              style: TextStyle(color: widget.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKhmer = widget.settings.useKhmerDigits;
    final int minutes = _remainingSeconds ~/ 60;
    final int seconds = _remainingSeconds % 60;

    final String minutesStr = KhmerStringUtils.formatTwoDigits(minutes, useKhmerDigits: isKhmer);
    final String secondsStr = KhmerStringUtils.formatTwoDigits(seconds, useKhmerDigits: isKhmer);

    final double progress = 1.0 - (_remainingSeconds / _totalDuration);

    String statusText;
    if (_state == TimerState.running) {
      statusText = _mode == TimerMode.focus
          ? (isKhmer ? "🧘‍♂️ កំពុងផ្ដោតអារម្មណ៍ធ្វើការ..." : "🧘‍♂️ Deep Focus Session...")
          : (isKhmer ? "☕ ដល់ពេលសម្រាកបន្តិច..." : "☕ Taking a Rest...");
    } else if (_state == TimerState.paused) {
      statusText = isKhmer ? "⏸️ បានផ្អាកបណ្ដោះអាសន្ន" : "⏸️ Paused";
    } else {
      statusText = isKhmer ? "🎯 ត្រៀមខ្លួនសម្រាប់ Zen Focus" : "🎯 Ready for Focus";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mode Selector (Focus / Short Break / Long Break)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ModeTab(
              title: isKhmer ? "ផ្ដោតអារម្មណ៍ (២៥នាទី)" : "Focus (25m)",
              isSelected: _mode == TimerMode.focus,
              activeColor: widget.primaryColor,
              onTap: () => _switchMode(TimerMode.focus),
            ),
            const SizedBox(width: 12),
            _ModeTab(
              title: isKhmer ? "សម្រាកខ្លី (៥នាទី)" : "Short Break (5m)",
              isSelected: _mode == TimerMode.shortBreak,
              activeColor: widget.primaryColor,
              onTap: () => _switchMode(TimerMode.shortBreak),
            ),
            const SizedBox(width: 12),
            _ModeTab(
              title: isKhmer ? "សម្រាកវែង (១៥នាទី)" : "Long Break (15m)",
              isSelected: _mode == TimerMode.longBreak,
              activeColor: widget.primaryColor,
              onTap: () => _switchMode(TimerMode.longBreak),
            ),
          ],
        ),

        const SizedBox(height: 36),

        // Circular Timer Display
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$minutesStr:$secondsStr",
                  style: FontService.getTextStyle(
                    widget.settings.fontFamily,
                    TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: isKhmer ? 1.0 : 0.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  statusText,
                  style: FontService.getTextStyle(
                    widget.settings.fontFamily,
                    TextStyle(
                      fontSize: 14,
                      color: widget.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 40),

        // Control Actions (Start / Pause / Reset)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_state != TimerState.running)
              ElevatedButton.icon(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: Icon(_state == TimerState.paused ? Icons.play_arrow_rounded : Icons.play_arrow_rounded),
                label: Text(
                  _state == TimerState.paused
                      ? (isKhmer ? "បន្ត" : "Resume")
                      : (isKhmer ? "ចាប់ផ្តើម" : "Start Focus"),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _pauseTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.pause_rounded),
                label: Text(
                  isKhmer ? "ផ្អាក" : "Pause",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: _resetTimer,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.8),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                isKhmer ? "កំណត់ឡើងវិញ" : "Reset",
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _ModeTab({
    required this.title,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? activeColor : Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
