import 'package:flutter/material.dart';
import 'dart:async';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int speedMs;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.speedMs = 55,
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  Timer? _timer;
  int _charIndex = 0;
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
    // 2fps cursor blink
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) setState(() => _showCursor = !_showCursor);
    });
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _displayedText = '';
      _charIndex = 0;
      _startTyping();
    }
  }

  void _startTyping() {
    _timer?.cancel();
    _typeNext();
  }

  void _typeNext() {
    if (_charIndex < widget.text.length) {
      final char = widget.text[_charIndex];
      setState(() {
        _displayedText += char;
        _charIndex++;
      });

      // Sound logic could go here

      int delay = widget.speedMs;
      if ('.!?;:—'.contains(char)) {
        delay = 800; // Pause at punctuation
      }

      _timer = Timer(Duration(milliseconds: delay), _typeNext);
    } else {
      widget.onComplete?.call();
      // Hide cursor after a moment
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _cursorTimer?.cancel();
          setState(() => _showCursor = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: widget.style,
        children: [
          TextSpan(text: _displayedText),
          if (_showCursor)
            TextSpan(
              text: ' |',
              style: widget.style?.copyWith(color: Theme.of(context).primaryColor),
            ),
        ],
      ),
    );
  }
}
