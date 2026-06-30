import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Database/data_base_servie.dart';
import '../../Database/category_model.dart';
import '../../Amount/pages/models/transactions_model.dart';

class AddPersonalTransactionPage extends StatefulWidget {
  final String? initialType;

  const AddPersonalTransactionPage({super.key, this.initialType});

  @override
  State<AddPersonalTransactionPage> createState() =>
      _AddPersonalTransactionPageState();
}

class _AddPersonalTransactionPageState extends State<AddPersonalTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  String _type = 'Gasto';
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _type = widget.initialType!;
    }
    _loadCategories();
  }

  void _loadCategories() async {
    final categories = await DataBaseHelper.instance.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _categories.where((c) {
      if (_type == 'Ingreso') return c.tipo == 'Ingreso';
      if (_type == 'Gasto') return c.tipo == 'Gasto';
      return c.tipo == 'Ahorro';
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva transacción'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Gasto', label: Text('Gasto')),
                    ButtonSegment(value: 'Ingreso', label: Text('Ingreso')),
                  ButtonSegment(value: 'Ahorro', label: Text('Ahorro')),
                ],
                selected: {_type},
                onSelectionChanged: (selected) {
                  setState(() {
                    _type = selected.first;
                    _selectedCategoryId = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: filteredCategories.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Fecha'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comentario (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final transaction = Transactions(
      type: _type,
      amount: double.parse(_amountController.text),
      date: _selectedDate.toIso8601String(),
      comment: _commentController.text,
      accountId: 0,
      categoriaId: _selectedCategoryId,
      source: 'personal',
    );

    await DataBaseHelper.instance.addTransaction(transaction);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
