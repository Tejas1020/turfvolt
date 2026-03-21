import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Dribbble-inspired mesh gradient background with floating orbs
/// Creates a premium, atmospheric feel with soft glowing blobs
class MeshGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? orbColors;

  const MeshGradientBackground({
    super.key,
    required this.child,
    this.orbColors,
  });

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Orb> _orbs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    final colors = widget.orbColors ?? [
      AppColors.orbCoral,
      AppColors.orbPurple,
      AppColors.orbOrange,
      AppColors.orbLime,
    ];

    _orbs = List.generate(colors.length, (i) => _Orb(
      color: colors[i],
      initialX: math.Random().nextDouble(),
      initialY: math.Random().nextDouble(),
      speedX: (math.Random().nextDouble() - 0.5) * 0.0003,
      speedY: (math.Random().nextDouble() - 0.5) * 0.0003,
      size: 200 + math.Random().nextDouble() * 150,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.deepSpace,
                AppColors.midnightPurple,
                AppColors.deepSpace,
              ],
            ),
          ),
        ),
        // Animated floating orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _OrbsPainter(orbs: _orbs, progress: _controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _Orb {
  final Color color;
  final double initialX;
  final double initialY;
  final double speedX;
  final double speedY;
  final double size;

  _Orb({
    required this.color,
    required this.initialX,
    required this.initialY,
    required this.speedX,
    required this.speedY,
    required this.size,
  });
}

class _OrbsPainter extends CustomPainter {
  final List<_Orb> orbs;
  final double progress;

  _OrbsPainter({required this.orbs, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      final x = (orb.initialX + orb.speedX * progress * 1000) % 1.5 - 0.25;
      final y = (orb.initialY + orb.speedY * progress * 1000) % 1.5 - 0.25;

      final center = Offset(x * size.width, y * size.height);
      final radius = orb.size;

      final gradient = RadialGradient(
        colors: [
          orb.color,
          orb.color.withAlpha(0),
        ],
        stops: const [0.0, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        );

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
