import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Soft neumorphic card: raised surface with subtle light/dark shadows.
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final bool flat; // true = inset look, false = raised (default)

  const NeumorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.flat = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.neumoBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: flat ? AppColors.neumoShadow : AppColors.neumoHighlight,
          width: 0.5,
        ),
        boxShadow: [
          if (!flat) ...[
            BoxShadow(
              color: AppColors.neumoHighlight.withOpacity(0.25),
              offset: const Offset(-2, -2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.neumoShadow.withOpacity(0.4),
              offset: const Offset(2, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ],
      ),
      child: child,
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
