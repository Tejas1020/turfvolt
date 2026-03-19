import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Skeleton loader with shimmer effect - replaces CircularProgressIndicator
/// Provides perceived faster load times and better UX
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Duration duration;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          color: AppColors.cardBg,
          gradient: LinearGradient(
            begin: Alignment(_animation.value, 0),
            end: Alignment(_animation.value + 0.5, 0),
            colors: [
              AppColors.cardBg,
              AppColors.neumoHighlight,
              AppColors.cardBg,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

/// Pre-built skeleton shapes for common UI patterns
class SkeletonShapes {
  /// Card skeleton - matches final card shape
  static Widget card({double height = 120}) => SkeletonLoader(
    height: height,
    borderRadius: BorderRadius.circular(16),
  );

  /// Avatar circle skeleton
  static Widget avatar({double size = 48}) => SkeletonLoader(
    width: size,
    height: size,
    borderRadius: BorderRadius.circular(size / 2),
  );

  /// Text line skeleton
  static Widget textLine({double width = 200, double height = 14}) =>
      SkeletonLoader(width: width, height: height);

  /// Multiple lines for text blocks
  static Widget textBlock({int lines = 3}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(
      lines,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SkeletonLoader(
          width: index == lines - 1 ? 120 : double.infinity,
          height: 14,
        ),
      ),
    ),
  );

  /// Stat card skeleton
  static Widget statCard() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SkeletonLoader(width: 40, height: 40, borderRadius: BorderRadius.circular(8)),
      const SizedBox(height: 12),
      SkeletonLoader(width: 60, height: 24),
      const SizedBox(height: 4),
      SkeletonLoader(width: 40, height: 14),
    ],
  );

  /// List item skeleton
  static Widget listItem() => Row(
    children: [
      SkeletonLoader(width: 48, height: 48, borderRadius: BorderRadius.circular(12)),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(width: 120, height: 16),
            const SizedBox(height: 6),
            SkeletonLoader(width: 80, height: 12),
          ],
        ),
      ),
    ],
  );
}
