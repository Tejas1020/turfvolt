import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/log_model.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/log_provider.dart';
import '../../../widgets/stat_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String period = '30';
  String? selectedExerciseId;

  DateTime _startDateForPeriod() {
    final now = DateTime.now();
    final days = period == '7' ? 7 : (period == '90' ? 90 : 30);
    return now.subtract(Duration(days: days - 1));
  }

  @override
  Widget build(BuildContext context) {
    final logP = context.watch<LogProvider>();
    final exP = context.watch<ExerciseProvider>();

    final start = _startDateForPeriod();
    final end = DateTime.now();
    final logs = logP.getLogsByDateRange(start, end);

    final workouts = logs.map((l) => '${l.planId}_${l.date}').toSet().length;
    final totalSets = logs.fold<int>(0, (sum, l) => sum + l.sets.where((s) => s.done).length);
    final volume = logs.fold<double>(
      0,
      (sum, l) => sum +
          l.sets.where((s) => s.done).fold<double>(
                0,
                (setSum, s) =>
                    setSum + (double.tryParse(s.weight) ?? 0) * (int.tryParse(s.reps) ?? 0),
              ),
    );

    final periodOptions = const [
      ('7', '7 days'),
      ('30', '30 days'),
      ('90', '3 months'),
    ];

    final allExerciseIds = logP.logs.map((l) => l.exerciseId).toSet().toList();
    allExerciseIds.sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ANALYTICS', style: AppTextStyles.screenTitle.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.lime,
          )),
          const SizedBox(height: 4),
          Text('Track your progress over time', style: AppTextStyles.secondary.copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          )),
          const SizedBox(height: 16),
          Row(
            children: periodOptions.map((opt) {
              final isActive = period == opt.$1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => period = opt.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.lime : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? AppColors.lime : AppColors.borderLight,
                        width: isActive ? 0 : 1,
                      ),
                      boxShadow: isActive ? [
                        BoxShadow(
                          color: AppColors.lime.withOpacity(0.3),
                          offset: const Offset(0, 3),
                          blurRadius: 8,
                        ),
                      ] : null,
                    ),
                    child: Text(
                      opt.$2,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? AppColors.appBg : AppColors.textMuted,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: StatCard(value: '$workouts', label: 'Workouts', icon: Icons.fitness_center_rounded)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(value: '$totalSets', label: 'Total Sets', icon: Icons.repeat_rounded)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(value: '${volume.toStringAsFixed(0)}kg', label: 'Volume', icon: Icons.local_fire_department_rounded)),
            ],
          ),
          const SizedBox(height: 18),
          _Card(
            title: 'Activity — last 14 days',
            child: SizedBox(
              height: 120,
              child: _ActivityChart(logs: logP.logs),
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Volume by muscle group',
            child: _VolumeByMuscle(logs: logs),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Strength progress (estimated 1RM)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allExerciseIds.length,
                    itemBuilder: (context, i) {
                      final id = allExerciseIds[i];
                      final ex = exP.exercises.where((e) => e.id == id).firstOrNull;
                      final label = ex?.name ?? id;
                      final isActive = selectedExerciseId == id;
                      return GestureDetector(
                        onTap: () => setState(() => selectedExerciseId = id),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.lime : AppColors.cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive ? AppColors.lime : AppColors.borderLight,
                              width: isActive ? 0 : 1,
                            ),
                            boxShadow: isActive ? [
                              BoxShadow(
                                color: AppColors.lime.withOpacity(0.3),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                              ),
                            ] : null,
                          ),
                          child: Text(
                            label,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive ? AppColors.appBg : AppColors.textMuted,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                if (selectedExerciseId == null)
                  Text('Select an exercise to view trend.',
                    style: AppTextStyles.secondary.copyWith(color: AppColors.textMuted))
                else
                  _StrengthChart(
                    logs: logs.where((l) => l.exerciseId == selectedExerciseId).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardBg, AppColors.cardBg.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricBlue.withOpacity(0.06),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.exerciseName.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  final List<LogModel> logs;
  const _ActivityChart({required this.logs});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 13));
    final days = List.generate(14, (i) => start.add(Duration(days: i)));
    final labels = days.map((d) => DateFormat('MM/dd').format(d)).toList();

    final counts = <int>[];
    for (final d in days) {
      final ds = d.toIso8601String().split('T')[0];
      counts.add(logs.where((l) => l.date == ds).length);
    }
    final maxCount = counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxCount.toDouble() + 1,
        barGroups: counts.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.toDouble(),
                gradient: LinearGradient(
                  colors: [
                    e.value > 0 ? AppColors.lime : AppColors.cardBg,
                    e.value > 0 ? AppColors.cyan : AppColors.cardBg,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                width: 14,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (val, meta) {
                final idx = val.toInt();
                if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                return Transform.rotate(
                  angle: -0.785,
                  child: Text(
                    labels[idx],
                    style: GoogleFonts.dmSans(fontSize: 9, color: AppColors.textDim, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _VolumeByMuscle extends StatelessWidget {
  final List<LogModel> logs;
  const _VolumeByMuscle({required this.logs});

  @override
  Widget build(BuildContext context) {
    final vols = <String, double>{};
    for (final l in logs) {
      final v = l.sets.where((s) => s.done).fold<double>(
            0,
            (sum, s) => sum + (double.tryParse(s.weight) ?? 0) * (int.tryParse(s.reps) ?? 0),
          );
      vols[l.muscleGroup] = (vols[l.muscleGroup] ?? 0) + v;
    }
    final entries = vols.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxVol = entries.isEmpty ? 1.0 : entries.first.value;

    if (entries.isEmpty) {
      return Text('No data yet.', style: AppTextStyles.secondary.copyWith(color: AppColors.textMuted));
    }

    return Column(
      children: entries.map((e) {
        final mg = e.key;
        final vol = e.value;
        final color = AppColors.muscleText(mg);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(mg, style: AppTextStyles.secondary.copyWith(fontWeight: FontWeight.w500)),
                Text(
                  '${vol.toStringAsFixed(0)} kg',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: (vol / maxVol).clamp(0, 1),
                  backgroundColor: AppColors.inputBg,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }
}

class _StrengthChart extends StatelessWidget {
  final List<LogModel> logs;
  const _StrengthChart({required this.logs});

  double _epley(double weight, int reps) => weight * (1 + reps / 30.0);

  @override
  Widget build(BuildContext context) {
    final sorted = [...logs]..sort((a, b) => a.date.compareTo(b.date));
    if (sorted.isEmpty) return Text('No logs for this exercise.', style: AppTextStyles.secondary.copyWith(color: AppColors.textMuted));

    final points = sorted.map((l) {
      double best = 0;
      for (final s in l.sets.where((x) => x.done)) {
        final w = double.tryParse(s.weight) ?? 0;
        final r = int.tryParse(s.reps) ?? 0;
        best = best < _epley(w, r) ? _epley(w, r) : best;
      }
      return best;
    }).toList();

    final maxY = points.reduce((a, b) => a > b ? a : b) + 1;
    final first = points.first;
    final latest = points.last;
    final diff = latest - first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barGroups: points.asMap().entries.map((e) {
                final isLatest = e.key == points.length - 1;
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      gradient: LinearGradient(
                        colors: isLatest
                            ? [AppColors.lime, AppColors.cyan]
                            : [AppColors.cardBg, AppColors.cardBg],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      width: 18,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ],
                );
              }).toList(),
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: (diff >= 0 ? AppColors.lime : AppColors.coral).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                diff >= 0 ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: diff >= 0 ? AppColors.lime : AppColors.coral,
              ),
              const SizedBox(width: 6),
              Text(
                diff >= 0
                    ? '+${diff.toStringAsFixed(1)} kg since first log'
                    : '−${diff.abs().toStringAsFixed(1)} kg since first log',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: diff >= 0 ? AppColors.lime : AppColors.coral,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
