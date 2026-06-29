import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../dashboard/data/models/dashboard_stats.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key, required this.authController});
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return _ReportsScreenView(authController: authController);
  }
}

class _ReportsScreenView extends StatelessWidget {
  const _ReportsScreenView({required this.authController});
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Analytics & Reports',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReportsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is ReportsLoaded) {
            final stats = state.stats;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionTitle(context, 'Injury Severity Breakdown'),
                _SeverityPieChart(severityBreakdown: stats.severityBreakdown),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Most Affected Muscle Groups'),
                _MuscleGroupsBarChart(topMuscleGroups: stats.topMuscleGroups),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Weekly Activity History'),
                _ActivityHistoryLineChart(
                  activityHistory: stats.activityHistory,
                ),
                const SizedBox(height: 32),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SeverityPieChart extends StatelessWidget {
  final SeverityBreakdown severityBreakdown;

  const _SeverityPieChart({required this.severityBreakdown});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mild = severityBreakdown.mild.toDouble();
    final moderate = severityBreakdown.moderate.toDouble();
    final severe = severityBreakdown.severe.toDouble();
    final total = mild + moderate + severe;

    if (total == 0) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'No injury data available',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: mild,
              title: '${((mild / total) * 100).toInt()}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: moderate,
              title: '${((moderate / total) * 100).toInt()}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: severe,
              title: '${((severe / total) * 100).toInt()}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuscleGroupsBarChart extends StatelessWidget {
  final List<TopMuscleGroup> topMuscleGroups;

  const _MuscleGroupsBarChart({required this.topMuscleGroups});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (topMuscleGroups.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'No muscle group data available',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final double maxVal = topMuscleGroups.fold(
      0,
      (max, e) => e.count > max ? e.count.toDouble() : max,
    );

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal + 1,
          barTouchData: const BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() < topMuscleGroups.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        topMuscleGroups[value.toInt()].name.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: topMuscleGroups.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.count.toDouble(),
                  color: theme.colorScheme.primary,
                  width: 22,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ActivityHistoryLineChart extends StatelessWidget {
  final List<ActivityHistory> activityHistory;

  const _ActivityHistoryLineChart({required this.activityHistory});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (activityHistory.isEmpty) return const SizedBox.shrink();

    final spots = activityHistory.asMap().entries.map((e) {
      final total = e.value.assigned;
      final completed = e.value.completed;
      final percentage = total > 0 ? (completed / total) * 100 : 0.0;
      return FlSpot(e.key.toDouble(), percentage);
    }).toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      '${value.toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < activityHistory.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        activityHistory[value.toInt()].day,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: activityHistory.length > 1
              ? (activityHistory.length - 1).toDouble()
              : 1.0,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: theme.colorScheme.secondary,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.secondary.withValues(alpha: 0.3),
                    theme.colorScheme.secondary.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
