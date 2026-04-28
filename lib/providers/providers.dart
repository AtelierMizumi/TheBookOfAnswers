import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../models/environment.dart';
import '../data/answers_db.dart';

// --- Environment Provider ---
final environmentProvider = StateProvider<SanctumEnv>((ref) => SanctumEnv.fireplace);

final currentEnvironmentProvider = Provider<SanctumEnvironment>((ref) {
  final env = ref.watch(environmentProvider);
  return Environments.get(env);
});

// --- Tome Provider ---
final currentTomeProvider = StateProvider<Tome>((ref) => AnswersDB.books.first);

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

class OracleNotifier extends StateNotifier<OracleState> {
  OracleNotifier() : super(const OracleState(phase: OraclePhase.idle));

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

final oracleProvider = StateNotifierProvider<OracleNotifier, OracleState>((ref) {
  return OracleNotifier();
});

// --- Journal Provider ---
class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier() : super([]);

  // TODO: Sync with Hive

  void addEntry(JournalEntry entry) {
    state = [entry, ...state];
  }

  void clear() {
    state = [];
  }
}

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) {
  return JournalNotifier();
});
