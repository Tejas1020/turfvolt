import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColors.borderDefault, width: 0.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(51),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    );
    final container = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }
    return container;
  }
}
