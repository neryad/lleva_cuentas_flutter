// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';

Future deleteAlert(BuildContext context, String tittle, int? id, String type) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(tittle),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () async {
                  print(type);
                  if (type == 'Transactions') {
                    await DataBaseHelper.instance.deleteTransaction(
                      id!,
                    );
                  } else {
                    await DataBaseHelper.instance.deleteAccount(id!);
                  }

                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        );
      });
}
