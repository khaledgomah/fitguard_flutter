import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class BiometricsScreen extends StatelessWidget {
  const BiometricsScreen({super.key, required this.authController});
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return _BiometricsScreenView(authController: authController);
  }
}

class _BiometricsScreenView extends StatelessWidget {
  final AuthController authController;

  const _BiometricsScreenView({required this.authController});

  @override
  Widget build(BuildContext context) {
    final user = authController.user;
    final theme = Theme.of(context);

    // Calculate BMI
    double bmi = 0;
    if (user != null) {
      final heightInMeters = user.height / 100;
      if (heightInMeters > 0) {
        bmi = user.weight / (heightInMeters * heightInMeters);
      }
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Biometrics', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _StatRow(bmi: bmi, weight: user?.weight, height: user?.height),
          const SizedBox(height: 24),
          _HeartRateVariabilityCard(),
          const SizedBox(height: 24),
          _SleepQualityCard(),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final double bmi;
  final double? weight;
  final double? height;

  const _StatRow({required this.bmi, this.weight, this.height});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(title: 'Weight', value: weight != null ? '${weight}kg' : '--')),
        const SizedBox(width: 16),
        Expanded(child: _StatCard(title: 'Height', value: height != null ? '${height}cm' : '--')),
        const SizedBox(width: 16),
        Expanded(child: _StatCard(title: 'BMI', value: bmi > 0 ? bmi.toStringAsFixed(1) : '--', color: _getBmiColor(bmi))),
      ],
    );
  }

  Color _getBmiColor(double bmi) {
    if (bmi == 0) return Colors.grey;
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _StatCard({required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(title, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartRateVariabilityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Heart Rate Variability (HRV)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Icon(Icons.favorite, color: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 8),
          Text('Your HRV is trending 12% higher than last week. Excellent recovery.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 50),
                      FlSpot(1, 55),
                      FlSpot(2, 65),
                      FlSpot(3, 62),
                      FlSpot(4, 75),
                      FlSpot(5, 80),
                      FlSpot(6, 82),
                    ],
                    isCurved: true,
                    color: Colors.redAccent,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.redAccent.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepQualityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurpleAccent.withOpacity(0.05),
            Colors.deepPurpleAccent.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sleep Quality', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.nights_stay, color: Colors.deepPurpleAccent, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Avg. 7h 15m this week.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()], style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 12,
                barGroups: [
                  _buildSleepBarGroup(0, 6),
                  _buildSleepBarGroup(1, 7.5),
                  _buildSleepBarGroup(2, 5),
                  _buildSleepBarGroup(3, 8),
                  _buildSleepBarGroup(4, 7),
                  _buildSleepBarGroup(5, 8.5),
                  _buildSleepBarGroup(6, 6.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildSleepBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 16,
          gradient: const LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purple],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Colors.deepPurpleAccent.withOpacity(0.1),
          ),
        )
      ],
    );
  }
}
