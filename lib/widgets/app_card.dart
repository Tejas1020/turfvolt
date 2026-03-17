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
      color: AppColors.neumoBg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
      boxShadow: [
        BoxShadow(
          color: AppColors.neumoHighlight.withOpacity(0.2),
          offset: const Offset(-2, -2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.neumoShadow.withOpacity(0.35),
          offset: const Offset(2, 2),
          blurRadius: 6,
          spreadRadius: 0,
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
