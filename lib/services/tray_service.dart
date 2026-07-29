import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../models/clock_settings.dart';

class TrayService with TrayListener {
  static final TrayService instance = TrayService._internal();

  TrayService._internal();

  VoidCallback? onOpenSettings;
  Function(String mode)? onChangeDisplayMode;
  Function(bool useKhmerDigits)? onToggleLanguage;

  Future<void> init({
    bool useKhmerDigits = true,
    DisplayMode displayMode = DisplayMode.clock,
  }) async {
    trayManager.addListener(this);
    
    // Set Tray Icon
    await trayManager.setIcon('assets/icons/app_icon.png');

    await updateMenu(useKhmerDigits: useKhmerDigits, displayMode: displayMode);
  }

  Future<void> updateMenu({
    bool useKhmerDigits = true,
    DisplayMode displayMode = DisplayMode.clock,
  }) async {
    final String khmerLangPrefix = useKhmerDigits ? '✓ ' : '';
    final String englishLangPrefix = !useKhmerDigits ? '✓ ' : '';

    final String clockModePrefix = displayMode == DisplayMode.clock ? '✓ ' : '';
    final String calendarModePrefix = displayMode == DisplayMode.calendar ? '✓ ' : '';

    // System Tray Menu with Language Submenu above Settings (Clean Text, No Icons)
    Menu menu = Menu(
      items: [
        // 1. Show / Hide
        MenuItem(
          key: 'show_hide',
          label: useKhmerDigits ? 'បង្ហាញ ឬ លាក់' : 'Show / Hide',
        ),

        // 2. Display Mode Submenu
        MenuItem.submenu(
          label: useKhmerDigits ? 'របៀបបង្ហាញ' : 'Display Mode',
          submenu: Menu(
            items: [
              MenuItem(
                key: 'mode_clock',
                label: useKhmerDigits ? '${clockModePrefix}របៀបម៉ោង' : '${clockModePrefix}Clock Mode',
              ),
              MenuItem(
                key: 'mode_calendar',
                label: useKhmerDigits ? '${calendarModePrefix}របៀបប្រតិទិន' : '${calendarModePrefix}Calendar Mode',
              ),
            ],
          ),
        ),

        // 3. Language Submenu (Right Above Settings)
        MenuItem.submenu(
          label: useKhmerDigits ? 'ភាសា' : 'Language',
          submenu: Menu(
            items: [
              MenuItem(
                key: 'lang_khmer',
                label: '${khmerLangPrefix}ភាសាខ្មែរ',
              ),
              MenuItem(
                key: 'lang_english',
                label: '${englishLangPrefix}English',
              ),
            ],
          ),
        ),

        // 4. Settings
        MenuItem(
          key: 'show_settings',
          label: useKhmerDigits ? 'ការកំណត់' : 'Settings',
        ),

        MenuItem.separator(),

        // 5. Quit
        MenuItem(
          key: 'exit_app',
          label: useKhmerDigits ? 'បិទកម្មវិធី' : 'Quit App',
        ),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() async {
    bool isVisible = await windowManager.isVisible();
    if (isVisible) {
      await windowManager.hide();
    } else {
      await windowManager.show();
      await windowManager.focus();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show_hide':
        bool isVisible = await windowManager.isVisible();
        if (isVisible) {
          await windowManager.hide();
        } else {
          await windowManager.show();
          await windowManager.focus();
        }
        break;
      case 'mode_clock':
        await windowManager.show();
        await windowManager.focus();
        onChangeDisplayMode?.call('clock');
        break;
      case 'mode_calendar':
        await windowManager.show();
        await windowManager.focus();
        onChangeDisplayMode?.call('calendar');
        break;
      case 'lang_khmer':
        onToggleLanguage?.call(true);
        break;
      case 'lang_english':
        onToggleLanguage?.call(false);
        break;
      case 'show_settings':
        await windowManager.show();
        await windowManager.focus();
        onOpenSettings?.call();
        break;
      case 'exit_app':
        await trayManager.destroy();
        exit(0);
    }
  }
}
