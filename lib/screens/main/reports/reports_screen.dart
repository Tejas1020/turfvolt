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
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/mesh_gradient_background.dart';
import '../../../widgets/shimmer.dart';

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

    return MeshGradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientText.coralOrange(
                'ANALYTICS',
                style: AppTextStyles.gradientHero.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your progress over time',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Period Selector
              Row(
                children: periodOptions.map((opt) {
                  final isActive = period == opt.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => period = opt.$1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.vibrantCoral : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: isActive
                              ? null
                              : Border.all(color: AppColors.border),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.vibrantCoral.withAlpha(77),
                                    blurRadius: 12,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          opt.$2,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Stats Row
              Row(
                children: logs.isEmpty
                    ? [
                        Expanded(child: ShimmerStatCard()),
                        const SizedBox(width: 10),
                        Expanded(child: ShimmerStatCard()),
                        const SizedBox(width: 10),
                        Expanded(child: ShimmerStatCard()),
                      ]
                    : [
                        Expanded(child: StatCard(
                          value: '$workouts',
                          label: 'Workouts',
                          icon: Icons.fitness_center_rounded,
                          gradient: AppColors.primaryGradient,
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: StatCard(
                          value: '$totalSets',
                          label: 'Total Sets',
                          icon: Icons.repeat_rounded,
                          gradient: AppColors.secondaryGradient,
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: StatCard(
                          value: '${volume.toStringAsFixed(0)}',
                          label: 'Volume kg',
                          icon: Icons.local_fire_department_rounded,
                          gradient: AppColors.accentGradient,
                        )),
                      ],
              ),
              const SizedBox(height: 20),
              _GlassCard(
                title: 'Activity — last 14 days',
                child: SizedBox(
                  height: 140,
                  child: _ActivityChart(logs: logP.logs),
                ),
              ),
              const SizedBox(height: 16),
              _GlassCard(
                title: 'Volume by muscle group',
                child: _VolumeByMuscle(logs: logs),
              ),
              const SizedBox(height: 16),
              _GlassCard(
                title: 'Strength progress (1RM)',
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
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.vibrantCoral : AppColors.cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: isActive ? null : Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                label,
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white : AppColors.textMuted,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (selectedExerciseId == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Select an exercise to view trend',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: AppColors.textDim,
                            ),
                          ),
                        ),
                      )
                    else
                      _StrengthChart(
                        logs: logs.where((l) => l.exerciseId == selectedExerciseId).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _GlassCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
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
    final labels = days.map((d) => DateFormat('M/d').format(d)).toList();

    final counts = <int>[];
    for (final d in days) {
      final ds = d.toIso8601String().split('T')[0];
      counts.add(logs.where((l) => l.date == ds).length);
    }
    final maxCount = counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxCount + 1).toDouble(),
        barGroups: counts.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.toDouble(),
                gradient: LinearGradient(
                  colors: e.value > 0
                      ? [AppColors.vibrantCoral, AppColors.electricOrange]
                      : [AppColors.border, AppColors.border],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                width: 12,
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
                if (idx % 2 != 0) return const SizedBox.shrink();
                return Text(
                  labels[idx],
                  style: GoogleFonts.dmSans(fontSize: 9, color: AppColors.textDim),
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'No data yet',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textDim),
          ),
        ),
      );
    }

    return Column(
      children: entries.take(6).map((e) {
        final mg = e.key;
        final vol = e.value;
        final color = AppColors.muscleText(mg);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mg,
                  style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${vol.toStringAsFixed(0)} kg',
                  style: GoogleFonts.dmSans(fontSize: 13, color: color, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: (vol / maxVol).clamp(0, 1),
                backgroundColor: AppColors.inputBg,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
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
    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'No logs for this exercise',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textDim),
          ),
        ),
      );
    }

    final points = sorted.map((l) {
      double best = 0;
      for (final s in l.sets.where((x) => x.done)) {
        final w = double.tryParse(s.weight) ?? 0;
        final r = int.tryParse(s.reps) ?? 0;
        best = best < _epley(w, r) ? _epley(w, r) : best;
      }
      return best;
    }).toList();

    final maxY = points.reduce((a, b) => a > b ? a : b) + 10;
    final first = points.first;
    final latest = points.last;
    final diff = latest - first;

    return Column(
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
                      gradient: isLatest
                          ? AppColors.primaryGradient
                          : LinearGradient(
                              colors: [AppColors.border, AppColors.border],
                            ),
                      width: 16,
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
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: (diff >= 0 ? AppColors.success : AppColors.error).withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                diff >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 16,
                color: diff >= 0 ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 6),
              Text(
                diff >= 0
                    ? '+${diff.toStringAsFixed(1)} kg since first log'
                    : '${diff.toStringAsFixed(1)} kg since first log',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: diff >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
