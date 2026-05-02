import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/gate_screen.dart';
import 'screens/onboarding_screen.dart';

import 'package:zenflip/data/answers_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await Hive.initFlutter();
  await Hive.openBox('journal');
  await Hive.openBox('settings');

  // Load answers database
  await AnswersDB.init();

  // Check if first-time user
  final onboardingDone =
      Hive.box('settings').get('onboarding_done', defaultValue: false) as bool;

  runApp(
    ProviderScope(
      child: ZenFlipApp(showOnboarding: !onboardingDone),
    ),
  );
}

class ZenFlipApp extends StatelessWidget {
  final bool showOnboarding;
  const ZenFlipApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Book of Answers',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: showOnboarding ? const OnboardingScreen() : const GateScreen(),
    );
  }
}

