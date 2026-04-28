import 'package:flutter/material.dart';
import 'models.dart';

class SanctumEnvironment {
  final SanctumEnv id;
  final String name;
  final Color primaryAmbient;
  final Color secondaryAmbient;
  final String? backgroundAudio;

  const SanctumEnvironment({
    required this.id,
    required this.name,
    required this.primaryAmbient,
    required this.secondaryAmbient,
    this.backgroundAudio,
  });
}

class Environments {
  static const SanctumEnvironment fireplace = SanctumEnvironment(
    id: SanctumEnv.fireplace,
    name: 'The Fireplace',
    primaryAmbient: Color(0xFFC47030),
    secondaryAmbient: Color(0xFF3B2011),
    backgroundAudio: 'fire_crackling.mp3',
  );

  static const SanctumEnvironment library = SanctumEnvironment(
    id: SanctumEnv.library,
    name: 'Old Library',
    primaryAmbient: Color(0xFFCFC5A5),
    secondaryAmbient: Color(0xFF2C2A20),
    backgroundAudio: 'library_ambient.mp3',
  );

  static const SanctumEnvironment church = SanctumEnvironment(
    id: SanctumEnv.church,
    name: 'Ruined Church',
    primaryAmbient: Color(0xFF90A4AE),
    secondaryAmbient: Color(0xFF1C2A31),
    backgroundAudio: 'church_wind.mp3',
  );

  static const List<SanctumEnvironment> all = [fireplace, library, church];
  static SanctumEnvironment get(SanctumEnv env) => all.firstWhere((e) => e.id == env);
}
