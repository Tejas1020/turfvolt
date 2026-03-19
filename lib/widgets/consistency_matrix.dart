import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
    const cellSize = 12.0;
    const cellMargin = 2.0;
    const cellRowHeight = cellSize + (cellMargin * 2);

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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardBg, AppColors.cardBg.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricBlue.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
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
                  Text('Consistency', style: AppTextStyles.exerciseName.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  )),
                  const SizedBox(height: 2),
                  Text('Last 16 weeks', style: AppTextStyles.micro.copyWith(color: AppColors.textMuted)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$pct%', style: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lime,
                    letterSpacing: -0.5,
                  )),
                  const SizedBox(height: 2),
                  Text('$totalActive days', style: AppTextStyles.micro.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Month labels row
          SizedBox(
            height: 16,
            child: Row(
              children: List.generate(16, (weekIndex) {
                final firstDayOfWeek = startDate.add(Duration(days: weekIndex * 7));
                final month = DateFormat('MMM').format(firstDayOfWeek);
                if (weekIndex == 0 ||
                    DateFormat('M').format(firstDayOfWeek) !=
                    DateFormat('M').format(startDate.add(Duration(days: (weekIndex - 1) * 7)))) {
                  return Expanded(
                    child: Text(month, style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textDim,
                      fontWeight: FontWeight.w500,
                    )),
                  );
                }
                return const Expanded(child: SizedBox());
              }),
            ),
          ),
          const SizedBox(height: 6),
          // Grid with day labels
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day labels column
              SizedBox(
                width: 18,
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 6),
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
                                    backgroundColor: AppColors.cardBg,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(cellMargin),
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  borderRadius: BorderRadius.circular(3),
                                  border: isToday
                                      ? Border.all(color: AppColors.lime, width: 2)
                                      : Border.all(color: AppColors.borderDefault.withOpacity(0.3)),
                                  boxShadow: cell.value > 0 ? [
                                    BoxShadow(
                                      color: cellColor.withOpacity(0.3),
                                      offset: const Offset(0, 0),
                                      blurRadius: 4,
                                    ),
                                  ] : null,
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
          const SizedBox(height: 10),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less ', style: TextStyle(fontSize: 10, color: AppColors.textDim, fontWeight: FontWeight.w500)),
              for (final color in [
                AppColors.matrixEmpty,
                AppColors.matrixLow,
                AppColors.matrixMid,
                AppColors.lime,
              ]) ...[
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: AppColors.borderDefault.withOpacity(0.5)),
                  ),
                ),
              ],
              Text(' More', style: TextStyle(fontSize: 10, color: AppColors.textDim, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
