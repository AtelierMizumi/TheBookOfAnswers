import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../theme/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/pixel_button.dart';
import 'gate_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const _slides = [
    _OnboardingSlide(
      symbol: '❧',
      title: 'Six Mystical Tomes',
      body:
          'Choose the book that speaks to your present condition.\n\n'
          'Each Tome holds wisdom for a different facet of life — '
          'from love and courage, to harsh truths and the void of chaos.',
      hint: '── ✦ ──',
    ),
    _OnboardingSlide(
      symbol: '◆',
      title: 'The Ritual',
      body:
          'Place your hand upon the book and hold.\n\n'
          'The oracle does not answer the impatient. '
          'Hold for three seconds, and the page shall reveal itself.',
      hint: '── ◆ ──',
    ),
    _OnboardingSlide(
      symbol: '✎',
      title: 'Your Keep',
      body:
          'Save your most profound revelations to your Journal.\n\n'
          'Your entries are kept locally — '
          'private to you, preserved across every session.',
      hint: '── ✦ ──',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _fadeController.reverse().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _fadeController.forward();
      });
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    Hive.box('settings').put('onboarding_done', true);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const GateScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(seconds: 1),
      ),
    );
  }

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
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: _completeOnboarding,
                      child: Text(
                        'skip ›',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.ash,
                              fontSize: 8,
                            ),
                      ),
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      _fadeController.forward(from: 0);
                    },
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildSlide(_slides[index]),
                      );
                    },
                  ),
                ),

                // Progress dots + button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                  child: Column(
                    children: [
                      // Dot indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_slides.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _currentPage ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _currentPage
                                  ? AppTheme.gold
                                  : AppTheme.stone,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),
                      PixelButton(
                        text: _currentPage < _slides.length - 1
                            ? 'Next ›'
                            : '⊹ Enter the Sanctum ⊹',
                        isAccent: _currentPage == _slides.length - 1,
                        onPressed: _nextPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(_OnboardingSlide slide) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ornamental symbol
              Text(
                slide.symbol,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 72,
                      color: AppTheme.gold,
                      shadows: [
                        Shadow(
                          color: AppTheme.gold.withOpacity(0.3),
                          blurRadius: 24,
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: 32),
              Text(
                slide.hint,
                style: const TextStyle(color: AppTheme.iron, letterSpacing: 8),
              ),
              const SizedBox(height: 32),
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                    ),
              ),
              const SizedBox(height: 32),
              Text(
                slide.body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: AppTheme.dust,
                      height: 1.8,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final String symbol;
  final String title;
  final String body;
  final String hint;

  const _OnboardingSlide({
    required this.symbol,
    required this.title,
    required this.body,
    required this.hint,
  });
}
