import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

/// Premium shimmer effect widget for loading states
/// Creates a smooth gradient animation that sweeps across the child
class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  const Shimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 0.5, 0),
              colors: [
                widget.baseColor ?? AppColors.cardBg,
                widget.highlightColor ?? AppColors.shimmerHighlight,
                widget.baseColor ?? AppColors.cardBg,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Shimmer loading placeholder for text
class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerText({
    super.key,
    this.width = 100,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder for cards
class ShimmerCard extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const ShimmerCard({
    super.key,
    this.height = 120,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            ShimmerText(width: 120, height: 14),
            const SizedBox(height: 8),
            ShimmerText(width: 80, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder for circular avatars/images
class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({
    super.key,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder for list items
class ShimmerListItem extends StatelessWidget {
  final double height;

  const ShimmerListItem({
    super.key,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ShimmerCircle(size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(width: 100, height: 14),
                  const SizedBox(height: 8),
                  ShimmerText(width: 60, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder for grid items
class ShimmerGridItem extends StatelessWidget {
  final double aspectRatio;

  const ShimmerGridItem({
    super.key,
    this.aspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

/// Shimmer loading for stat cards
class ShimmerStatCard extends StatelessWidget {
  const ShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerCircle(size: 24),
            const SizedBox(height: 12),
            ShimmerText(width: 60, height: 20),
            const SizedBox(height: 4),
            ShimmerText(width: 40, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for buttons
class ShimmerButton extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerButton({
    super.key,
    this.width = 120,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
