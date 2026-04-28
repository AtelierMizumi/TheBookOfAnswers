import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AnswersDB {
  static const List<Tome> books = [
    Tome(
      id: "universal",
      name: "Universal Wisdom",
      emoji: "📖",
      desc: "Timeless answers for all of life's questions",
      baseColor: AppTheme.gold,
    ),
    Tome(
      id: "love",
      name: "Book of Love",
      emoji: "💕",
      desc: "Gentle whispers for the heart's deepest questions",
      baseColor: Color(0xFFB87B8A), // Dusty rose
    ),
    Tome(
      id: "fire",
      name: "Book of Fire",
      emoji: "🔥",
      desc: "Bold truths to ignite your spirit and drive",
      baseColor: AppTheme.ember,
    ),
    Tome(
      id: "brutal",
      name: "Brutal Truth",
      emoji: "💀",
      desc: "Unfiltered honesty — for those who can handle it",
      baseColor: Color(0xFF5A9A6B), // Poison green
    ),
    Tome(
      id: "midnight",
      name: "Book of Midnight",
      emoji: "🌙",
      desc: "Deep reflections for the quiet hours of the soul",
      baseColor: Color(0xFF8B6AAE), // Amethyst
    ),
    Tome(
      id: "chaos",
      name: "Book of Chaos",
      emoji: "🎲",
      desc: "Expect the unexpected — embrace the absurd",
      baseColor: Color(0xFFC9A040), // Strange amber
    ),
  ];

  static const List<Answer> midnightSpecials = [
    Answer(text: "The shadows hold what the light conceals."),
    Answer(text: "In the quiet, the universe screams its truth.", weight: 8),
    Answer(text: "Sleep. Dreams will provide what waking cannot.", weight: 6),
    Answer(text: "The stars align, but not for this.", weight: 7),
    Answer(text: "Midnight brings clarity to the blind eye.", weight: 9),
  ];

  static Map<String, List<Answer>> _answers = {};

  static Future<void> init() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/tomes.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      data.forEach((key, value) {
        _answers[key] = (value as List).map((e) => Answer(
          text: e['text'],
          attribution: e['attribution'],
          weight: e['weight'] ?? 1,
        )).toList();
      });
    } catch (e) {
      debugPrint('Failed to load tomes.json: $e');
    }
  }

  static List<Answer> getAnswersFor(String tomeId) {
    List<Answer> pool = List.from(_answers[tomeId] ?? _answers['universal'] ?? []);
    
    // Midnight mode (00:00 - 04:00)
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 4 && tomeId != 'chaos') {
      pool.addAll(midnightSpecials);
    }
    
    return pool;
  }
}
