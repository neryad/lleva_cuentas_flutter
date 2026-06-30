import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/color_utils.dart';

class SavingsGoalCard extends StatelessWidget {
  final String nombre;
  final double montoObjetivo;
  final double montoActual;
  final String? fechaLimite;
  final String? colorHex;
  final bool completada;
  final VoidCallback? onAddMoney;
  final VoidCallback? onDelete;

  const SavingsGoalCard({
    super.key,
    required this.nombre,
    required this.montoObjetivo,
    required this.montoActual,
    this.fechaLimite,
    this.colorHex,
    this.completada = false,
    this.onAddMoney,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    final progreso = montoObjetivo > 0
        ? (montoActual / montoObjetivo).clamp(0.0, 1.0)
        : 0.0;
    final color = colorHex != null ? hexToColor(colorHex!) : Colors.blue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (completada)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20)
                else
                  const Icon(Icons.savings, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: onDelete,
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
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${formatter.format(montoActual)} / ${formatter.format(montoObjetivo)}',
                    style: TextStyle(color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (fechaLimite != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    'Meta: $fechaLimite',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ],
            ),
            if (!completada && onAddMoney != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onAddMoney,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Agregar dinero'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
