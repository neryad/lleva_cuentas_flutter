import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
// import 'package:intl/intl.dart';

class AmountPage extends StatefulWidget {
  const AmountPage({super.key, required this.account});
  final Account account;

  @override
  State<AmountPage> createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  String? dropdownValue = 'Ahorro';
  String? savedDate = '';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Account account = widget.account;
    var items = ['Ahorro', 'Gasto', 'Ingreso'];
    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1e234b),
        title: const Text(
          'Nueva transacción',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Seleccionar tipo',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          DropdownButton(
                            underline: const SizedBox.shrink(),
                            value: dropdownValue,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: ((value) {
                              setState(() {
                                dropdownValue = value.toString();
                              });
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monto',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 25),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Fecha transacción',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: dateController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                labelText: 'Colocar fecha'),
                            onTap: () async {
                              var currentYear = DateTime.now().year;
                              var distanceYear = currentYear + 100;
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(currentYear),
                                  lastDate: DateTime(distanceYear));

                              if (pickedDate != null) {
                                dateController.text = pickedDate.toString();

                                setState(() {
                                  dateController.text = DateFormat('dd-MM-yyyy')
                                      .format(pickedDate);

                                  savedDate = pickedDate.toString();
                                });
                              }
                            },
                            readOnly: true,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comentario',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          TextField(
                            controller: commentController,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(),
                                onPressed: () {
                                  if (amountController.text.isEmpty ||
                                      commentController.text.isEmpty ||
                                      savedDate.toString().isEmpty ||
                                      dropdownValue!.isEmpty) {
                                    alert();
                                    return;
                                  }
                                  var newTransaction = Transactions(
                                      type: dropdownValue!,
                                      amount:
                                          double.parse(amountController.text),
                                      date: savedDate.toString(),
                                      comment: commentController.text,
                                      accountId: account.id!);
                                  saveTransactions(newTransaction);
                                },
                                child: const Text(
                                  'Guardar',
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  saveTransactions(Transactions transactions) {
    // ignore: unnecessary_null_comparison
    if (transactions != null) {
      DataBaseHelper.instance.addTransaction(transactions);
      clearController();
      return;
    }
  }

  alert() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Aviso"),
          content: const Text("No se permiten campos vacíos!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  clearController() {
    amountController.clear();
    commentController.clear();
    dateController.clear();
  }
}
