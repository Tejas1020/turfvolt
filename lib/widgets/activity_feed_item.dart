import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

/// Activity feed item showing social/synthetic activity
/// Creates FOMO and motivation through social proof
class ActivityFeedItem extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String action;
  final String? exerciseName;
  final String? weight;
  final String? reps;
  final DateTime timestamp;
  final IconData? actionIcon;
  final Color? accentColor;

  const ActivityFeedItem({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.action,
    this.exerciseName,
    this.weight,
    this.reps,
    required this.timestamp,
    this.actionIcon,
    this.accentColor,
  });

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: accentColor ?? AppColors.summerOrange,
            backgroundImage: NetworkImage(userAvatar),
            onBackgroundImageError: (_, __) {},
            child: userAvatar.isEmpty
                ? Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyPrimary.copyWith(height: 1.4),
                    children: [
                      TextSpan(
                        text: userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' $action ',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      if (exerciseName != null)
                        TextSpan(
                          text: exerciseName!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: accentColor ?? AppColors.summerOrange,
                          ),
                        ),
                      if (weight != null || reps != null) ...[
                        TextSpan(text: ' '),
                        TextSpan(
                          text: '($weight',
                          style: TextStyle(color: AppColors.textDim),
                        ),
                        if (reps != null)
                          TextSpan(text: ' × $reps)'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getTimeAgo(),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.textDim,
                  ),
                ),
              ],
            ),
          ),
          // Icon
          if (actionIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (accentColor ?? AppColors.summerOrange).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                actionIcon,
                size: 18,
                color: accentColor ?? AppColors.summerOrange,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Synthetic activity feed - generates motivational activity
/// In production, this would connect to real social features
class ActivityFeed extends StatelessWidget {
  final List<ActivityFeedItem> items;

  const ActivityFeed({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: item,
              ))
          .toList(),
    );
  }
}

/// Generate synthetic activity for demo/empty state
class SyntheticActivityGenerator {
  static final List<Map<String, String>> _exercises = [
    {'name': 'Bench Press', 'icon': '💪'},
    {'name': 'Squat', 'icon': '🏋️'},
    {'name': 'Deadlift', 'icon': '🔥'},
    {'name': 'Pull-ups', 'icon': '💯'},
    {'name': 'Overhead Press', 'icon': '⚡'},
    {'name': 'Barbell Row', 'icon': '🎯'},
  ];

  static final List<String> _actions = [
    'crushed',
    'nailed',
    'destroyed',
    'conquered',
    'smashed',
    'aced',
  ];

  static final List<String> _names = [
    'Sarah', 'Mike', 'Jessica', 'David', 'Emma', 'Chris',
    'Alex', 'Jordan', 'Taylor', 'Morgan', 'Casey', 'Riley',
  ];

  static ActivityFeedItem generateRandom({int? minutesAgo}) {
    final name = _names[DateTime.now().millisecond % _names.length];
    final exercise = _exercises[DateTime.now().millisecond % _exercises.length];
    final action = _actions[DateTime.now().millisecond % _actions.length];
    final weight = '${100 + (DateTime.now().millisecond % 100)}lbs';
    final reps = '${3 + (DateTime.now().millisecond % 5)}';

    return ActivityFeedItem(
      userName: name,
      userAvatar: '',
      action: action,
      exerciseName: exercise['name'],
      weight: weight,
      reps: reps,
      timestamp: DateTime.now().subtract(Duration(minutes: minutesAgo ?? (DateTime.now().millisecond % 60))),
      actionIcon: Icons.fitness_center,
      accentColor: AppColors.summerOrange,
    );
  }

  static List<ActivityFeedItem> generateFeed({int count = 5}) {
    return List.generate(count, (index) => generateRandom(minutesAgo: index * 12 + 1));
  }
}
