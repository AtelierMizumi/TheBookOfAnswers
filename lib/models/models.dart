import 'package:flutter/material.dart';

enum SanctumEnv { fireplace, library, church }

class Tome {
  final String id;
  final String name;
  final String emoji;
  final String desc;
  final Color baseColor;

  const Tome({
    required this.id,
    required this.name,
    required this.emoji,
    required this.desc,
    required this.baseColor,
  });
}

class Answer {
  final String text;
  final String? attribution;
  final int weight;

  const Answer({
    required this.text,
    this.attribution,
    this.weight = 5,
  });
}

class JournalEntry {
  final String id;
  final String text;
  final String? attribution;
  final String? question;
  final String tomeId;
  final int timestamp;

  const JournalEntry({
    required this.id,
    required this.text,
    this.attribution,
    this.question,
    required this.tomeId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'attribution': attribution,
      'question': question,
      'tomeId': tomeId,
      'timestamp': timestamp,
    };
  }

  factory JournalEntry.fromMap(Map<dynamic, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      text: map['text'] as String,
      attribution: map['attribution'] as String?,
      question: map['question'] as String?,
      tomeId: map['tomeId'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}
