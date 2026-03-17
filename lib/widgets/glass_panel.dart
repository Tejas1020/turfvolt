import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Minimal glass panel: frosted blur + subtle fill and border.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final double blurSigma;
  final Color? fillColor;
  final Color? borderColor;

  const GlassPanel({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.blurSigma = 8,
    this.fillColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fillColor ?? AppColors.glassFill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
