import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../data/answers_db.dart';
import '../providers/providers.dart';

class TomesTab extends ConsumerWidget {
  const TomesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTome = ref.watch(currentTomeProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('❧ The Library of Tomes', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 16),
        Text('choose the book that speaks\nto your present condition', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.ash)),
        const SizedBox(height: 32),
        const Text('── ✦ ──', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.iron, letterSpacing: 8)),
        const SizedBox(height: 32),
        
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: AnswersDB.books.map((tome) {
                final isActive = tome.id == currentTome.id;
                return InkWell(
                  onTap: () {
                    ref.read(currentTomeProvider.notifier).setTome(tome);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.deep : AppTheme.abyss,
                      border: Border.all(color: isActive ? AppTheme.gold : AppTheme.stone, width: 2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tome.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tome.name, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
                              const SizedBox(height: 8),
                              Text(tome.desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.ash)),
                              const SizedBox(height: 8),
                              Text('${AnswersDB.answers[tome.id]?.length ?? 0} pages', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.iron, fontSize: 8)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
