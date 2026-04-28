import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/environment.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

class JournalTab extends ConsumerWidget {
  const JournalTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('✎ Your Journal', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 16),
        Text('answers the universe\ndeemed worthy of remembrance', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.ash)),
        const SizedBox(height: 32),
        const Text('── ✦ ──', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.iron, letterSpacing: 8)),
        const SizedBox(height: 32),
        
        if (journal.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  const Text('·  ◆  ·\n·  ✦  ✦  ·\n  ·  ◆  ·', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.ash, height: 1.5)),
                  const SizedBox(height: 24),
                  const Text('no entries yet', style: TextStyle(color: AppTheme.dust)),
                  const SizedBox(height: 8),
                  const Text('the book awaits your first question', style: TextStyle(color: AppTheme.iron, fontSize: 8)),
                ],
              ),
            ),
          )
        else
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: journal.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.abyss,
                      border: Border.all(color: AppTheme.stone, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (entry.question != null && entry.question!.isNotEmpty) ...[
                          Text('"${entry.question}"', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, color: AppTheme.dust, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 12),
                        ],
                        Text('"${entry.text}"', style: Theme.of(context).textTheme.bodyLarge),
                        if (entry.attribution != null) ...[
                          const SizedBox(height: 8),
                          Text(entry.attribution!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, color: AppTheme.ash)),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.tomeId, style: const TextStyle(color: AppTheme.iron, fontSize: 8)),
                            InkWell(
                              onTap: () {
                                ref.read(journalProvider.notifier).removeEntry(entry.id);
                              },
                              child: const Text('✕ remove', style: TextStyle(color: AppTheme.iron, fontSize: 8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          )
      ],
    );
  }
}
