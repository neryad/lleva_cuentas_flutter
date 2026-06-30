import 'package:flutter/material.dart';
import '../../Database/data_base_servie.dart';
import '../../Database/category_model.dart';
import '../models/gasto_recurrente_model.dart';
import '../widgets/recurring_expense_card.dart';

class GastosRecurrentesPage extends StatefulWidget {
  const GastosRecurrentesPage({super.key});

  @override
  State<GastosRecurrentesPage> createState() => _GastosRecurrentesPageState();
}

class _GastosRecurrentesPageState extends State<GastosRecurrentesPage> {
  final DataBaseHelper _db = DataBaseHelper.instance;
  List<Category> _categorias = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final cats = await _db.getCategories();
    setState(() {
      _categorias = cats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos Recurrentes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddRecurringDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<GastoRecurrente>>(
        future: _db.getGastosRecurrentes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final gastos = snapshot.data ?? [];
          if (gastos.isEmpty) {
            return const Center(
              child: Text('No hay gastos recurrentes'),
            );
          }

          return ListView.builder(
            itemCount: gastos.length,
            itemBuilder: (context, index) {
              final g = gastos[index];
              final cat = g.categoriaId != null
                  ? _categorias.firstWhere(
                      (c) => c.id == g.categoriaId,
                      orElse: () => Category(
                        nombre: 'Sin categoría',
                        tipo: 'General',
                        color: '#9E9E9E',
                      ),
                    )
                  : null;
              return RecurringExpenseCard(
                descripcion: g.descripcion,
                monto: g.monto,
                categoriaNombre: cat?.nombre,
                diaPago: g.diaPago,
                activo: g.activo,
                onToggle: (value) async {
                  g.activo = value;
                  await _db.updateGastoRecurrente(g);
                  setState(() {});
                },
                onDelete: () => _deleteRecurring(g),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddRecurringDialog() {
    final descController = TextEditingController();
    final montoController = TextEditingController();
    final diaController = TextEditingController(text: '1');
    int? selectedCategoryId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo gasto recurrente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    prefixText: '\$ ',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Categoría (opcional)',
                  ),
                  items: _categorias
                      .where((c) => c.tipo == 'Gasto')
                      .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nombre),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedCategoryId = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: diaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Día de pago (1-31)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (descController.text.isNotEmpty &&
                    montoController.text.isNotEmpty &&
                    diaController.text.isNotEmpty) {
                  final gasto = GastoRecurrente(
                    descripcion: descController.text,
                    monto: double.parse(montoController.text),
                    categoriaId: selectedCategoryId,
                    diaPago: int.parse(diaController.text).clamp(1, 31),
                  );
                  await _db.newGastoRecurrente(gasto);
                  if (mounted && context.mounted) {
                    Navigator.pop(context);
                    setState(() {});
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRecurring(GastoRecurrente gasto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar gasto recurrente'),
        content: Text('¿Eliminar "${gasto.descripcion}"?'),
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
      await _db.deleteGastoRecurrente(gasto.id!);
      setState(() {});
    }
  }
}
