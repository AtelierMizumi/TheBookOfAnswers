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

  static const Map<String, List<Answer>> answers = {
    'universal': [
      Answer(text: "It is certain."),
      Answer(text: "Patience will reveal what rushing hides.", weight: 7),
      Answer(text: "The path is obscured; re-evaluate your steps.", weight: 6),
      Answer(text: "Without a doubt, but at a cost.", weight: 4),
      Answer(text: "Let go of the outcome, and it will be yours.", weight: 8),
      // Adding a few more for testing
      Answer(text: "Trust the unseen current.", weight: 5),
    ],
    'love': [
      Answer(text: "The heart knows what the mind denies."),
      Answer(text: "Distance illuminates the truth of connection.", weight: 7),
      Answer(text: "To hold tighter is to push away.", weight: 8),
      Answer(text: "A new presence approaches.", weight: 6),
      Answer(text: "Heal thyself before seeking another.", weight: 9),
    ],
    'fire': [
      Answer(text: "Strike while the iron is hot."),
      Answer(text: "Hesitation is the enemy of progress.", weight: 8),
      Answer(text: "Burn the bridges that lead backward.", weight: 7),
      Answer(text: "Ignite. Do not wait for permission.", weight: 6),
      Answer(text: "Your ambition is a weapon; wield it.", weight: 5),
    ],
    'brutal': [
      Answer(text: "You already know the answer. Stop asking."),
      Answer(text: "Your ego is blinding your judgment.", weight: 8),
      Answer(text: "No. And it is entirely your fault.", weight: 9),
      Answer(text: "This obsession serves nothing.", weight: 7),
      Answer(text: "What you seek is irrelevant.", weight: 6),
    ],
    'midnight': [
      Answer(text: "The silence speaks louder than words."),
      Answer(text: "Answers fade as the dawn approaches.", weight: 6),
      Answer(text: "Look inward when the lights go out.", weight: 7),
    ],
    'chaos': [
      Answer(text: "Flip a coin. Then ignore it entirely."),
      Answer(text: "The opposite of what you expect is true.", weight: 8),
      Answer(text: "Nothing matters here. Proceed blindly.", weight: 7),
    ],
  };

  static List<Answer> getAnswersFor(String tomeId) {
    List<Answer> pool = List.from(answers[tomeId] ?? answers['universal']!);
    
    // Midnight mode (00:00 - 04:00)
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 4 && tomeId != 'chaos') {
      pool.addAll(midnightSpecials);
    }
    
    return pool;
  }
}
