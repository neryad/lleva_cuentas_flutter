import 'package:flutter/material.dart';

class AddPersonalTransactionPage extends StatelessWidget {
  final String? initialType;

  const AddPersonalTransactionPage({super.key, this.initialType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(initialType != null ? 'Nuevo $initialType' : 'Nueva Transacción'),
      ),
      body: Center(
        child: Text('Agregar Transacción - Próximamente'),
      ),
    );
  }
}
