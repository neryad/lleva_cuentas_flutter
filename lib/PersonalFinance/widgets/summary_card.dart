import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatelessWidget {
  final double ingresos;
  final double gastos;
  final double balance;
  final int mes;
  final int anio;

  const SummaryCard({
    super.key,
    required this.ingresos,
    required this.gastos,
    required this.balance,
    required this.mes,
    required this.anio,
  });

  String _mesNombre(int mes) {
    const nombres = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return nombres[mes];
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_mesNombre(mes)} $anio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryItem(
                  label: 'Ingresos',
                  amount: ingresos,
                  color: Colors.green,
                  formatter: formatter,
                ),
                _SummaryItem(
                  label: 'Gastos',
                  amount: gastos,
                  color: Colors.red,
                  formatter: formatter,
                ),
                _SummaryItem(
                  label: 'Balance',
                  amount: balance,
                  color: balance >= 0 ? Colors.blue : Colors.red,
                  formatter: formatter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final NumberFormat formatter;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
