import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

enum ButtonSize { normal, small, large }

class LimeButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final double? opacity;

  const LimeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.normal,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
    this.opacity,
  });

  @override
  State<LimeButton> createState() => _LimeButtonState();
}

class _LimeButtonState extends State<LimeButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final padding = switch (widget.size) {
      ButtonSize.small => const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ButtonSize.large => const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      ButtonSize.normal => const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    };

    final fontSize = switch (widget.size) {
      ButtonSize.small => 12.0,
      ButtonSize.large => 16.0,
      ButtonSize.normal => 14.0,
    };

    final height = switch (widget.size) {
      ButtonSize.small => 36.0,
      ButtonSize.large => 52.0,
      ButtonSize.normal => 44.0,
    };

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: widget.opacity ?? 1.0,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.summerOrange,
              foregroundColor: Colors.white,
              padding: padding,
              minimumSize: Size(widget.fullWidth ? double.infinity : 0, height),
              elevation: 4,
              shadowColor: AppColors.warmCoral.withAlpha(102),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.dmSans(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      Text(widget.label, style: TextStyle(color: Colors.white)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
