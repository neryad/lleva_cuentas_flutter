import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Database/data_base_servie.dart';
import '../models/meta_ahorro_model.dart';
import '../widgets/savings_goal_card.dart';

class MetasAhorroPage extends StatefulWidget {
  const MetasAhorroPage({super.key});

  @override
  State<MetasAhorroPage> createState() => _MetasAhorroPageState();
}

class _MetasAhorroPageState extends State<MetasAhorroPage> {
  final DataBaseHelper _db = DataBaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas de Ahorro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddGoalDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<MetaAhorro>>(
        future: _db.getMetasAhorro(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final metas = snapshot.data ?? [];
          if (metas.isEmpty) {
            return const Center(
              child: Text('No hay metas de ahorro'),
            );
          }

          return ListView.builder(
            itemCount: metas.length,
            itemBuilder: (context, index) {
              final m = metas[index];
              return SavingsGoalCard(
                nombre: m.nombre,
                montoObjetivo: m.montoObjetivo,
                montoActual: m.montoActual,
                fechaLimite: m.fechaLimite?.substring(0, 10),
                colorHex: m.color,
                completada: m.completada,
                onAddMoney: m.completada
                    ? null
                    : () => _showAddMoneyDialog(m),
                onDelete: () => _deleteGoal(m),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddGoalDialog() {
    final nombreController = TextEditingController();
    final montoController = TextEditingController();
    DateTime? fechaLimite;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nueva meta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la meta',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: montoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monto objetivo',
                      prefixText: '\$ ',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Fecha límite (opcional)'),
                    subtitle: Text(
                      fechaLimite != null
                          ? DateFormat('dd/MM/yyyy').format(fechaLimite!)
                          : 'No seleccionada',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          fechaLimite = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (nombreController.text.isNotEmpty &&
                        montoController.text.isNotEmpty) {
                      final meta = MetaAhorro(
                        nombre: nombreController.text,
                        montoObjetivo: double.parse(montoController.text),
                        fechaLimite: fechaLimite?.toIso8601String(),
                      );
                      await _db.newMetaAhorro(meta);
                      if (mounted) {
                        Navigator.pop(context);
                        setState(() {});
                      }
                    }
                  },
                  child: const Text('Crear'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddMoneyDialog(MetaAhorro meta) {
    final montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar a "${meta.nombre}"'),
          content: TextField(
            controller: montoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monto a agregar',
              prefixText: '\$ ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (montoController.text.isNotEmpty) {
                  final monto = double.parse(montoController.text);
                  meta.montoActual += monto;
                  if (meta.montoActual >= meta.montoObjetivo) {
                    meta.completada = true;
                  }
                  await _db.updateMetaAhorro(meta);
                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {});
                  }
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGoal(MetaAhorro meta) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar meta'),
        content: Text('¿Eliminar "${meta.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _db.deleteMetaAhorro(meta.id!);
      setState(() {});
    }
  }
}
