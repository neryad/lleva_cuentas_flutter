import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecurringExpenseCard extends StatelessWidget {
  final String descripcion;
  final double monto;
  final String? categoriaNombre;
  final int diaPago;
  final bool activo;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onDelete;

  const RecurringExpenseCard({
    super.key,
    required this.descripcion,
    required this.monto,
    this.categoriaNombre,
    required this.diaPago,
    this.activo = true,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: activo ? Colors.purple.shade100 : Colors.grey.shade200,
          child: Icon(
            Icons.repeat,
            color: activo ? Colors.purple : Colors.grey,
          ),
        ),
        title: Text(
          descripcion,
          style: TextStyle(
            decoration: activo ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          'Día $diaPago${categoriaNombre != null ? ' • $categoriaNombre' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatter.format(monto),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: activo ? null : Colors.grey,
              ),
            ),
            if (onToggle != null)
              Switch(
                value: activo,
                onChanged: onToggle,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
