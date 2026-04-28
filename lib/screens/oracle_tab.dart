import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../data/answers_db.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/pixel_button.dart';

class OracleTab extends ConsumerStatefulWidget {
  const OracleTab({super.key});

  @override
  ConsumerState<OracleTab> createState() => _OracleTabState();
}

class _OracleTabState extends ConsumerState<OracleTab> with SingleTickerProviderStateMixin {
  late AnimationController _chargeController;
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargeController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3));

    _chargeController.addListener(() {
      ref.read(oracleProvider.notifier).updateCharge(_chargeController.value);
    });

    _chargeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onCharged();
      }
    });
  }

  @override
  void dispose() {
    _chargeController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerEvent details) {
    if (ref.read(oracleProvider).phase != OraclePhase.idle) return;
    
    // Unfocus text field
    FocusScope.of(context).unfocus();
    
    ref.read(oracleProvider.notifier).startCharging();
    _chargeController.forward(from: 0);
  }

  void _onPointerUp(PointerEvent details) {
    if (ref.read(oracleProvider).phase == OraclePhase.charging) {
      _chargeController.stop();
      ref.read(oracleProvider.notifier).cancelCharge();
    }
  }

  void _onCharged() {
    final oracleNode = ref.read(oracleProvider.notifier);
    oracleNode.completeCharge();

    // Flash and move to reveal
    Future.delayed(const Duration(milliseconds: 1200), () {
      final tome = ref.read(currentTomeProvider);
      final answers = AnswersDB.getAnswersFor(tome.id);
      final random = Random().nextInt(answers.length);
      
      oracleNode.revealAnswer(answers[random]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final oracleState = ref.watch(oracleProvider);
    final isRevealedView = oracleState.phase == OraclePhase.revealed || oracleState.phase == OraclePhase.revealing;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isRevealedView) ...[
                _buildQuestionInput(),
                const SizedBox(height: 48),
                _buildTheBook(oracleState),
              ] else ...[
                _buildAnswerPage(oracleState),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionInput() {
    return Column(
      children: [
        const Text('─── whisper your question ───', style: TextStyle(color: AppTheme.iron, fontSize: 8, letterSpacing: 2)),
        const SizedBox(height: 16),
        TextField(
          controller: _questionController,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
          decoration: const InputDecoration(
            hintText: 'what weighs upon your mind...',
            hintStyle: TextStyle(color: AppTheme.iron, fontStyle: FontStyle.italic),
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }

  Widget _buildTheBook(OracleState state) {
    final isCharging = state.phase == OraclePhase.charging;
    final isCharged = state.phase == OraclePhase.charged;

    return Column(
      children: [
        // Pixel Art Book Placeholder
        Container(
          width: 160,
          height: 200,
          decoration: BoxDecoration(
            color: AppTheme.deep,
            border: Border.all(color: AppTheme.iron, width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('┌─────────┐\n│  ✦   ✦  │\n│    ◆    │\n│  ✦   ✦  │\n└─────────┘', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.iron, height: 1.2)),
              const SizedBox(height: 16),
              Text('LIBER\nRESPONSORUM', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.dust)),
            ],
          ),
        ),
        const SizedBox(height: 48),
        
        // Hold Area
        Listener(
          onPointerDown: _onPointerDown,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerUp,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                border: Border.all(color: isCharging ? AppTheme.gold : AppTheme.iron, width: 4),
                boxShadow: isCharged ? [BoxShadow(color: AppTheme.candlelight, blurRadius: 10)] : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: isCharging ? AppTheme.deep : AppTheme.abyss,
                  alignment: Alignment.center,
                  child: Text(
                    isCharged ? '✦' : (isCharging ? '· · ·' : 'HOLD'),
                    style: TextStyle(color: isCharging ? AppTheme.gold : AppTheme.dust, letterSpacing: 4),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Progress Bar
        Container(
          width: 120,
          height: 8,
          decoration: BoxDecoration(border: Border.all(color: AppTheme.stone, width: 2)),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: (state.chargeProgress * 10).floor() / 10, // Stepped!
            child: Container(color: AppTheme.gold),
          ),
        ),
        const SizedBox(height: 16),
        
        // Instruction
        Text(
          isCharged ? 'the book opens...' : (isCharging ? 'channeling...' : 'place your hand upon the book\nand hold until the page reveals itself'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.ash, height: 2),
        ),
      ],
    );
  }

  Widget _buildAnswerPage(OracleState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.abyss,
        border: Border.all(color: AppTheme.iron, width: 2),
      ),
      child: Column(
        children: [
          const Text('── ✦ ──', style: TextStyle(color: AppTheme.iron, letterSpacing: 8)),
          const SizedBox(height: 48),
          
          if (state.currentAnswer != null)
            TypewriterText(
              text: state.currentAnswer!.text,
              style: Theme.of(context).textTheme.bodyLarge,
              onComplete: () {
                ref.read(oracleProvider.notifier).finishReveal();
              },
            ),
          
          if (state.phase == OraclePhase.revealed && state.currentAnswer?.attribution != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(state.currentAnswer!.attribution!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, color: AppTheme.dust)),
            ),

          const SizedBox(height: 48),
          const Text('── ◆ ──', style: TextStyle(color: AppTheme.iron, letterSpacing: 8)),
          
          if (state.phase == OraclePhase.revealed) ...[
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                PixelButton(text: '☆ Save', onPressed: () {
                  if (state.currentAnswer != null) {
                    final tome = ref.read(currentTomeProvider);
                    final entry = JournalEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      question: _questionController.text.isEmpty ? "What weighs upon your mind..." : _questionController.text,
                      text: state.currentAnswer!.text,
                      attribution: state.currentAnswer!.attribution,
                      tomeId: tome.id,
                      timestamp: DateTime.now().millisecondsSinceEpoch,
                    );
                    ref.read(journalProvider.notifier).addEntry(entry);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Saved to Journal', style: TextStyle(color: AppTheme.dust)),
                        backgroundColor: AppTheme.deep,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }),
                PixelButton(text: '↺ Ask Again', isAccent: true, onPressed: () {
                  ref.read(oracleProvider.notifier).reset();
                  _questionController.clear();
                }),
              ],
            )
          ]
        ],
      ),
    );
  }
}
