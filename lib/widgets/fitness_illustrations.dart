import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Premium fitness-themed illustrations using CustomPainter
/// These are vector-based, crisp at any resolution, and work offline

class FitnessIllustration extends StatelessWidget {
  final FitnessIllustrationType type;
  final double size;
  final Gradient? gradient;

  const FitnessIllustration({
    super.key,
    required this.type,
    this.size = 200,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IllustrationPainter(
          type: type,
          gradient: gradient,
        ),
      ),
    );
  }
}

/// Exercise illustration using professional GIF animations from ExerciseDB
/// Shows proper exercise form with realistic animations
class ExerciseIllustration extends StatelessWidget {
  final String exerciseName;
  final double size;
  final bool loop;

  const ExerciseIllustration({
    super.key,
    required this.exerciseName,
    this.size = 180,
    this.loop = true,
  });

  String _getExerciseFilename(String name) {
    // Map exercise names to filename format (72 exercises with GIFs)
    final map = {
      // Chest
      'Incline Barbell Press': 'incline_barbell_press',
      'Incline DB Press': 'incline_db_press',
      'Incline Push-Up': 'incline_push_up',
      'Decline Bench Press': 'decline_bench_press',
      'Chest Dips': 'chest_dips',
      'Decline DB Fly': 'decline_db_fly',
      'Flat Barbell Bench Press': 'flat_barbell_bench',
      'Flat DB Press': 'flat_db_press',
      'Push-Up': 'push_up',
      'Svend Press': 'svend_press',
      'Reverse Grip Bench Press': 'reverse_grip_bench_press',
      'Machine Chest Press': 'machine_chest_press',

      // Back
      'Deadlift': 'deadlift',
      'Bent Over Row': 'bent_over_row',
      'Pull-Up': 'pull_up',
      'Chin-Up': 'chin_up',
      'Inverted Row': 'inverted_row',
      'Lat Pulldown': 'lat_pulldown',
      'T-Bar Row': 't_bar_row',
      'One-Arm DB Row': 'one_arm_db_row',
      'Seated Cable Row': 'seated_cable_row',
      'Straight-Arm Pulldown': 'straight_arm_pulldown',
      'Rack Pull': 'rack_pull',

      // Shoulders
      'Lateral Raises': 'lateral_raises',
      'Front Raise': 'front_raise',
      'Cable Lateral Raise': 'cable_lateral_raise',
      'Upright Row': 'upright_row',
      'Arnold Press': 'arnold_press',
      'Pike Push-Up': 'pike_push_up',
      'Cuban Press': 'cuban_press',
      'Overhead Press': 'overhead_press',

      // Triceps
      'Diamond Push-Up': 'diamond_push_up',
      'Tricep Pushdown': 'tricep_pushdown',
      'Skull Crushers': 'skull_crushers',
      'Close-Grip Bench Press': 'close_grip_bench_press',
      'Bench Dip': 'bench_dip',
      'Single-Arm Pushdown': 'single_arm_pushdown',
      'Tate Press': 'tate_press',
      'Kickback': 'kickback',
      'Overhead Tricep Extension': 'overhead_tricep_extension',

      // Biceps (fallbacks - using placeholder)
      'Barbell Curl': '',
      'Hammer Curl': '',
      'Preacher Curl': '',

      // Forearms
      'Wrist Curl': 'wrist_curl',
      'Reverse Wrist Curl': 'reverse_wrist_curl',
      'Grip Trainer Squeeze': 'grip_trainer_squeeze',

      // Legs - Quads
      'Barbell Squat': 'barbell_squat',
      'Leg Press': 'leg_press',
      'Front Squat': 'front_squat',
      'Hack Squat': 'hack_squat',
      'Goblet Squat': 'goblet_squat',
      'Step-Up': 'step_up',
      'Sissy Squat': 'sissy_squat',
      'Leg Extension': 'leg_extension',
      'Zercher Squat': 'zercher_squat',

      // Legs - Hamstrings
      'Romanian Deadlift': 'romanian_deadlift',
      'Leg Curl': 'leg_curl',
      'Single-Leg RDL': 'single_leg_rdl',
      'Good Morning': 'good_morning',
      'Cable Pull-Through': 'cable_pull_through',

      // Legs - Glutes
      'Hip Thrust': 'hip_thrust',
      'Glute Bridge': 'glute_bridge',

      // Legs - Calves (fallbacks)
      'Standing Calf Raise': '',
      'Seated Calf Raise': '',

      // Core
      'Plank': 'plank',
      'Side Plank': 'side_plank',

      // Full Body
      'Kettlebell Swing': 'kettlebell_swing',
      'Clean and Press': 'clean_and_press',
    };
    final filename = map[name];
    if (filename == null || filename.isEmpty) return '';
    return 'Assets/exercises/$filename.gif';
  }

