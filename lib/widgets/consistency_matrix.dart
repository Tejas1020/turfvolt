import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../models/log_model.dart';

class ConsistencyMatrix extends StatelessWidget {
  final List<LogModel> logs;

  const ConsistencyMatrix({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    const cellSize = 11.0;
    const cellMargin = 1.0; // matches EdgeInsets.all(1)
    const cellRowHeight = cellSize + (cellMargin * 2);
    // Generate 112 cells (16 weeks × 7 days), starting from today - 111 days → today
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 111));

    // Create a map of date to sets count
    final Map<String, int> setsPerDay = {};
    for (final log in logs) {
      setsPerDay[log.date] = (setsPerDay[log.date] ?? 0) +
          log.sets.where((s) => s.done).length;
    }

    // Generate all cells
    final List<MapEntry<String, int>> cells = [];
    for (int i = 0; i < 112; i++) {
      final date = startDate.add(Duration(days: i));
      final dateStr = date.toIso8601String().split('T')[0];
      final sets = setsPerDay[dateStr] ?? 0;
      cells.add(MapEntry(dateStr, sets));
    }

    // Calculate stats
    final totalActive = cells.where((c) => c.value > 0).length;
    final pct = (totalActive / 112 * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neumoBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.neumoHighlight.withOpacity(0.2),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: AppColors.neumoShadow.withOpacity(0.35),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Consistency', style: AppTextStyles.exerciseName),
                  Text('Last 16 weeks', style: AppTextStyles.micro),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$pct%', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lime,
                  )),
                  Text('$totalActive days active', style: AppTextStyles.micro),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Month labels row
          SizedBox(
            height: 16,
            child: Row(
              children: List.generate(16, (weekIndex) {
                final firstDayOfWeek = startDate.add(Duration(days: weekIndex * 7));
                final month = DateFormat('MMM').format(firstDayOfWeek);
                // Check if this is a new month
                if (weekIndex == 0 ||
                    DateFormat('M').format(firstDayOfWeek) !=
                    DateFormat('M').format(startDate.add(Duration(days: (weekIndex - 1) * 7)))) {
                  return Expanded(
                    child: Text(month, style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textDim,
                    )),
                  );
                }
                return const Expanded(child: SizedBox());
              }),
            ),
          ),
          const SizedBox(height: 4),
          // Grid with day labels
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day labels column
              SizedBox(
                width: 16,
                child: Column(
                  children: List.generate(7, (dayIndex) {
                    const labels = ['M', '', 'W', '', 'F', '', ''];
                    return SizedBox(
                      height: cellRowHeight,
                      child: Center(
                        child: Text(
                          labels[dayIndex],
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.textDim,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 4),
              // Grid
              Expanded(
                child: SizedBox(
                  height: cellRowHeight * 7,
                  child: Row(
                    children: List.generate(16, (weekIndex) {
                      return Expanded(
                        child: Column(
                          children: List.generate(7, (dayIndex) {
                            final cellIndex = weekIndex * 7 + dayIndex;
                            final cell = cells[cellIndex];
                            final isToday = cell.key == today.toIso8601String().split('T')[0];

                            final Color cellColor;
                            if (cell.value == 0) {
                              cellColor = AppColors.matrixEmpty;
                            } else if (cell.value <= 3) {
                              cellColor = AppColors.matrixLow;
                            } else if (cell.value <= 8) {
                              cellColor = AppColors.matrixMid;
                            } else {
                              cellColor = AppColors.lime;
                            }

                            return GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${cell.key}: ${cell.value} sets'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(cellMargin),
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  borderRadius: BorderRadius.circular(2),
                                  border: isToday
                                      ? Border.all(color: AppColors.lime, width: 1.5)
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less ', style: TextStyle(fontSize: 10, color: AppColors.textDim)),
              for (final color in [
                AppColors.matrixEmpty,
                AppColors.matrixLow,
                AppColors.matrixMid,
                AppColors.lime,
              ]) ...[
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: AppColors.borderDefault, width: 0.5),
                  ),
                ),
              ],
              Text(' More', style: TextStyle(fontSize: 10, color: AppColors.textDim)),
            ],
          ),
        ],
      ),
    );
  }
}
