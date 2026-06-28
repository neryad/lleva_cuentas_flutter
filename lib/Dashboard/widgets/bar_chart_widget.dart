import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;

  const BarChartWidget({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (monthlyData.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Sin datos mensuales',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final months = monthlyData
        .map((e) => e['month'] as String)
        .toSet()
        .toList()
      ..sort();

    final last6Months =
        months.length > 6 ? months.sublist(months.length - 6) : months;

    final groups = <int, List<BarChartGroupData>>{};
    for (var i = 0; i < last6Months.length; i++) {
      final month = last6Months[i];
      final ahorro = monthlyData
          .where((e) => e['month'] == month && e['type'] == 'Ahorro')
          .fold<double>(0, (sum, e) => sum + (e['total'] as double));
      final gasto = monthlyData
          .where((e) => e['month'] == month && e['type'] == 'Gasto')
          .fold<double>(0, (sum, e) => sum + (e['total'] as double));
      final ingreso = monthlyData
          .where((e) => e['month'] == month && e['type'] == 'Ingreso')
          .fold<double>(0, (sum, e) => sum + (e['total'] as double));

      groups[i] = [
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: ahorro,
              color: colorScheme.primary,
              width: 8,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(2)),
            ),
            BarChartRodData(
              toY: gasto,
              color: colorScheme.error,
              width: 8,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(2)),
            ),
            BarChartRodData(
              toY: ingreso,
              color: Colors.green,
              width: 8,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(2)),
            ),
          ],
        ),
      ];
    }

    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(monthlyData),
                barGroups: groups.entries.expand((e) => e.value).toList(),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= last6Months.length) {
                          return const SizedBox.shrink();
                        }
                        final parts = last6Months[idx].split('-');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${parts[1]}/${parts[0].substring(2)}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
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
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem(colorScheme.primary, 'Ahorro'),
              const SizedBox(width: 16),
              _legendItem(colorScheme.error, 'Gasto'),
              const SizedBox(width: 16),
              _legendItem(Colors.green, 'Ingreso'),
            ],
          ),
        ],
      ),
    );
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    double max = 0;
    for (var entry in data) {
      final total = (entry['total'] as double).abs();
      if (total > max) max = total;
    }
    return max == 0 ? 100 : max * 1.2;
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
