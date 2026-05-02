import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../data/answers_db.dart';

class JournalTab extends ConsumerWidget {
  const JournalTab({super.key});

  /// Format a Unix millisecond timestamp to a readable date string
  String _formatDate(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$min';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('✎ Your Journal', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 16),
        Text(
          'answers the universe\ndeemed worthy of remembrance',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.ash),
        ),
        const SizedBox(height: 12),
        // Revelation count badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.stone, width: 1),
              color: AppTheme.abyss,
            ),
            child: Text(
              journal.isEmpty
                  ? 'no revelations saved'
                  : '${journal.length} revelation${journal.length == 1 ? '' : 's'} preserved',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: journal.isEmpty ? AppTheme.iron : AppTheme.gold,
                    fontSize: 8,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('── ✦ ──', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.iron, letterSpacing: 8)),
        const SizedBox(height: 32),
        
        if (journal.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  const Text(
                    '·  ◆  ·\n·  ✦  ✦  ·\n  ·  ◆  ·',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.ash, height: 1.5),
                  ),
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
                  // Look up tome info for badge
                  final tome = AnswersDB.books.where((t) => t.id == entry.tomeId).firstOrNull;

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
                        // Tome badge row
                        Row(
                          children: [
                            if (tome != null) ...[
                              Text(tome.emoji, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tome.name,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.dust,
                                        fontSize: 8,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ] else ...[
                              Expanded(
                                child: Text(
                                  entry.tomeId,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.iron,
                                        fontSize: 8,
                                      ),
                                ),
                              ),
                            ],
                            // Timestamp
                            Text(
                              _formatDate(entry.timestamp),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.iron,
                                    fontSize: 7,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: AppTheme.stone, height: 1),
                        const SizedBox(height: 12),

                        // Question
                        if (entry.question != null && entry.question!.isNotEmpty) ...[
                          Text(
                            '"${entry.question}"',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  color: AppTheme.dust,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Answer
                        Text('"${entry.text}"', style: Theme.of(context).textTheme.bodyLarge),
                        if (entry.attribution != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            entry.attribution!,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 14,
                                  color: AppTheme.ash,
                                ),
                          ),
                        ],

                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              ref.read(journalProvider.notifier).removeEntry(entry.id);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('✕ remove', style: TextStyle(color: AppTheme.iron, fontSize: 8)),
                            ),
                          ),
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