  @override
  Widget build(BuildContext context) {
    final filename = _getExerciseFilename(exerciseName);
    if (filename.isEmpty) {
      // Fallback to placeholder
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(Icons.fitness_center, size: size * 0.4, color: Colors.grey),
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        filename,
        width: size,
        height: size,
        fit: BoxFit.contain,
        gaplessPlayback: loop,
      ),
    );
  }
}

enum FitnessIllustrationType {
  dumbbell,
  running,
  lifting,
  yoga,
  heart,
  trophy,
  flame,
  muscle,
}

class _IllustrationPainter extends CustomPainter {
  final FitnessIllustrationType type;
  final Gradient? gradient;

  _IllustrationPainter({required this.type, this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case FitnessIllustrationType.dumbbell:
        _paintDumbbell(canvas, size);
        break;
      case FitnessIllustrationType.running:
        _paintRunning(canvas, size);
        break;
      case FitnessIllustrationType.lifting:
        _paintLifting(canvas, size);
        break;
      case FitnessIllustrationType.yoga:
        _paintYoga(canvas, size);
        break;
      case FitnessIllustrationType.heart:
        _paintHeart(canvas, size);
        break;
      case FitnessIllustrationType.trophy:
        _paintTrophy(canvas, size);
        break;
      case FitnessIllustrationType.flame:
        _paintFlame(canvas, size);
        break;
      case FitnessIllustrationType.muscle:
        _paintMuscle(canvas, size);
        break;
    }
  }

