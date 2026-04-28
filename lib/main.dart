import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/gate_screen.dart';

import 'package:zenflip/data/answers_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await Hive.initFlutter();
  await Hive.openBox('journal');
  await Hive.openBox('settings');

  // Load answers database
  await AnswersDB.init();

  runApp(
    const ProviderScope(
      child: ZenFlipApp(),
    ),
  );
}

class ZenFlipApp extends StatelessWidget {
  const ZenFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Book of Answers',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const GateScreen(),
    );
  }
}
