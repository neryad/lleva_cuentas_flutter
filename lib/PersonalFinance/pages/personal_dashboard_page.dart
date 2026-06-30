import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../Database/data_base_servie.dart';
import '../../Database/category_model.dart';
import '../../Amount/pages/models/transactions_model.dart';

class PersonalDashboardPage extends StatefulWidget {
  const PersonalDashboardPage({super.key});

  @override
  State<PersonalDashboardPage> createState() => _PersonalDashboardPageState();
}

class _PersonalDashboardPageState extends State<PersonalDashboardPage> {
  final DataBaseHelper _db = DataBaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Finanzas Personales')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthlyBarChart(),
            const SizedBox(height: 24),
            _buildCategoryPieChart(),
            const SizedBox(height: 24),
            _buildBalanceLineChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBarChart() {
    return FutureBuilder<List<Transactions>>(
      future: _db.getPersonalTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data ?? [];
        final now = DateTime.now();
        final Map<String, Map<String, double>> monthlyData = {};
        final List<String> monthOrder = [];

        for (int i = 5; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i, 1);
          final key = '${month.year}-${month.month.toString().padLeft(2, '0')}';
          monthlyData[key] = {'ingresos': 0, 'gastos': 0};
          monthOrder.add(key);
        }

        for (var t in transactions) {
          final date = DateTime.parse(t.date);
          final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
          if (monthlyData.containsKey(key)) {
            if (t.type == 'Ingreso' || t.type == 'Ahorro') {
              monthlyData[key]!['ingresos'] =
                  (monthlyData[key]!['ingresos'] ?? 0) + t.amount;
            } else {
              monthlyData[key]!['gastos'] =
                  (monthlyData[key]!['gastos'] ?? 0) + t.amount;
            }
          }
        }

        final barGroups = <BarChartGroupData>[];
        int index = 0;

        for (final key in monthOrder) {
          final data = monthlyData[key]!;
          barGroups.add(BarChartGroupData(
            x: index,
            barsSpace: 4,
            barRods: [
              BarChartRodData(
                toY: data['ingresos']!,
                color: Colors.green,
                width: 10,
              ),
              BarChartRodData(
                toY: data['gastos']!,
                color: Colors.red,
                width: 10,
              ),
            ],
          ));
          index++;
        }

        final allMonthNames = [
          'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
          'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
        ];
        final bottomLabels = monthOrder.map((key) {
          final monthNum = int.parse(key.split('-')[1]);
          return allMonthNames[monthNum - 1];
        }).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingresos vs Gastos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxValue(monthlyData) * 1.2,
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i >= 0 && i < bottomLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(bottomLabels[i], style: const TextStyle(fontSize: 11)),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 11));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getMaxValue(Map<int, Map<String, double>> data) {
    double max = 0;
    for (var monthData in data.values) {
      if ((monthData['ingresos'] ?? 0) > max) max = monthData['ingresos']!;
      if ((monthData['gastos'] ?? 0) > max) max = monthData['gastos']!;
    }
    return max;
  }

  Widget _buildCategoryPieChart() {
    return FutureBuilder<List<Transactions>>(
      future: _db.getPersonalTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data ?? [];
        final gastos = transactions.where((t) => t.type == 'Gasto').toList();

        if (gastos.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No hay gastos para mostrar')),
            ),
          );
        }

        return FutureBuilder<List<Category>>(
          future: _db.getCategories(),
          builder: (context, catSnapshot) {
            final categorias = catSnapshot.data ?? [];

            final Map<String, double> categoryTotals = {};
            for (var t in gastos) {
              String nombre = 'Otros';
              if (t.categoriaId != null) {
                final cat = categorias.where((c) => c.id == t.categoriaId);
                if (cat.isNotEmpty) nombre = cat.first.nombre;
              }
              categoryTotals[nombre] = (categoryTotals[nombre] ?? 0) + t.amount;
            }

            final total = categoryTotals.values.fold(0.0, (a, b) => a + b);
            final colors = [
              Colors.orange, Colors.blue, Colors.purple, Colors.green,
              Colors.red, Colors.teal, Colors.amber, Colors.indigo,
            ];

            final sections = categoryTotals.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final e = entry.value;
              final porcentaje = total > 0 ? (e.value / total * 100).toStringAsFixed(0) : '0';
              return PieChartSectionData(
                value: e.value,
                title: '$porcentaje%',
                color: colors[index % colors.length],
                radius: 80,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList();

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distribución por categoría',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...categoryTotals.entries.toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final e = entry.value;
                      final porcentaje = total > 0 ? (e.value / total * 100).toStringAsFixed(0) : '0';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colors[index % colors.length],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${e.key}: $porcentaje%'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBalanceLineChart() {
    return FutureBuilder<List<Transactions>>(
      future: _db.getPersonalTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data ?? [];
        final now = DateTime.now();
        final Map<int, double> monthlyBalance = {};

        for (int i = 5; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i, 1);
          monthlyBalance[month.month] = 0;
        }

        for (var t in transactions) {
          final date = DateTime.parse(t.date);
          final monthKey = date.month;
          if (monthlyBalance.containsKey(monthKey)) {
            if (t.type == 'Ingreso' || t.type == 'Ahorro') {
              monthlyBalance[monthKey] = monthlyBalance[monthKey]! + t.amount;
            } else {
              monthlyBalance[monthKey] = monthlyBalance[monthKey]! - t.amount;
            }
          }
        }

        final spots = <FlSpot>[];
        final monthLabels = <String>[];
        final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
        int index = 0;

        monthlyBalance.forEach((month, balance) {
          spots.add(FlSpot(index.toDouble(), balance));
          monthLabels.add(months[month - 1]);
          index++;
        });

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Evolución del balance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i >= 0 && i < monthLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(monthLabels[i], style: const TextStyle(fontSize: 11)),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 11));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
