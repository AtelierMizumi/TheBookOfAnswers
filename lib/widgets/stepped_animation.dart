import 'package:flutter/material.dart';

/// Wraps an animation value to step discretely at a simulated framerate.
/// E.g., setting [fps] to 12 makes a smooth 60fps animation look like
/// it's animating "on twos" (12 frames per second).
class SteppedAnimationWrapper extends StatefulWidget {
  final Animation<double> animation;
  final int fps;
  final Widget Function(BuildContext context, double steppedValue, Widget? child) builder;
  final Widget? child;

  const SteppedAnimationWrapper({
    super.key,
    required this.animation,
    required this.builder,
    this.fps = 12,
    this.child,
  });

  @override
  State<SteppedAnimationWrapper> createState() => _SteppedAnimationWrapperState();
}

class _SteppedAnimationWrapperState extends State<SteppedAnimationWrapper> {
  double _lastSteppedValue = 0.0;
  DateTime _lastStepTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _lastSteppedValue = widget.animation.value;
    widget.animation.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.animation.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    final now = DateTime.now();
    final msPerFrame = 1000 / widget.fps;
    
    if (now.difference(_lastStepTime).inMilliseconds >= msPerFrame || widget.animation.isCompleted || widget.animation.isDismissed) {
      if (_lastSteppedValue != widget.animation.value) {
        setState(() {
          _lastSteppedValue = widget.animation.value;
          _lastStepTime = now;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _lastSteppedValue, widget.child);
  }
}

/// A continuously stepping controller for ambient loops at given FPS
class AmbientStepper extends StatefulWidget {
  final int fps;
  final Widget Function(BuildContext context, int frameTick) builder;

  const AmbientStepper({super.key, required this.fps, required this.builder});

  @override
  State<AmbientStepper> createState() => _AmbientStepperState();
}

class _AmbientStepperState extends State<AmbientStepper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _tick = 0;
  DateTime _lastTick = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _controller.addListener(() {
      final now = DateTime.now();
      if (now.difference(_lastTick).inMilliseconds > 1000 / widget.fps) {
        if (mounted) {
          setState(() {
            _tick++;
            _lastTick = now;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _tick);
  }
}
