import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pixel_button.dart';
import '../widgets/ambient_background.dart';
import '../widgets/stepped_animation.dart';
import 'sanctum_screen.dart';

class GateScreen extends StatefulWidget {
  const GateScreen({super.key});

  @override
  State<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends State<GateScreen> {
  bool _isEntering = false;
  
  void _enter() {
    setState(() => _isEntering = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SanctumScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidColor,
      body: Stack(
        children: [
          const AmbientBackground(),
          
          AnimatedOpacity(
            opacity: _isEntering ? 0.0 : 1.0,
            duration: const Duration(seconds: 2),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Candles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _Candle(),
                        SizedBox(width: 80),
                        _Candle(),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Title
                    Text(
                      'The Book\nof Answers',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        shadows: [
                          const Shadow(
                            color: AppTheme.ink,
                            offset: Offset(4, 4),
                          ),
                          Shadow(
                            color: AppTheme.gold.withOpacity(0.15),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    Text(
                      '"Between the lines, wisdom breathes."',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppTheme.dust,
                        fontSize: 20,
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    Text('── ✦ ──', style: TextStyle(color: AppTheme.iron, letterSpacing: 8)),
                    const SizedBox(height: 32),
                    
                    Text('Enter the sanctum', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.ash)),
                    const SizedBox(height: 16),
                    
                    PixelButton(
                      text: '⊹ ENTER ⊹',
                      onPressed: _enter,
                    ),
                    
                    const SizedBox(height: 64),
                    Text('you are visitor no. 43,564\nlast offering: anno domini MMXXVI', 
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.iron, 
                        fontSize: 8,
                        height: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Candle extends StatelessWidget {
  const _Candle();

  @override
  Widget build(BuildContext context) {
    return AmbientStepper(
      fps: 4, // 4fps flicker for candle
      builder: (context, tick) {
        
        final heightMod = (tick % 4 == 0) ? 8.0 : (tick % 2 == 0 ? 10.0 : 7.0);
        final opacity = (tick % 3 == 0) ? 0.9 : 1.0;
        
        return Column(
          children: [
            Container(
              width: 8,
              height: heightMod,
              decoration: BoxDecoration(
                color: AppTheme.candlelight.withOpacity(opacity),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                boxShadow: [
                  BoxShadow(color: AppTheme.candlelight.withOpacity(0.6), blurRadius: 10, spreadRadius: 2),
                ],
              ),
            ),
            Container(width: 2, height: 4, color: AppTheme.iron),
            Container(width: 12, height: 24, color: AppTheme.parchment),
          ],
        );
      },
    );
  }
}
