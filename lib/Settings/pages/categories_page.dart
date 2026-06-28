import 'package:flutter/material.dart';
import 'package:lleva_cuentas/Database/category_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _selectedType = 'Gasto';
  final List<String> _types = ['Ingreso', 'Gasto', 'Ahorro'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categorías',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        centerTitle: true,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Type selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SegmentedButton<String>(
              segments: _types.map((type) {
                IconData icon;
                if (type == 'Ingreso') {
                  icon = Icons.arrow_upward_rounded;
                } else if (type == 'Gasto') {
                  icon = Icons.arrow_downward_rounded;
                } else {
                  icon = Icons.savings;
                }
                return ButtonSegment<String>(
                  value: type,
                  label: Text(type),
                  icon: Icon(icon, size: 18),
                );
              }).toList(),
              selected: {_selectedType},
              onSelectionChanged: (Set<String> selected) {
                setState(() {
                  _selectedType = selected.first;
                });
              },
            ),
          ),
          // Categories list
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: DataBaseHelper.instance.getCategoriesByType(_selectedType),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final categories = snapshot.data ?? [];
                if (categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category_outlined,
                            size: 64, color: colorScheme.outline.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Sin categorías',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _categoryCard(context, category, colorScheme);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(
      BuildContext context, Category category, ColorScheme colorScheme) {
    Color parseColor(String? hex) {
      if (hex == null) return Colors.grey;
      try {
        return Color(int.parse(hex.replaceFirst('#', '0xFF')));
      } catch (_) {
        return Colors.grey;
      }
    }

    final categoryColor = parseColor(category.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.label,
            color: categoryColor,
            size: 22,
          ),
        ),
        title: Text(
          category.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: category.esPredefinida
            ? const Text('Predefinida', style: TextStyle(fontSize: 12))
            : null,
        trailing: category.esPredefinida
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: colorScheme.primary, size: 20),
                    onPressed: () => _showEditCategoryDialog(context, category),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: colorScheme.error, size: 20),
                    onPressed: () => _confirmDelete(context, category),
                  ),
                ],
              ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedColor = '#9E9E9E';

    final colors = [
      '#F44336', '#E91E63', '#9C27B0', '#673AB7',
      '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4',
      '#009688', '#4CAF50', '#8BC34A', '#CDDC39',
      '#FFC107', '#FF9800', '#FF5722', '#795548',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Nueva Categoría'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipo:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      style: SegmentedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                      segments: _types.map((type) {
                        return ButtonSegment<String>(
                          value: type,
                          label: Text(type),
                        );
                      }).toList(),
                      selected: {_selectedType},
                      onSelectionChanged: (Set<String> selected) {
                        setDialogState(() {
                          _selectedType = selected.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Color:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: colors.map((hex) {
                        final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                        final isSelected = selectedColor == hex;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedColor = hex;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Ingresa un nombre')),
                      );
                      return;
                    }
                    try {
                      await DataBaseHelper.instance.addCategory(
                        Category(
                          nombre: nameController.text.trim(),
                          tipo: _selectedType,
                          color: selectedColor,
                          esPredefinida: false,
                        ),
                      );
                      Navigator.pop(context);
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
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

  void _showEditCategoryDialog(BuildContext context, Category category) {
    final nameController = TextEditingController(text: category.nombre);
    String selectedColor = category.color;

    final colors = [
      '#F44336', '#E91E63', '#9C27B0', '#673AB7',
      '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4',
      '#009688', '#4CAF50', '#8BC34A', '#CDDC39',
      '#FFC107', '#FF9800', '#FF5722', '#795548',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Editar Categoría'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Color:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: colors.map((hex) {
                        final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                        final isSelected = selectedColor == hex;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedColor = hex;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Ingresa un nombre')),
                      );
                      return;
                    }
                    await DataBaseHelper.instance.updateCategory(
                      Category(
                        id: category.id,
                        nombre: nameController.text.trim(),
                        tipo: category.tipo,
                        color: selectedColor,
                        esPredefinida: category.esPredefinida,
                      ),
                    );
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar categoría'),
        content: Text(
            '¿Eliminar "${category.nombre}"? Las transacciones usarán "Sin categoría".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              await DataBaseHelper.instance.deleteCategory(category.id!);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
