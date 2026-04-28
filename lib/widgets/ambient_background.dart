import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/environment.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'stepped_animation.dart';

class AmbientBackground extends ConsumerWidget {
  const AmbientBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(currentEnvironmentProvider);

    return AmbientStepper(
      fps: 12, // 12fps for background environment
      builder: (context, tick) {
        return CustomPaint(
          painter: _EnvironmentPainter(env, tick),
          size: Size.infinite,
        );
      },
    );
  }
}

class _EnvironmentPainter extends CustomPainter {
  final SanctumEnvironment env;
  final int tick;
  
  // Use a seeded random based on tick for deterministic particle jitter 
  // or use stateful particles. For simple pixel motes, a hash based on index and tick works.
  _EnvironmentPainter(this.env, this.tick);

  @override
  void paint(Canvas canvas, Size size) {
    // Fill base
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = env.secondaryAmbient.withOpacity(0.5),
    );

    // Gradient glow from bottom
    final rect = Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          env.primaryAmbient.withOpacity(0.15),
          env.primaryAmbient.withOpacity(0.3),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Particles (Dust/Ash)
    final rand = Random(42); // deterministic spawn
    for (int i = 0; i < 40; i++) {
        double x = rand.nextDouble() * size.width;
        double startY = rand.nextDouble() * size.height;
        
        // Drift logic
        double driftSpeed = 1.0;
        if (env.id == SanctumEnv.fireplace) {
          driftSpeed = 3.0; // Ashes rise faster
        }

        double y = startY - ((tick * driftSpeed) % size.height);
        if (y < 0) y += size.height;

        double alpha = rand.nextDouble() * 0.5 + 0.1;
        
        // Flicker on twos
        if (tick % 2 == 0) {
          alpha *= 0.8;
        }

        final sizePx = rand.nextDouble() > 0.8 ? 4.0 : 2.0;

        canvas.drawRect(
          Rect.fromLTWH(x, y, sizePx, sizePx),
          Paint()..color = env.primaryAmbient.withOpacity(alpha),
        );
    }
  }

  @override
  bool shouldRepaint(covariant _EnvironmentPainter oldDelegate) {
    return oldDelegate.tick != tick || oldDelegate.env != env;
  }
}
