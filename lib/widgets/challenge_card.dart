import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

/// Challenge card for active challenges section
/// Drives recurring engagement through gamification
class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final int currentProgress;
  final int target;
  final DateTime endDate;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.target,
    required this.endDate,
    required this.icon,
    this.accentColor = AppColors.summerOrange,
    this.onTap,
  });

  String _getDaysLeft() {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    if (difference <= 0) return 'Ending today';
    if (difference == 1) return '1 day left';
    return '$difference days left';
  }

  @override
  Widget build(BuildContext context) {
    final progress = currentProgress / target;
    final daysLeft = _getDaysLeft();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor,
                        accentColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.cardTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        daysLeft,
                        style: AppTextStyles.micro.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              description,
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.borderDark,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentProgress / $target',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(progress * 100).clamp(0, 100).toInt()}%',
                  style: AppTextStyles.caption.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable challenge list
class ChallengeList extends StatelessWidget {
  final List<ChallengeCard> challenges;

  const ChallengeList({
    super.key,
    required this.challenges,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: challenges.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 280,
            child: challenges[index],
          ),
        ),
      ),
    );
  }
}
