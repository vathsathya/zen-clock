import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'models/clock_settings.dart';
import 'services/display_service.dart';
import 'services/tray_service.dart';
import 'views/clock_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  bool initialUseKhmerDigits = true;
  DisplayMode initialDisplayMode = DisplayMode.clock;
  try {
    final prefs = await SharedPreferences.getInstance();
    initialUseKhmerDigits = prefs.getBool('useKhmerDigits') ?? true;
    int displayModeIndex = prefs.getInt('displayMode') ?? DisplayMode.clock.index;
    if (displayModeIndex >= 0 && displayModeIndex < DisplayMode.values.length) {
      initialDisplayMode = DisplayMode.values[displayModeIndex];
    }
  } catch (_) {}

  // Initialize System Tray with persistent language & display mode preferences
  try {
    await TrayService.instance.init(
      useKhmerDigits: initialUseKhmerDigits,
      displayMode: initialDisplayMode,
    );
  } catch (e) {
    debugPrint('Tray initialization error: $e');
  }

  // Initialize Display Monitoring Service
  DisplayService.instance.init();

  // Desktop Window Options Setup
  WindowOptions windowOptions = const WindowOptions(
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Apply Strict Secondary Screen Policy
    await DisplayService.instance.checkAndApplyDisplayPolicy();
    await windowManager.setFullScreen(true);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => ClockSettings(),
      child: const ZenClockApp(),
    ),
  );
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class ZenClockApp extends StatelessWidget {
  const ZenClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF000000),
      canvasColor: const Color(0xFF000000),
      cardColor: const Color(0xFF111111),
      dividerColor: const Color(0xFF232323),
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF111111),
        background: Color(0xFF000000),
        primary: Color(0xFFFF9800),
        secondary: Color(0xFFFFC857),
        onSurface: Color(0xFFFFFFFF),
        onBackground: Color(0xFFFFFFFF),
        outline: Color(0xFF232323),
      ),
      fontFamily: 'Kantumruy Pro',
    );

    return MaterialApp(
      title: 'Zen Digital Clock',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const ClockView(),
    );
  }
}
