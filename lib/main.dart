import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'models/clock_settings.dart';
import 'views/clock_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Desktop Window Options Setup
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1024, 768),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.setAsFrameless();
    
    // Check Screen Count for Strict Secondary Screen Policy
    List<Display> displays = await screenRetriever.getAllDisplays();
    if (displays.length < 2) {
      // If only 1 screen exists and target is secondary screen, hide window to tray!
      await windowManager.hide();
    }
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => ClockSettings(),
      child: const ZenClockApp(),
    ),
  );
}

class ZenClockApp extends StatelessWidget {
  const ZenClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zen Digital Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ClockView(),
    );
  }
}
