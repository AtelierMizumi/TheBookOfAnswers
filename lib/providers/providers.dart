import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import '../models/environment.dart';
import '../data/answers_db.dart';

class EnvironmentNotifier extends Notifier<SanctumEnv> {
  @override
  SanctumEnv build() {
    // Persist the chosen sanctum across sessions
    final box = Hive.box('settings');
    final saved = box.get('sanctum_env', defaultValue: 'fireplace') as String;
    return SanctumEnv.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => SanctumEnv.fireplace,
    );
  }

  void setEnv(SanctumEnv env) {
    state = env;
    Hive.box('settings').put('sanctum_env', env.name);
  }
}

final environmentProvider = NotifierProvider<EnvironmentNotifier, SanctumEnv>(() {
  return EnvironmentNotifier();
});

// --- Visitor Counter (local, Hive-based) ---
class VisitorCounterNotifier extends Notifier<int> {
  @override
  int build() {
    final box = Hive.box('settings');
    // Increment on first build (i.e., each app session)
    final count = (box.get('visitor_count', defaultValue: 0) as int) + 1;
    box.put('visitor_count', count);
    return count;
  }
}

final visitorCounterProvider = NotifierProvider<VisitorCounterNotifier, int>(() {
  return VisitorCounterNotifier();
});

final currentEnvironmentProvider = Provider<SanctumEnvironment>((ref) {
  final env = ref.watch(environmentProvider);
  return Environments.get(env);
});

class CurrentTomeNotifier extends Notifier<Tome> {
  @override
  Tome build() => AnswersDB.books.first;

  void setTome(Tome tome) {
    state = tome;
  }
}

final currentTomeProvider = NotifierProvider<CurrentTomeNotifier, Tome>(() {
  return CurrentTomeNotifier();
});

// --- Oracle Ritual State ---
enum OraclePhase { idle, charging, charged, revealing, revealed }

class OracleState {
  final OraclePhase phase;
  final Answer? currentAnswer;
  final double chargeProgress;

  const OracleState({
    required this.phase,
    this.currentAnswer,
    this.chargeProgress = 0.0,
  });

  OracleState copyWith({
    OraclePhase? phase,
    Answer? currentAnswer,
    double? chargeProgress,
  }) {
    return OracleState(
      phase: phase ?? this.phase,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      chargeProgress: chargeProgress ?? this.chargeProgress,
    );
  }
}

class OracleNotifier extends Notifier<OracleState> {
  @override
  OracleState build() => const OracleState(phase: OraclePhase.idle);

  void startCharging() {
    state = state.copyWith(phase: OraclePhase.charging, chargeProgress: 0.0);
  }

  void updateCharge(double progress) {
    if (state.phase == OraclePhase.charging) {
      state = state.copyWith(chargeProgress: progress);
    }
  }

  void cancelCharge() {
    state = const OracleState(phase: OraclePhase.idle);
  }

  void completeCharge() {
    state = state.copyWith(phase: OraclePhase.charged, chargeProgress: 1.0);
  }

  void revealAnswer(Answer answer) {
    state = state.copyWith(phase: OraclePhase.revealing, currentAnswer: answer);
  }

  void finishReveal() {
    state = state.copyWith(phase: OraclePhase.revealed);
  }

  void reset() {
    state = const OracleState(phase: OraclePhase.idle);
  }
}

final oracleProvider = NotifierProvider<OracleNotifier, OracleState>(() {
  return OracleNotifier();
});

// --- Journal Provider ---
class JournalNotifier extends Notifier<List<JournalEntry>> {
  @override
  List<JournalEntry> build() {
    final box = Hive.box('journal');
    final List<JournalEntry> entries = [];
    
    // Load from Hive
    for (var i = 0; i < box.length; i++) {
      final item = box.getAt(i) as Map<dynamic, dynamic>?;
      if (item != null) {
        entries.add(JournalEntry.fromMap(item));
      }
    }
    
    // Sort by newest first
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  void addEntry(JournalEntry entry) {
    state = [entry, ...state];
    _saveToHive();
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
    _saveToHive();
  }

  void clear() {
    state = [];
    _saveToHive();
  }
  
  void _saveToHive() {
    final box = Hive.box('journal');
    box.clear(); // Overwrite all
    for (var entry in state) {
      box.add(entry.toMap());
    }
  }
}

final journalProvider = NotifierProvider<JournalNotifier, List<JournalEntry>>(() {
  return JournalNotifier();
});
