import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Gradient text widget for headlines and CTAs
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient? gradient;
  final TextAlign? textAlign;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient,
    this.textAlign,
  });

  /// Coral to Orange gradient (default)
  factory GradientText.coralOrange(String text, {TextStyle? style, TextAlign? textAlign}) {
    return GradientText(
      text: text,
      style: style,
      gradient: AppColors.primaryGradient,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => (gradient ?? AppColors.primaryGradient).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
        textAlign: textAlign,
      ),
    );
  }
}
