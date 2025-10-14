// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
// import 'package:lleva_cuentas/Database/account_model.dart';
// import 'package:lleva_cuentas/Database/data_base_servie.dart';
// // import 'package:intl/intl.dart';

// class AmountPage extends StatefulWidget {
//   const AmountPage({super.key, required this.account});
//   final Account account;

//   @override
//   State<AmountPage> createState() => _AmountPageState();
// }

// class _AmountPageState extends State<AmountPage> {
//   String? dropdownValue = 'Ahorro';
//   String? savedDate = '';
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController commentController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     Account account = widget.account;
//     var items = ['Ahorro', 'Gasto', 'Ingreso'];
//     return Scaffold(
//       backgroundColor: const Color(0xff1e234b),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xff1e234b),
//         title: const Text(
//           'Nueva transacción',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: BackButton(
//           color: Colors.white,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20))),
//               width: MediaQuery.of(context).size.width,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         children: [
//                           const Text(
//                             'Seleccionar tipo',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.w500),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           DropdownButton(
//                             underline: const SizedBox.shrink(),
//                             value: dropdownValue,
//                             items: items.map((String items) {
//                               return DropdownMenuItem(
//                                 value: items,
//                                 child: Text(
//                                   items,
//                                   style: const TextStyle(
//                                       fontSize: 25,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: ((value) {
//                               setState(() {
//                                 dropdownValue = value.toString();
//                               });
//                             }),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Monto',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.w500),
//                           ),
//                           TextField(
//                             controller: amountController,
//                             keyboardType: TextInputType.number,
//                             style: const TextStyle(fontSize: 25),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('Fecha transacción',
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.w500)),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextField(
//                             controller: dateController,
//                             decoration: const InputDecoration(
//                                 icon: Icon(Icons.calendar_today),
//                                 labelText: 'Colocar fecha'),
//                             onTap: () async {
//                               var currentYear = DateTime.now().year;
//                               var distanceYear = currentYear + 100;
//                               DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(currentYear),
//                                   lastDate: DateTime(distanceYear));

//                               if (pickedDate != null) {
//                                 dateController.text = pickedDate.toString();

//                                 setState(() {
//                                   dateController.text = DateFormat('dd-MM-yyyy')
//                                       .format(pickedDate);

//                                   savedDate = pickedDate.toString();
//                                 });
//                               }
//                             },
//                             readOnly: true,
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Comentario',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.w500),
//                           ),
//                           TextField(
//                             controller: commentController,
//                             style: const TextStyle(fontSize: 15),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 120,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.7,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(),
//                                 onPressed: () {
//                                   if (amountController.text.isEmpty ||
//                                       commentController.text.isEmpty ||
//                                       savedDate.toString().isEmpty ||
//                                       dropdownValue!.isEmpty) {
//                                     alert();
//                                     return;
//                                   }
//                                   var newTransaction = Transactions(
//                                       type: dropdownValue!,
//                                       amount:
//                                           double.parse(amountController.text),
//                                       date: savedDate.toString(),
//                                       comment: commentController.text,
//                                       accountId: account.id!);
//                                   saveTransactions(newTransaction);
//                                 },
//                                 child: const Text(
//                                   'Guardar',
//                                   style: TextStyle(fontSize: 20),
//                                 )),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   saveTransactions(Transactions transactions) {
//     // ignore: unnecessary_null_comparison
//     if (transactions != null) {
//       DataBaseHelper.instance.addTransaction(transactions);
//       clearController();
//       return;
//     }
//   }

//   alert() {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Aviso"),
//           content: const Text("No se permiten campos vacíos!"),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   clearController() {
//     amountController.clear();
//     commentController.clear();
//     dateController.clear();
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';

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
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
    commentController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account account = widget.account;
    var items = ['Ahorro', 'Gasto', 'Ingreso'];

    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Nueva Transacción',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Selector de tipo ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tipo de Transacción',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1e234b),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                underline: const SizedBox.shrink(),
                                isExpanded: true,
                                value: dropdownValue,
                                items: items.map((String item) {
                                  IconData icon;
                                  Color color;

                                  if (item == 'Ahorro') {
                                    icon = Icons.savings;
                                    color = Colors.blue;
                                  } else if (item == 'Gasto') {
                                    icon = Icons.arrow_downward_rounded;
                                    color = Colors.red;
                                  } else {
                                    icon = Icons.arrow_upward_rounded;
                                    color = Colors.green;
                                  }

                                  return DropdownMenuItem(
                                    value: item,
                                    child: Row(
                                      children: [
                                        Icon(icon, color: color, size: 20),
                                        const SizedBox(width: 10),
                                        Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff1e234b),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValue = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // --- Monto ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Monto',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1e234b),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'El monto es obligatorio';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Ingresa un monto válido';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '0.00',
                                prefixIcon: const Icon(
                                  Icons.attach_money,
                                  color: Color(0xff1e234b),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xffe0e0e0),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xff1e234b),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // --- Fecha ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fecha de Transacción',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1e234b),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: dateController,
                              readOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'La fecha es obligatoria';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Selecciona una fecha',
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xff1e234b),
                                ),
                                suffixIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xff1e234b),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xffe0e0e0),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xff1e234b),
                                    width: 2,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                var currentYear = DateTime.now().year;
                                var distanceYear = currentYear + 100;
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(currentYear - 5),
                                  lastDate: DateTime(distanceYear),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    dateController.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    savedDate = pickedDate.toIso8601String();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // --- Comentario ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Comentario',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1e234b),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: commentController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Agrega una descripción';
                                }
                                return null;
                              },
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Describe esta transacción...',
                                prefixIcon: const Icon(
                                  Icons.description_outlined,
                                  color: Color(0xff1e234b),
                                ),
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xffe0e0e0),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xff1e234b),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // --- Botones de acción ---
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  side: const BorderSide(
                                    color: Color(0xff1e234b),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1e234b),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1e234b),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    var newTransaction = Transactions(
                                      type: dropdownValue!,
                                      amount:
                                          double.parse(amountController.text),
                                      date: savedDate.toString(),
                                      comment: commentController.text,
                                      accountId: account.id!,
                                    );
                                    saveTransactions(newTransaction);
                                  }
                                },
                                child: const Text(
                                  'Guardar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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
    DataBaseHelper.instance.addTransaction(transactions);
    clearController();
    Navigator.pop(context);
  }

  clearController() {
    amountController.clear();
    commentController.clear();
    dateController.clear();
    savedDate = '';
  }
}
