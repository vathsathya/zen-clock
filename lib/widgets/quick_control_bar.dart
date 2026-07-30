import 'package:flutter/material.dart';
import '../models/clock_settings.dart';

class QuickControlBar extends StatelessWidget {
  final ClockSettings settings;
  final Color primaryColor;
  final VoidCallback onToggleDisplayMode;
  final VoidCallback onToggleFocusTimer;
  final VoidCallback onNextTheme;
  final VoidCallback onOpenSettings;
  final VoidCallback onToggleDigits;
  final VoidCallback onToggleFullscreen;
  final VoidCallback? onExitApp;
  final VoidCallback? onJumpToToday;
  final bool isFocusTimerActive;

  const QuickControlBar({
    super.key,
    required this.settings,
    required this.primaryColor,
    required this.onToggleDisplayMode,
    required this.onToggleFocusTimer,
    required this.onNextTheme,
    required this.onOpenSettings,
    required this.onToggleDigits,
    required this.onToggleFullscreen,
    this.onExitApp,
    this.onJumpToToday,
    this.isFocusTimerActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isKhmer = settings.useKhmerDigits;
    final isCalendar = settings.displayMode == DisplayMode.calendar;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Clock / Calendar View Switcher Button
          _ControlButton(
            icon: isCalendar ? Icons.access_time_rounded : Icons.calendar_month_rounded,
            label: isCalendar
                ? (isKhmer ? 'នាឡិកា' : 'Clock')
                : (isKhmer ? 'ប្រតិទិន' : 'Calendar'),
            tooltip: isCalendar
                ? (isKhmer ? 'ត្រឡប់ទៅនាឡិកា (C)' : 'Back to Clock (C)')
                : (isKhmer ? 'មើលប្រតិទិន (C)' : 'View Calendar (C)'),
            isActive: !isCalendar,
            activeColor: primaryColor,
            onPressed: onToggleDisplayMode,
          ),

          const SizedBox(width: 8),

          // 2. Jump to Today (Only visible in Calendar Mode)
          if (isCalendar && onJumpToToday != null) ...[
            _ControlButton(
              icon: Icons.today_rounded,
              label: isKhmer ? 'ថ្ងៃនេះ' : 'Today',
              tooltip: isKhmer ? 'លោតទៅថ្ងៃនេះ' : 'Jump to Today',
              activeColor: primaryColor,
              onPressed: onJumpToToday!,
            ),
            const SizedBox(width: 8),
          ],

          // 3. Zen Focus Timer Toggle (Hidden in Calendar Mode)
          if (!isCalendar) ...[
            _ControlButton(
              icon: Icons.timer_outlined,
              label: isKhmer ? 'ផ្ដោតអារម្មណ៍' : 'Focus',
              tooltip: isKhmer ? 'នាឡិការាប់ថយក្រោយ (T)' : 'Zen Focus Timer (T)',
              isActive: isFocusTimerActive,
              activeColor: primaryColor,
              onPressed: onToggleFocusTimer,
            ),
            const SizedBox(width: 8),
          ],

          // 4. Theme Preset Switcher
          _ControlButton(
            icon: Icons.palette_outlined,
            label: isKhmer ? 'ប្រធានបទ' : 'Theme',
            tooltip: isKhmer
                ? 'Theme ខេត្តខ្មែរទាំង ២៥ (N) - ចុចដើម្បីប្តូរ'
                : '25 Cambodian Province Themes (N) - Click to cycle',
            activeColor: primaryColor,
            onPressed: onNextTheme,
          ),

          const SizedBox(width: 8),

          // 5. Khmer / English Digits Toggle
          _ControlButton(
            icon: Icons.translate_rounded,
            label: isKhmer ? '១២៣' : '123',
            tooltip: isKhmer ? 'ប្តូរជាលេខអារ៉ាប់' : 'Switch to Khmer Digits',
            isActive: isKhmer,
            activeColor: primaryColor,
            onPressed: onToggleDigits,
          ),

          const SizedBox(width: 8),

          // 6. Settings Dialog Button
          _ControlButton(
            icon: Icons.settings_outlined,
            label: isKhmer ? 'ការកំណត់' : 'Settings',
            tooltip: isKhmer ? 'ការកំណត់ (S)' : 'Settings (S)',
            activeColor: primaryColor,
            onPressed: onOpenSettings,
          ),

          if (onExitApp != null) ...[
            const SizedBox(width: 8),
            // 7. Top-Right Red Accent Exit Button
            _ControlButton(
              icon: Icons.power_settings_new_rounded,
              label: isKhmer ? 'ចាកចេញ' : 'Exit',
              tooltip: isKhmer ? 'ចាកចេញពីកម្មវិធី' : 'Exit Application',
              isActive: true,
              activeColor: Colors.redAccent,
              onPressed: onExitApp!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isActive;
  final Color activeColor;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
    required this.activeColor,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final fgColor = widget.isActive ? widget.activeColor : Colors.white;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 18, color: fgColor),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w500,
                      color: fgColor,
                    ),
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
