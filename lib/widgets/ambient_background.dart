import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/environment.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
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

    // Environment-specific architectural hints (faint)
    final archPaint = Paint()
      ..color = AppTheme.voidColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (env.id == SanctumEnv.fireplace) {
      // Faint brick pattern
      for (double y = 0; y < size.height; y += 32) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), archPaint);
        double offset = (y % 64 == 0) ? 0 : 32;
        for (double x = offset; x < size.width; x += 64) {
          canvas.drawLine(Offset(x, y), Offset(x, y + 32), archPaint);
        }
      }
    } else if (env.id == SanctumEnv.library) {
      // Faint bookshelves
      for (double x = 40; x < size.width; x += 80) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), archPaint);
        for (double y = 60; y < size.height; y += 60) {
           canvas.drawLine(Offset(x, y), Offset(x + 80, y), archPaint);
        }
      }
    } else if (env.id == SanctumEnv.church) {
      // Faint gothic arches
      for (double x = 60; x < size.width; x += 120) {
        final rect = Rect.fromLTWH(x, 40, 80, size.height - 40);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(40)), archPaint);
      }
    }

    // Gradient glow from bottom
    final rect = Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          env.primaryAmbient.withOpacity(0.15),
          env.primaryAmbient.withOpacity(0.4), // slightly stronger glow
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Parallax Particles (Dust/Ash)
    final rand = Random(42); // deterministic spawn
    
    // Draw 60 particles total, divided into 2 layers
    for (int i = 0; i < 60; i++) {
        bool isForeground = i < 20; // 20 fast/big, 40 slow/small
        
        double x = rand.nextDouble() * size.width;
        double startY = rand.nextDouble() * size.height;
        
        // Drift logic
        double baseSpeed = isForeground ? 2.0 : 0.8;
        if (env.id == SanctumEnv.fireplace) {
          baseSpeed *= 2.5; // Ashes rise much faster
        } else if (env.id == SanctumEnv.library) {
          x += (tick * baseSpeed * 0.5) % size.width; // dust drifts sideways
        }

        double y = startY - ((tick * baseSpeed) % size.height);
        if (y < 0) y += size.height;
        if (x > size.width) x -= size.width;

        double alpha = (rand.nextDouble() * 0.4 + 0.1) * (isForeground ? 1.0 : 0.5);
        
        // Flicker on twos
        if (tick % 2 == 0) {
          alpha *= 0.7;
        }

        final sizePx = isForeground ? (rand.nextDouble() > 0.8 ? 6.0 : 4.0) : 2.0;

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
