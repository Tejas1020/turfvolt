import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Confetti celebration effect for workout completions, PRs, milestones
/// Triggers dopamine response and creates memorable moments
class ConfettiEffect extends StatefulWidget {
  final int particleCount;
  final Duration duration;
  final List<Color>? colors;
  final VoidCallback? onComplete;

  const ConfettiEffect({
    super.key,
    this.particleCount = 50,
    this.duration = const Duration(milliseconds: 2000),
    this.colors,
    this.onComplete,
  });

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect> with TickerProviderStateMixin {
  late List<_Particle> _particles;
  late AnimationController _controller;
  final Random _random = Random();

  final List<Color> _defaultColors = [
    AppColors.summerOrange,
    AppColors.oceanBlue,
    AppColors.success,
    AppColors.sunshineYellow,
    AppColors.skyBlue,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _createParticles();
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  void _createParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      final colorList = widget.colors ?? _defaultColors;
      return _Particle(
        offsetX: _random.nextDouble() * MediaQuery.of(context).size.width,
        offsetY: -_random.nextDouble() * 100 - 20,
        velocityX: (_random.nextDouble() - 0.5) * 200,
        velocityY: _random.nextDouble() * 300 + 200,
        rotation: _random.nextDouble() * 360,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        size: _random.nextDouble() * 8 + 4,
        color: colorList[_random.nextInt(colorList.length)],
        shape: _random.nextBool() ? _ParticleShape.rectangle : _ParticleShape.circle,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: _ConfettiPainter(
          particles: _particles,
          progress: _controller.value,
        ),
        size: Size.infinite,
      ),
    );
  }
}

enum _ParticleShape { rectangle, circle }

class _Particle {
  final double offsetX;
  final double offsetY;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double rotationSpeed;
  final double size;
  final Color color;
  final _ParticleShape shape;

  _Particle({
    required this.offsetX,
    required this.offsetY,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.shape,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;

      final dx = particle.velocityX * progress;
      final dy = particle.velocityY * progress + 9.8 * 50 * progress * progress;
      final x = particle.offsetX + dx;
      final y = particle.offsetY + dy;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + particle.rotationSpeed * progress);

      switch (particle.shape) {
        case _ParticleShape.rectangle:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
          break;
        case _ParticleShape.circle:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}

/// Wrapper widget to easily trigger confetti on any event
class ConfettiTrigger extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTrigger;

  const ConfettiTrigger({
    super.key,
    required this.child,
    this.onTrigger,
  });

  @override
  State<ConfettiTrigger> createState() => _ConfettiTriggerState();
}

class _ConfettiTriggerState extends State<ConfettiTrigger> {
  bool _showConfetti = false;

  void trigger() {
    setState(() => _showConfetti = true);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showConfetti = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showConfetti)
          ConfettiEffect(
            particleCount: 80,
            onComplete: () => setState(() => _showConfetti = false),
          ),
      ],
    );
  }
}
