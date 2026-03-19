import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

/// Animated streak counter with rolling number effect
/// Creates satisfying micro-interaction when streak milestones are hit
class AnimatedStreakCounter extends StatefulWidget {
  final int streak;
  final String label;
  final Duration duration;
  final IconData? icon;

  const AnimatedStreakCounter({
    super.key,
    required this.streak,
    required this.label,
    this.duration = const Duration(milliseconds: 1200),
    this.icon,
  });

  @override
  State<AnimatedStreakCounter> createState() => _AnimatedStreakCounterState();
}

class _AnimatedStreakCounterState extends State<AnimatedStreakCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _numberAnimation;
  int _displayNumber = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _numberAnimation = StepTween(begin: 0, end: widget.streak).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            _displayNumber = _numberAnimation.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 24,
                    color: AppColors.summerOrange,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  '$_displayNumber',
                  style: AppTextStyles.streakNumber.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.streakSubtitle,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Streak badge with glow effect for home screen
class StreakBadge extends StatelessWidget {
  final int streak;
  final double size;

  const StreakBadge({
    super.key,
    required this.streak,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.summerOrange,
            AppColors.sunshineYellow,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.summerOrange.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$streak',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
