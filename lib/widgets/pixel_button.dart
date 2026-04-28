import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PixelButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isAccent;

  const PixelButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isAccent = false,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isAccent ? AppTheme.gold.withOpacity(0.5) : AppTheme.deep;
    final hoverColor = widget.isAccent ? AppTheme.gold : AppTheme.stone;
    final textColor = widget.isAccent ? (_isHovered ? AppTheme.voidColor : AppTheme.candlelight) : (_isHovered ? AppTheme.candlelight : AppTheme.bone);
    final borderColor = _isHovered ? (widget.isAccent ? AppTheme.candlelight : AppTheme.gold.withOpacity(0.5)) : AppTheme.iron;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Transform.translate(
          offset: Offset(_isPressed ? 2 : 0, _isPressed ? 2 : 0),
          child: Container(
            decoration: BoxDecoration(
              color: _isHovered ? hoverColor : bgColor,
              border: Border.all(color: borderColor, width: 4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    letterSpacing: 2.0,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
