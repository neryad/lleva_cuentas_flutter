import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/Dashboard/widgets/bar_chart_widget.dart';
import 'package:lleva_cuentas/Dashboard/widgets/pie_chart_widget.dart';

class DashboardPage extends StatelessWidget {
  final Account account;

  const DashboardPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - ${account.name}'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Transactions>>(
        future: DataBaseHelper.instance.getTransactionsById(account.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final transactions = snapshot.data ?? [];

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'Sin datos para mostrar',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega transacciones para ver gráficas',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          final ahorro = transactions
              .where((t) => t.type == 'Ahorro')
              .fold<double>(0, (sum, t) => sum + t.amount);
          final gasto = transactions
              .where((t) => t.type == 'Gasto')
              .fold<double>(0, (sum, t) => sum + t.amount);
          final ingreso = transactions
              .where((t) => t.type == 'Ingreso')
              .fold<double>(0, (sum, t) => sum + t.amount);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribución por Tipo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: PieChartWidget(
                      ahorro: ahorro,
                      gasto: gasto,
                      ingreso: ingreso,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Comparación Mensual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: DataBaseHelper.instance
                      .getMonthlyTransactions(account.id!),
                  builder: (context, monthlySnapshot) {
                    if (monthlySnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final monthlyData = monthlySnapshot.data ?? [];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: BarChartWidget(monthlyData: monthlyData),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _summaryRow(
                          'Total Ahorro',
                          ahorro,
                          colorScheme.primary,
                          myFormat,
                        ),
                        _summaryRow(
                          'Total Gasto',
                          gasto,
                          colorScheme.error,
                          myFormat,
                        ),
                        _summaryRow(
                          'Total Ingreso',
                          ingreso,
                          Colors.green,
                          myFormat,
                        ),
                        const Divider(),
                        _summaryRow(
                          'Balance',
                          ahorro + ingreso - gasto,
                          colorScheme.onSurface,
                          myFormat,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double amount,
    Color color,
    NumberFormat format, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          Text(
            '\$${format.format(amount.toInt())}',
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
