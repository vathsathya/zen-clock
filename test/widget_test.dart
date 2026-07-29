import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zen_clock/main.dart';
import 'package:zen_clock/models/clock_settings.dart';

void main() {
  testWidgets('ZenClockApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ClockSettings(),
        child: const ZenClockApp(),
      ),
    );

    expect(find.byType(ZenClockApp), findsOneWidget);
  });
}