  Gradient _getGradient(List<Color> colors) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  void _paintDumbbell(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFFF6B6B), const Color(0xFFFF9F43)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Left weight
    final leftWeight = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 70, cy - 25, 35, 50),
        const Radius.circular(8),
      ));
    canvas.drawPath(leftWeight, paint);

    // Right weight
    final rightWeight = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 35, cy - 25, 35, 50),
        const Radius.circular(8),
      ));
    canvas.drawPath(rightWeight, paint);

    // Bar
    final barPaint = Paint()
      ..shader = _getGradient([const Color(0xFFFF9F43), const Color(0xFFFFB76B)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 35, cy - 8, 70, 16),
        const Radius.circular(4),
      ),
      barPaint,
    );

    // Inner weights
    final innerPaint = Paint()..color = const Color(0xFFFFB76B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 55, cy - 18, 15, 36),
        const Radius.circular(4),
      ),
      innerPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 40, cy - 18, 15, 36),
        const Radius.circular(4),
      ),
      innerPaint,
    );
  }

  void _paintRunning(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFFF6B6B), const Color(0xFFFF9F43)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Body path (running figure)
    final path = Path();
    // Head
    canvas.drawCircle(Offset(cx, cy - 50), 15, paint);
    // Torso
    path.moveTo(cx, cy - 35);
    path.lineTo(cx + 20, cy);
    // Arms
    path.moveTo(cx + 5, cy - 25);
    path.lineTo(cx - 15, cy - 10);
    path.moveTo(cx + 5, cy - 25);
    path.lineTo(cx + 25, cy - 15);
    // Legs
    path.moveTo(cx + 20, cy);
    path.lineTo(cx + 35, cy + 30);
    path.moveTo(cx + 20, cy);
    path.lineTo(cx - 5, cy + 30);

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 8;
    paint.strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);

    // Motion lines
    paint.strokeWidth = 3;
    paint.color = const Color(0x40FF6B6B);
    canvas.drawLine(Offset(cx - 35, cy - 20), Offset(cx - 25, cy - 20), paint);
    canvas.drawLine(Offset(cx - 35, cy - 10), Offset(cx - 25, cy - 10), paint);
    canvas.drawLine(Offset(cx - 35, cy), Offset(cx - 25, cy), paint);
  }

  void _paintLifting(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFA8E6CF), const Color(0xFF7DD3B0)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Lifting figure overhead
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 8;
    paint.strokeCap = StrokeCap.round;

    final path = Path();
    // Head
    canvas.drawCircle(Offset(cx, cy - 55), 12, paint..style = PaintingStyle.fill);
    paint.style = PaintingStyle.stroke;
    // Torso
    path.moveTo(cx, cy - 43);
    path.lineTo(cx, cy - 5);
    // Arms raised
    path.moveTo(cx, cy - 35);
    path.lineTo(cx - 20, cy - 55);
    path.moveTo(cx, cy - 35);
    path.lineTo(cx + 20, cy - 55);
    // Legs
    path.moveTo(cx, cy - 5);
    path.lineTo(cx - 15, cy + 35);
    path.moveTo(cx, cy - 5);
    path.lineTo(cx + 15, cy + 35);

    canvas.drawPath(path, paint);

    // Barbell
    final barPaint = Paint()
      ..shader = _getGradient([const Color(0xFF7DD3B0), const Color(0xFFA8E6CF)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 45, cy - 60, 90, 8),
        const Radius.circular(4),
      ),
      barPaint,
    );
    // Weights
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 50, cy - 70, 12, 28),
        const Radius.circular(4),
      ),
      barPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 38, cy - 70, 12, 28),
        const Radius.circular(4),
      ),
      barPaint,
    );
  }

  void _paintYoga(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFDDA0DD), const Color(0xFFEEC4E8)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 8;
    paint.strokeCap = StrokeCap.round;

    // Yoga pose (tree pose)
    final path = Path();
    // Head
    canvas.drawCircle(Offset(cx, cy - 55), 12, paint..style = PaintingStyle.fill);
    paint.style = PaintingStyle.stroke;
    // Spine
    path.moveTo(cx, cy - 43);
    path.lineTo(cx, cy);
    // Arms raised
    path.moveTo(cx, cy - 35);
    path.lineTo(cx - 25, cy - 50);
    path.moveTo(cx, cy - 35);
    path.lineTo(cx + 25, cy - 50);
    // Standing leg
    path.moveTo(cx, cy);
    path.lineTo(cx, cy + 40);
    // Bent leg
    path.moveTo(cx, cy + 10);
    path.lineTo(cx + 20, cy);

    canvas.drawPath(path, paint);

    // Lotus base
    final basePaint = Paint()
      ..shader = _getGradient([const Color(0xFFEEC4E8), const Color(0xFFDDA0DD)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawOval(
      Rect.fromLTWH(cx - 30, cy + 35, 60, 15),
      basePaint,
    );
  }

  void _paintHeart(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFFF6B6B), const Color(0xFFFF9F43)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;
    final heartSize = size.width * 0.35;

    final path = Path();
    path.moveTo(cx, cy + heartSize * 0.3);
    path.cubicTo(
      cx - heartSize * 0.5, cy - heartSize * 0.1,
      cx - heartSize * 0.5, cy - heartSize * 0.5,
      cx, cy - heartSize * 0.2,
    );
    path.cubicTo(
      cx + heartSize * 0.5, cy - heartSize * 0.5,
      cx + heartSize * 0.5, cy - heartSize * 0.1,
      cx, cy + heartSize * 0.3,
    );

    // Glow
    canvas.drawShadow(path, const Color(0xFFFF6B6B), 20, true);
    canvas.drawPath(path, paint);

    // Pulse lines
    paint.strokeWidth = 3;
    paint.color = const Color(0x60FF9F43);
    canvas.drawLine(Offset(cx - heartSize * 0.8, cy), Offset(cx - heartSize * 0.6, cy), paint);
    canvas.drawLine(Offset(cx + heartSize * 0.6, cy), Offset(cx + heartSize * 0.8, cy), paint);
  }

  void _paintTrophy(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFFF9F43), const Color(0xFFFFB76B)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cup
    final cupPath = Path();
    cupPath.moveTo(cx - 30, cy - 50);
    cupPath.lineTo(cx - 25, cy + 10);
    cupPath.lineTo(cx + 25, cy + 10);
    cupPath.lineTo(cx + 30, cy - 50);
    cupPath.close();

    canvas.drawShadow(cupPath, const Color(0xFFFF9F43), 15, true);
    canvas.drawPath(cupPath, paint);

    // Handles
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 6;
    paint.strokeCap = StrokeCap.round;

    final handlePath = Path();
    handlePath.moveTo(cx - 30, cy - 40);
    handlePath.arcToPoint(
      Offset(cx - 50, cy - 20),
      radius: const Radius.circular(20),
      clockwise: false,
    );
    handlePath.moveTo(cx + 30, cy - 40);
    handlePath.arcToPoint(
      Offset(cx + 50, cy - 20),
      radius: const Radius.circular(20),
      clockwise: true,
    );
    canvas.drawPath(handlePath, paint);

    // Stem
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 8, cy + 10, 16, 25),
        const Radius.circular(4),
      ),
      paint,
    );

    // Base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 25, cy + 35, 50, 12),
        const Radius.circular(6),
      ),
      paint,
    );

    // Star
    paint.color = Colors.white.withAlpha(179);
    _drawStar(canvas, Offset(cx, cy - 25), 12, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _paintFlame(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFFF6B6B), const Color(0xFFFF9F43), const Color(0xFFFFB76B)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Main flame
    final path = Path();
    path.moveTo(cx, cy + 50);
    path.cubicTo(cx - 50, cy + 20, cx - 40, cy - 20, cx, cy - 55);
    path.cubicTo(cx + 40, cy - 20, cx + 50, cy + 20, cx, cy + 50);

    canvas.drawShadow(path, const Color(0xFFFF6B6B), 25, true);
    canvas.drawPath(path, paint);

    // Inner flame
    final innerPaint = Paint()
      ..shader = _getGradient([const Color(0xFFFFB76B), const Color(0xFFFFD93D)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final innerPath = Path();
    innerPath.moveTo(cx, cy + 35);
    innerPath.cubicTo(cx - 25, cy + 15, cx - 20, cy - 5, cx, cy - 30);
    innerPath.cubicTo(cx + 20, cy - 5, cx + 25, cy + 15, cx, cy + 35);

    canvas.drawPath(innerPath, innerPaint);

    // Core
    final corePaint = Paint()..color = const Color(0xFFFFD93D);
    canvas.drawCircle(Offset(cx, cy + 15), 8, corePaint);
  }

  void _paintMuscle(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _getGradient([const Color(0xFFFF6B6B), const Color(0xFFE55555)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final cx = size.width / 2;
    final cy = size.height / 2;

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 10;
    paint.strokeCap = StrokeCap.round;

    // Arm with bicep
    final path = Path();
    // Shoulder
    path.moveTo(cx - 40, cy - 30);
    // Bicep curve
    path.quadraticBezierTo(cx - 55, cy, cx - 40, cy + 25);
    // Forearm
    path.quadraticBezierTo(cx - 30, cy + 35, cx - 20, cy + 50);
    // Other arm
    path.moveTo(cx + 40, cy - 30);
    path.quadraticBezierTo(cx + 55, cy, cx + 40, cy + 25);
    path.quadraticBezierTo(cx + 30, cy + 35, cx + 20, cy + 50);

    canvas.drawPath(path, paint);

    // Glow effect
    paint.strokeWidth = 15;
    paint.color = const Color(0x30FF6B6B);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Pre-built illustration widgets with consistent styling
class DumbbellIllustration extends StatelessWidget {
  final double size;

  const DumbbellIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return FitnessIllustration(
      type: FitnessIllustrationType.dumbbell,
      size: size,
    );
  }
}

class RunningIllustration extends StatelessWidget {
  final double size;

  const RunningIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return FitnessIllustration(
      type: FitnessIllustrationType.running,
      size: size,
    );
  }
}

class LiftingIllustration extends StatelessWidget {
  final double size;

  const LiftingIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return FitnessIllustration(
      type: FitnessIllustrationType.lifting,
      size: size,
    );
  }
}

class HeartIllustration extends StatelessWidget {
  final double size;

  const HeartIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return FitnessIllustration(
      type: FitnessIllustrationType.heart,
      size: size,
    );
  }
}

class TrophyIllustration extends StatelessWidget {
  final double size;

  const TrophyIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return FitnessIllustration(
      type: FitnessIllustrationType.trophy,
      size: size,
    );
  }
}

