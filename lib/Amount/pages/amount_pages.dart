import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/Details/pages/details_page.dart';
// import 'package:intl/intl.dart';

class AmountPage extends StatefulWidget {
  const AmountPage({super.key, required this.account});
  final Account account;

  @override
  State<AmountPage> createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  String? dropdownValue = 'Ahorro';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController comentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Account account = widget.account;
    // Initial Selected Value
    // String? dropdownValue = 'Ahorro';
    // final TextEditingController amountController = TextEditingController();
    // final TextEditingController comentController = TextEditingController();
    // final TextEditingController dateController = TextEditingController();

    // List of items in our dropdown menu
    var items = ['Ahorro', 'Gasto'];
    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1e234b),
        title: const Text('Nueva transacción'),
        leading: BackButton(
          onPressed: () {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) =>
            //         DetailsPage(account: account),
            //   ),
            // );
            Navigator.of(context).pop();

            setState(() {});
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

                            // decoration: new InputDecoration(
                            //     labelText: "Enter your number"),
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
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                dateController.text = pickedDate.toString();

                                // var inputFormat =
                                //     DateFormat('yyyy-MM-dd HH:mm');
                                // var inputDate = inputFormat.parse(_date);
                                // var outputFormat = DateFormat('dd/MM/yyyy');
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                setState(() {
                                  dateController.text = pickedDate.toString();
                                });
                              }
                            },
                            readOnly: true,
                          )
                          // Row(children: [
                          //   Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text('04/11/2022',
                          //           style: TextStyle(
                          //               fontSize: 20,
                          //               fontWeight: FontWeight.w500)),
                          //       Row(
                          //         children: [
                          //           // Text('Tap para cambiar la fecha',
                          //           //     style: TextStyle(
                          //           //         fontSize: 20,
                          //           //         fontWeight: FontWeight.w500)),
                          //           IconButton(
                          //             onPressed: () {},
                          //             icon: Icon(Icons.calendar_month),
                          //           ),
                          //         ],
                          //       )
                          //     ],
                          //   )
                          // ])
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
                            controller: comentController,
                            //keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            onChanged: (v) => comentController.text = v,
                            // decoration: new InputDecoration(
                            //     labelText: "Enter your number"),
                          )
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
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff1e234b),
                                ),
                                onPressed: () {
                                  var newTransaction = Transactions(
                                      type: dropdownValue!,
                                      amount:
                                          double.parse(amountController.text),
                                      date: dateController.text,
                                      comment: comentController.text,
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
    if (transactions != null) {
      DataBaseHelper.instance.addTransaction(transactions);
      clearController();
      return;
    }
  }

  clearController() {
    amountController.clear();
    comentController.clear();
    dateController.clear();
  }
}
