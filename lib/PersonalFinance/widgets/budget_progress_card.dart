import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/color_utils.dart';

class BudgetProgressCard extends StatelessWidget {
  final String categoriaNombre;
  final String colorHex;
  final double montoLimite;
  final double montoGastado;

  const BudgetProgressCard({
    super.key,
    required this.categoriaNombre,
    required this.colorHex,
    required this.montoLimite,
    required this.montoGastado,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    final progreso = montoLimite > 0
        ? (montoGastado / montoLimite).clamp(0.0, 1.0)
        : 0.0;
    final excedido = montoGastado > montoLimite;
    final color = excedido ? Colors.red : hexToColor(colorHex);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoriaNombre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${formatter.format(montoGastado)} / ${formatter.format(montoLimite)}',
                  style: TextStyle(
                    color: excedido ? Colors.red : Colors.grey,
                    fontWeight: excedido ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progreso,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
            if (excedido)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '¡Presupuesto excedido!',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
