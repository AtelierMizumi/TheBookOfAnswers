import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../models/models.dart';
import '../models/environment.dart';
import '../providers/providers.dart';
import 'oracle_tab.dart';
import 'tomes_tab.dart';
import 'journal_tab.dart';

class SanctumScreen extends StatefulWidget {
  const SanctumScreen({super.key});

  @override
  State<SanctumScreen> createState() => _SanctumScreenState();
}

class _SanctumScreenState extends State<SanctumScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidColor,
      body: Stack(
        children: [
          const AmbientBackground(),
          
          SafeArea(
            child: Column(
              children: [
                // Ribbon Navigation & Environment Selector
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppTheme.stone, width: 2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Space placeholder for centering nav
                      const Spacer(),
                      
                      // Nav
                      Row(
                        children: [
                          _RibbonTab(title: '◆ Oracle', isActive: _currentIndex == 0, onTap: () => setState(() => _currentIndex = 0)),
                          const Text(' · ', style: TextStyle(color: AppTheme.iron)),
                          _RibbonTab(title: '❧ Tomes', isActive: _currentIndex == 1, onTap: () => setState(() => _currentIndex = 1)),
                          const Text(' · ', style: TextStyle(color: AppTheme.iron)),
                          _RibbonTab(title: '✎ Journal', isActive: _currentIndex == 2, onTap: () => setState(() => _currentIndex = 2)),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Environment Selector
                      Consumer(
                        builder: (context, ref, child) {
                          final currentEnv = ref.watch(environmentProvider);
                          return PopupMenuButton<SanctumEnv>(
                            color: AppTheme.deep,
                            initialValue: currentEnv,
                            onSelected: (env) {
                              ref.read(environmentProvider.notifier).setEnv(env);
                            },
                            itemBuilder: (context) {
                              return Environments.all.map((env) {
                                return PopupMenuItem(
                                  value: env.id,
                                  child: Text(
                                    env.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: env.id == currentEnv ? AppTheme.gold : AppTheme.parchment,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            child: Row(
                              children: [
                                Text(Environments.get(currentEnv).name, style: const TextStyle(color: AppTheme.ash, fontSize: 8)),
                                const SizedBox(width: 4),
                                const Text('▼', style: TextStyle(color: AppTheme.iron, fontSize: 8)),
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
                
                // Content Switcher
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: const [
                      OracleTab(),
                      TomesTab(),
                      JournalTab(),
                    ],
                  ),
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('⊹ crafted in the old way ⊹', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.ash, fontSize: 8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RibbonTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _RibbonTab({required this.title, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isActive ? AppTheme.gold : Colors.transparent, width: 2)),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isActive ? AppTheme.candlelight : AppTheme.dust,
            ),
          ),
        ),
      ),
    );
  }
}
