import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zenflip/main.dart';
import 'package:zenflip/widgets/pixel_button.dart';

void main() {
  setUpAll(() async {
    // We mock Hive initialization for tests
    Hive.init('test_hive_db');
    await Hive.openBox('journal');
    await Hive.openBox('settings');
  });

  testWidgets('App renders GateScreen and contains ENTER button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ZenFlipApp()));

    // Verify that our app starts on the Gate Screen with "The Book of Answers" text
    expect(find.textContaining('The Book\nof Answers'), findsOneWidget);

    // Verify the ENTER button exists
    expect(find.byType(PixelButton), findsOneWidget);
    expect(find.text('⊹ ENTER ⊹'), findsOneWidget);
  });
}
