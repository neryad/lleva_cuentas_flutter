import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../Database/data_base_servie.dart';
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
        final Map<int, Map<String, double>> monthlyData = {};

        for (int i = 5; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i, 1);
          monthlyData[month.month] = {'ingresos': 0, 'gastos': 0};
        }

        for (var t in transactions) {
          final date = DateTime.parse(t.date);
          final monthKey = date.month;
          if (monthlyData.containsKey(monthKey)) {
            if (t.type == 'Ingreso' || t.type == 'Ahorro') {
              monthlyData[monthKey]!['ingresos'] =
                  (monthlyData[monthKey]!['ingresos'] ?? 0) + t.amount;
            } else {
              monthlyData[monthKey]!['gastos'] =
                  (monthlyData[monthKey]!['gastos'] ?? 0) + t.amount;
            }
          }
        }

        final ingresosData = <BarChartGroupData>[];
        final gastosData = <BarChartGroupData>[];
        int index = 0;

        monthlyData.forEach((month, data) {
          ingresosData.add(BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data['ingresos']!,
                color: Colors.green,
                width: 12,
              ),
            ],
          ));
          gastosData.add(BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data['gastos']!,
                color: Colors.red,
                width: 12,
              ),
            ],
          ));
          index++;
        });

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
                      barGroups: [
                        ...ingresosData,
                        ...gastosData,
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
                              if (value.toInt() < months.length) {
                                return Text(months[value.toInt()]);
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
                              return Text('\$${value.toInt()}');
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
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      title: 'Alimentación',
                      color: Colors.orange,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 25,
                      title: 'Transporte',
                      color: Colors.blue,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Servicios',
                      color: Colors.purple,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 15,
                      title: 'Otros',
                      color: Colors.grey,
                      radius: 80,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceLineChart() {
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
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
                          if (value.toInt() < months.length) {
                            return Text(months[value.toInt()]);
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
                          return Text('\$${value.toInt()}');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1000),
                        FlSpot(1, 1500),
                        FlSpot(2, 800),
                        FlSpot(3, 2000),
                        FlSpot(4, 1800),
                        FlSpot(5, 2500),
                      ],
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
  }
}