class FlameIllustration extends StatelessWidget {
  final double size;

  const FlameIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return FitnessIllustration(
      type: FitnessIllustrationType.flame,
      size: size,
    );
  }
}

class EmptyStateIllustration extends StatelessWidget {
  final String label;
  final double size;

  const EmptyStateIllustration({
    super.key,
    this.label = '',
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FitnessIllustration(
          type: FitnessIllustrationType.dumbbell,
          size: size,
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Card showing exercise illustration with description
class ExerciseDetailCard extends StatelessWidget {
  final String exerciseName;
  final String muscleGroup;
  final String description;
  final IconData icon;

  const ExerciseDetailCard({
    super.key,
    required this.exerciseName,
    required this.muscleGroup,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D3436), width: 1.5),
      ),
      child: Column(
        children: [
          // Professional exercise GIF illustration
          ExerciseIllustration(
            exerciseName: exerciseName,
            size: 160,
          ),
          const SizedBox(height: 12),
          // Exercise name
          Text(
            exerciseName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFFE5E5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          // Muscle group chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getMuscleColor(muscleGroup).withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              muscleGroup,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getMuscleColor(muscleGroup),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFFA0A0A0),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getMuscleColor(String group) {
    switch (group.toLowerCase()) {
      case 'chest':
      case 'upper chest':
      case 'lower chest':
        return const Color(0xFFFF6B6B);
      case 'back':
      case 'lats':
      case 'traps':
        return const Color(0xFF4ECDC4);
      case 'shoulders':
        return const Color(0xFFFFD93D);
      case 'biceps':
      case 'triceps':
      case 'arms':
        return const Color(0xFF95E1D3);
      case 'forearms':
        return const Color(0xFFA8D8EA);
      case 'quads':
      case 'quadriceps':
        return const Color(0xFFFF9F43);
      case 'hamstrings':
        return const Color(0xFF5F4B8B);
      case 'glutes':
        return const Color(0xFF7F5D5D);
      case 'calves':
        return const Color(0xFF2E86AB);
      case 'core':
      case 'abs':
        return const Color(0xFF6C5CE7);
      default:
        return const Color(0xFF74B9FF);
    }
  }
}

/// Modal bottom sheet showing exercise details
void showExerciseDetails(BuildContext context, Map<String, String> exercise) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1F2E), Color(0xFF0F1219)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF3D4455),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ExerciseDetailCard(
            exerciseName: exercise['name'] ?? '',
            muscleGroup: exercise['muscle'] ?? '',
            description: exercise['desc'] ?? '',
            icon: exercise['icon'] != null ? _getIconData(exercise['icon']) : Icons.fitness_center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF2D3436),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

IconData _getIconData(String? iconKey) {
  switch (iconKey) {
    case 'chest':
      return Icons.fitness_center;
    case 'back':
      return Icons.accessibility;
    case 'shoulders':
      return Icons.sports_gymnastics;
    case 'arms':
      return Icons.airline_seat_recline_normal;
    case 'legs':
      return Icons.directions_walk;
    case 'core':
      return Icons.favorite;
    default:
      return Icons.fitness_center;
  }
}
