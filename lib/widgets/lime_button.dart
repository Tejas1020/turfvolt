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
  final Gradient? gradient;

  const LimeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.normal,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
    this.gradient,
  });

  @override
  State<LimeButton> createState() => _LimeButtonState();
}

class _LimeButtonState extends State<LimeButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      _animationController.reverse();
    }
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

    final effectiveGradient = widget.gradient ?? AppColors.primaryGradient;

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
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          height: height,
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.vibrantCoral.withAlpha(77),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: padding,
                child: widget.isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.label,
                            style: GoogleFonts.dmSans(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
