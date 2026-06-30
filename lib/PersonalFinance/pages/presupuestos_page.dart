import 'package:flutter/material.dart';
import '../../Database/data_base_servie.dart';
import '../../Database/category_model.dart';
import '../models/presupuesto_model.dart';
import '../widgets/budget_progress_card.dart';

class PresupuestosPage extends StatefulWidget {
  const PresupuestosPage({super.key});

  @override
  State<PresupuestosPage> createState() => _PresupuestosPageState();
}

class _PresupuestosPageState extends State<PresupuestosPage> {
  final DataBaseHelper _db = DataBaseHelper.instance;
  late int _mes;
  late int _anio;
  List<Category> _categorias = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mes = now.month;
    _anio = now.year;
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
        title: const Text('Presupuestos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddBudgetDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Presupuesto>>(
        future: _db.getPresupuestos(_mes, _anio),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final presupuestos = snapshot.data ?? [];
          if (presupuestos.isEmpty) {
            return const Center(
              child: Text('No hay presupuestos este mes'),
            );
          }

          return FutureBuilder<Map<int, double>>(
            future: _db.getGastosPorCategoria(_mes, _anio),
            builder: (context, gastosSnapshot) {
              final gastosPorCategoria = gastosSnapshot.data ?? {};

              return ListView.builder(
                itemCount: presupuestos.length,
                itemBuilder: (context, index) {
                  final p = presupuestos[index];
                  final cat = _categorias.firstWhere(
                    (c) => c.id == p.categoriaId,
                    orElse: () => Category(
                      nombre: 'Sin categoría',
                      tipo: 'General',
                      color: '#9E9E9E',
                    ),
                  );
                  final gastado = gastosPorCategoria[p.categoriaId] ?? 0;
                  return BudgetProgressCard(
                    categoriaNombre: cat.nombre,
                    colorHex: cat.color,
                    montoLimite: p.montoLimite,
                    montoGastado: gastado,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showAddBudgetDialog() {
    int? selectedCategoryId;
    final montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo presupuesto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Categoría'),
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
                controller: montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto límite',
                  prefixText: '\$ ',
                ),
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
                if (selectedCategoryId != null &&
                    montoController.text.isNotEmpty) {
                  final presupuesto = Presupuesto(
                    categoriaId: selectedCategoryId!,
                    montoLimite: double.parse(montoController.text),
                    mes: _mes,
                    anio: _anio,
                  );
                  Navigator.of(context).pop();
                  await _db.newPresupuesto(presupuesto);
                  if (mounted) {
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
}
