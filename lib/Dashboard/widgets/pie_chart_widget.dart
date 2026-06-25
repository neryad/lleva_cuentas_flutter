import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final double ahorro;
  final double gasto;
  final double ingreso;

  const PieChartWidget({
    super.key,
    required this.ahorro,
    required this.gasto,
    required this.ingreso,
  });

  @override
  Widget build(BuildContext context) {
    final total = ahorro + gasto + ingreso;
    final colorScheme = Theme.of(context).colorScheme;

    if (total == 0) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Sin datos para mostrar',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: ahorro,
                    color: colorScheme.primary,
                    title: '${((ahorro / total) * 100).round()}%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: gasto,
                    color: colorScheme.error,
                    title: '${((gasto / total) * 100).round()}%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: ingreso,
                    color: Colors.green,
                    title: '${((ingreso / total) * 100).round()}%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem(colorScheme.primary, 'Ahorro', ahorro),
              const SizedBox(height: 8),
              _legendItem(colorScheme.error, 'Gasto', gasto),
              const SizedBox(height: 8),
              _legendItem(Colors.green, 'Ingreso', ingreso),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, double value) {
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
        const SizedBox(width: 6),
        Text(
          '$label: ${value.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
