// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
// import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
// import 'package:lleva_cuentas/Database/account_model.dart';
// import 'package:lleva_cuentas/Database/data_base_servie.dart';
// import 'package:lleva_cuentas/Home/widgets/alert.dart';

// class DetailsPage extends StatefulWidget {
//   const DetailsPage({super.key, required this.account});
//   final Account account;

//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }

// @override
// class _DetailsPageState extends State<DetailsPage> {
//   String dropDownValue = 'Ahorro';
//   NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
//   final items = ['Ahorro', 'Gasto', 'Ingreso'];
//   final TextEditingController dateController = TextEditingController();
//   final editFormKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     //refresh the page here

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Account account = widget.account;

//     return Scaffold(
//       backgroundColor: const Color(0xff1e234b),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xff1e234b),
//         // title: const Text('Amara'),
//         actions: [
//           CircleAvatar(
//             backgroundColor: Colors.white,
//             child: IconButton(
//               color: const Color(0xff1e234b),
//               onPressed: () {
//                 //Navigator.pushNamed(context, 'amount');
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AmountPage(account: account)))
//                     .then((value) {
//                   setState(() {});
//                 });
//               },
//               icon: const Icon(Icons.add),
//             ),
//           )
//         ],
//         leading: BackButton(
//           color: Colors.white,
//           onPressed: () {
//             // Navigator.push(context,
//             //     MaterialPageRoute(builder: (context) => const HomePage()));
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: FutureBuilder<List<Transactions>>(
//           future: DataBaseHelper.instance.getTransactionsById(account.id!),
//           builder: ((context, AsyncSnapshot<List<Transactions>> snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             final transactions = snapshot.data;
//             transactions!.sort(((a, b) => b.date.compareTo(a.date)));
//             var total = getTotal(transactions).toInt();
//             var total2 = myFormat.format(total);
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Total ${account.name}',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('\u0024 $total2 ',
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 45,
//                             fontWeight: FontWeight.w800))
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20))),
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     // color: Colors.white,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(15.0),
//                           child: Text(
//                             'Listado de transacciones',
//                             style: TextStyle(
//                                 color: Color(0xff1e234b),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20.0),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15.0,
//                         ),
//                         Expanded(
//                           child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: listCards(transactions)),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           })),
//     );
//   }

//   double getTotal(Iterable<Transactions>? transactions) =>
//       transactions?.isNotEmpty != true
//           ? 0
//           : transactions
//                   ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
//                   .reduce((value, element) => value + element) ??
//               0;
//   Widget listCards(List<Transactions>? transactions) {
//     if (transactions!.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.all(8),
//         child: Center(
//           child: Text('No tienes transacciones registradas'),
//         ),
//       );
//     }

//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       itemCount: transactions.length,
//       itemBuilder: (context, index) {
//         return card(transactions[index], context);
//       },
//     );
//   }

//   card(Transactions transactions, BuildContext context) {
//     return Card(
//         //color: Theme.of(context).colorScheme.background,
//         elevation: 0,
//         child: Column(
//           children: [
//             Text(
//               DateFormat('MMM d, yyyy')
//                   .format(DateTime.parse(transactions.date))
//                   .toString(),
//               style: const TextStyle(
//                   color: Color(0xff1e234b), fontWeight: FontWeight.bold),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   // ignore: prefer_const_literals_to_create_immutables
//                   children: [
//                     const CircleAvatar(
//                         backgroundColor: Color(0xffecedf6),
//                         // ignore: unnecessary_const
//                         child: Icon(
//                           Icons.monetization_on_outlined,
//                           color: Color(0xff1e234b),
//                         )),
//                     const SizedBox(
//                       width: 10.0,
//                     ),
//                     Column(
//                       children: [
//                         const SizedBox(
//                           height: 8.0,
//                         ),
//                         Text(
//                           transactions.comment,
//                           style: const TextStyle(
//                               color: Color(0xff1e234b),
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Column(
//                       children: [
//                         transactions.type == 'Gasto'
//                             ? Text(
//                                 '-${transactions.amount.toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600),
//                               )
//                             : Text(
//                                 myFormat.format(transactions.amount),
//                                 style: const TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w600),
//                               ),
//                         Row(
//                           children: [
//                             InkWell(
//                                 child: const Icon(
//                                   Icons.edit,
//                                   size: 18,
//                                 ),
//                                 onTap: () {
//                                   editAlert(context, transactions);

//                                   setState(() {});
//                                 }),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             InkWell(
//                                 child: const Icon(
//                                   Icons.delete,
//                                   size: 18,
//                                   color: Colors.red,
//                                 ),
//                                 onTap: () async {
//                                   await deleteAlert(
//                                       context,
//                                       "Seguro de borrar la Transacción",
//                                       transactions.id,
//                                       'Transactions');
//                                   setState(() {});
//                                 }),
//                           ],
//                         ),
//                         const Divider()
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ));
//   }

//   Future editAlert(BuildContext context, Transactions transaction) async {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Editar transacción'),
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return Form(
//                 key: editFormKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       editDescription(transaction),
//                       editAmount(transaction),
//                       editType(transaction, setState),
//                       editDate(transaction),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   setState(() {
//                     editSubmit(transaction);
//                   });
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Guardar')),
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Cancelar'))
//           ],
//         );
//       },
//     );
//   }

//   editDescription(Transactions transaction) {
//     return TextFormField(
//       initialValue: transaction.comment,
//       textCapitalization: TextCapitalization.sentences,
//       onSaved: ((newValue) => transaction.comment = newValue!),
//     );
//   }

//   editAmount(Transactions transaction) {
//     return TextFormField(
//       initialValue: transaction.amount.toString(),
//       keyboardType: TextInputType.number,
//       onSaved: ((newValue) => transaction.amount = double.parse(newValue!)),
//     );
//   }

//   editDate(Transactions transaction) {
//     var currentYear = DateTime.now().year;
//     var distanceYear = currentYear + 100;
//     var date = DateTime.parse(transaction.date);

//     dateController.text = DateFormat('dd-MM-yyyy').format(date);
//     return TextFormField(
//       decoration: const InputDecoration(prefixIcon: Icon(Icons.date_range)),
//       readOnly: true,
//       controller: dateController,
//       onSaved: (String? newValue) => dateController.text = newValue!,
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(currentYear),
//             lastDate: DateTime(distanceYear));

//         if (pickedDate != null) {
//           setState(() {
//             transaction.date = pickedDate.toString();
//           });
//         }
//       },
//     );
//   }

//   editType(Transactions transaction, StateSetter setState) {
//     dropDownValue = transaction.type;
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: DropdownButton(
//         value: transaction.type,
//         onChanged: ((String? value) => setState(() {
//               transaction.type = value!;
//             })),
//         items: items.map((String items) {
//           return DropdownMenuItem(value: items, child: Text(items));
//         }).toList(),
//       ),
//     );
//   }

//   editSubmit(Transactions transaction) async {
//     editFormKey.currentState!.save();
//     await DataBaseHelper.instance.updateTransaction(transaction);
//     setState(() {});
//   }
// }

//?Claude
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/Home/widgets/alert.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account});
  final Account account;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String dropDownValue = 'Ahorro';
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  final items = ['Ahorro', 'Gasto', 'Ingreso'];
  final TextEditingController dateController = TextEditingController();
  final editFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account account = widget.account;

    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          account.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FloatingActionButton.small(
              heroTag: 'addBtn',
              backgroundColor: Colors.white,
              elevation: 5,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AmountPage(account: account),
                  ),
                ).then((value) => setState(() {}));
              },
              child: const Icon(Icons.add, color: Color(0xff1e234b), size: 24),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Transactions>>(
        future: DataBaseHelper.instance.getTransactionsById(account.id!),
        builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final transactions = snapshot.data ?? [];
          transactions.sort(((a, b) => b.date.compareTo(a.date)));

          var total = getTotal(transactions);
          var total2 = myFormat.format(total.toInt());

          // Calcular Ahorro, Gasto e Ingreso
          var ahorro = transactions
              .where((t) => t.type == 'Ahorro')
              .fold<double>(0, (sum, t) => sum + t.amount);
          var gasto = transactions
              .where((t) => t.type == 'Gasto')
              .fold<double>(0, (sum, t) => sum + t.amount);
          var ingreso = transactions
              .where((t) => t.type == 'Ingreso')
              .fold<double>(0, (sum, t) => sum + t.amount);

          return Column(
            children: [
              // --- Header mejorado con degradado (FIJO) ---
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff1e234b), Color(0xff2c3170)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Balance Total',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\u0024 $total2',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // --- Resumen de categorías ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _summaryCard(
                          icon: Icons.savings,
                          label: 'Ahorro',
                          amount: ahorro,
                          color: Colors.blue,
                        ),
                        _summaryCard(
                          icon: Icons.arrow_upward_rounded,
                          label: 'Ingreso',
                          amount: ingreso,
                          color: Colors.green,
                        ),
                        _summaryCard(
                          icon: Icons.arrow_downward_rounded,
                          label: 'Gasto',
                          amount: gasto,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Lista de transacciones (CON SCROLL) ---
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 24),
                        child: Text(
                          'Transacciones',
                          style: const TextStyle(
                            color: Color(0xff1e234b),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              if (transactions.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40.0),
                                    child: Column(
                                      children: [
                                        Icon(Icons.inbox_outlined,
                                            size: 64, color: Colors.grey[300]),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Sin transacciones',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return card(transactions[index], context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Card de resumen ---
  Widget _summaryCard({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$ ${myFormat.format(amount.toInt())}',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double getTotal(Iterable<Transactions>? transactions) =>
      transactions?.isNotEmpty != true
          ? 0
          : transactions
                  ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
                  .reduce((value, element) => value + element) ??
              0;

  Widget _buildTransactionsList(List<Transactions>? transactions) {
    if (transactions == null || transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'Sin transacciones',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        transactions.length,
        (index) => card(transactions[index], context),
      ),
    );
  }

  Widget card(Transactions t, BuildContext context) {
    final isGasto = t.type == 'Gasto';
    final isIngreso = t.type == 'Ingreso';
    final isAhorro = t.type == 'Ahorro';

    Color iconColor;
    IconData iconData;
    if (isGasto) {
      iconColor = Colors.red;
      iconData = Icons.arrow_downward_rounded;
    } else if (isAhorro) {
      iconColor = Colors.blue;
      iconData = Icons.savings;
    } else {
      iconColor = Colors.green;
      iconData = Icons.arrow_upward_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- Izquierda: icono + descripción ---
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              iconColor.withOpacity(0.2),
                              iconColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(iconData, color: iconColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.comment,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xff1e234b),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM d, yyyy')
                                  .format(DateTime.parse(t.date)),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Derecha: monto + botones ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isGasto
                          ? "-${t.amount.toStringAsFixed(2)}"
                          : "+${myFormat.format(t.amount.toInt())}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isGasto
                            ? Colors.red[600]
                            : isAhorro
                                ? Colors.blue[600]
                                : Colors.green[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () async {
                              await editAlert(context, t);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.edit,
                                  size: 18, color: Colors.blue[600]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () async {
                              await deleteAlert(
                                  context,
                                  "Seguro de borrar la Transacción",
                                  t.id,
                                  'Transactions');
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.delete,
                                  size: 18, color: Colors.red[600]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future editAlert(BuildContext context, Transactions transaction) async {
    final TextEditingController descriptionController =
        TextEditingController(text: transaction.comment);
    final TextEditingController amountController =
        TextEditingController(text: transaction.amount.toString());
    String? selectedType = transaction.type;

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Editar transacción',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, dialogSetState) {
              return Form(
                key: editFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      editDescription(transaction, descriptionController),
                      const SizedBox(height: 16),
                      editAmount(transaction, amountController),
                      const SizedBox(height: 16),
                      editType(transaction, dialogSetState, selectedType),
                      const SizedBox(height: 16),
                      editDate(transaction, dialogSetState),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1e234b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if (editFormKey.currentState!.validate()) {
                  transaction.comment = descriptionController.text;
                  transaction.amount = double.tryParse(amountController.text) ??
                      transaction.amount;
                  transaction.type = selectedType ?? transaction.type;

                  await DataBaseHelper.instance.updateTransaction(transaction);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    setState(() {});
  }

  editDescription(Transactions transaction, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) =>
          value!.isEmpty ? 'La descripción es obligatoria' : null,
      decoration: InputDecoration(
        labelText: 'Descripción',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.description_outlined),
      ),
    );
  }

  editAmount(Transactions transaction, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) return 'El monto es obligatorio';
        if (double.tryParse(value) == null) return 'Monto inválido';
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Monto',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.attach_money),
      ),
    );
  }

  editDate(Transactions transaction, StateSetter dialogSetState) {
    var currentYear = DateTime.now().year;
    var distanceYear = currentYear + 100;

    dateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(transaction.date));

    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.date_range),
        labelText: 'Fecha',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      readOnly: true,
      controller: dateController,
      onTap: () async {
        DateTime initialDate = DateTime.parse(transaction.date);
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(currentYear - 5),
          lastDate: DateTime(distanceYear),
        );
        if (pickedDate != null) {
          dialogSetState(() {
            transaction.date = pickedDate.toIso8601String();
            dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
          });
        }
      },
      validator: (value) => value!.isEmpty ? 'La fecha es obligatoria' : null,
    );
  }

  editType(Transactions transaction, StateSetter dialogSetState,
      String? selectedType) {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: InputDecoration(
        labelText: 'Tipo',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.category_outlined),
      ),
      onChanged: (String? value) => dialogSetState(() {
        selectedType = value!;
      }),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      validator: (value) => value == null ? 'Selecciona un tipo' : null,
    );
  }
}

//?Geminie

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
// import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
// import 'package:lleva_cuentas/Database/account_model.dart';
// import 'package:lleva_cuentas/Database/data_base_servie.dart';
// import 'package:lleva_cuentas/Home/widgets/alert.dart';

// class DetailsPage extends StatefulWidget {
//   const DetailsPage({super.key, required this.account});
//   final Account account;

//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }

// class _DetailsPageState extends State<DetailsPage> {
//   // dropDownValue is not strictly necessary if managed locally in editType
//   String dropDownValue = 'Ahorro';
//   NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
//   final items = ['Ahorro', 'Gasto', 'Ingreso'];

//   // Keep dateController here, but manage its text state in the dialog
//   final TextEditingController dateController = TextEditingController();
//   final editFormKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     dateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Account account = widget.account;

//     return Scaffold(
//       backgroundColor: const Color(0xff1e234b),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           account.name,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         leading: const BackButton(color: Colors.white),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: FloatingActionButton.small(
//               heroTag: 'addBtn',
//               backgroundColor: Colors.white,
//               elevation: 3,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AmountPage(account: account),
//                   ),
//                 ).then((value) => setState(() {}));
//               },
//               child: const Icon(Icons.add, color: Color(0xff1e234b)),
//             ),
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Transactions>>(
//         future: DataBaseHelper.instance.getTransactionsById(account.id!),
//         builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error: ${snapshot.error}',
//                     style: const TextStyle(color: Colors.white)));
//           }

//           final transactions = snapshot.data ?? [];
//           transactions.sort(((a, b) => b.date.compareTo(a.date)));

//           var total = getTotal(transactions);
//           var total2 = myFormat.format(total.toInt());

//           return Column(
//             children: [
//               // --- Sección del total con degradado ---
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xff1e234b), Color(0xff2c3170)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Total ${account.name}',
//                       style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '\u0024 $total2',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 42,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // --- Contenedor inferior con las transacciones ---
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(24)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 6,
//                         offset: Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                         child: Text(
//                           'Listado de transacciones',
//                           style: TextStyle(
//                               color: Color(0xff1e234b),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20.0),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: listCards(transactions),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Lógica original sin cambios
//   double getTotal(Iterable<Transactions>? transactions) =>
//       transactions?.isNotEmpty != true
//           ? 0
//           : transactions
//                   ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
//                   .reduce((value, element) => value + element) ??
//               0;

//   Widget listCards(List<Transactions>? transactions) {
//     if (transactions == null || transactions.isEmpty) {
//       return const Center(
//         child: Text(
//           'No tienes transacciones registradas',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: transactions.length,
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (context, index) {
//         return card(transactions[index], context);
//       },
//     );
//   }

//   // --- UI mejorada del card, misma lógica ---
//   Widget card(Transactions t, BuildContext context) {
//     final isGasto = t.type == 'Gasto';
//     final isIngreso = t.type == 'Ingreso';
//     final isAhorro = t.type == 'Ahorro';

//     Color iconColor;
//     IconData iconData;
//     if (isGasto) {
//       iconColor = Colors.red;
//       iconData = Icons.arrow_downward_rounded;
//     } else if (isAhorro) {
//       iconColor = Colors.blue;
//       iconData = Icons.savings;
//     } else {
//       iconColor = Colors.green;
//       iconData = Icons.arrow_upward_rounded;
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Izquierda: icono + descripción
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: iconColor.withOpacity(0.1),
//                   child: Icon(iconData, color: iconColor),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       t.comment,
//                       style: const TextStyle(
//                           color: Color(0xff1e234b),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       DateFormat('MMM d, yyyy')
//                           .format(DateTime.parse(t.date))
//                           .toString(),
//                       style:
//                           const TextStyle(color: Colors.grey, fontSize: 13.5),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             // Derecha: monto + botones
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   isGasto
//                       ? "-${t.amount.toStringAsFixed(2)}"
//                       : myFormat.format(t.amount),
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     color: isGasto
//                         ? Colors.red
//                         : isAhorro
//                             ? Colors.blue
//                             : Colors.green[700],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     InkWell(
//                       child: const Icon(Icons.edit, size: 18),
//                       onTap: () async {
//                         // Llama a editAlert y usa await para esperar a que el diálogo se cierre
//                         await editAlert(context, t);
//                         // El setState necesario para refrescar la lista principal se mueve DENTRO de editAlert
//                       },
//                     ),
//                     const SizedBox(width: 10),
//                     InkWell(
//                       child:
//                           const Icon(Icons.delete, color: Colors.red, size: 18),
//                       onTap: () async {
//                         await deleteAlert(
//                             context,
//                             "Seguro de borrar la Transacción",
//                             t.id,
//                             'Transactions');
//                         setState(
//                             () {}); // Refresca la lista principal tras borrar
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Editar transacción (CORREGIDO) ---
//   Future editAlert(BuildContext context, Transactions transaction) async {
//     // 1. Inicializar controladores/variables locales
//     final TextEditingController descriptionController =
//         TextEditingController(text: transaction.comment);
//     final TextEditingController amountController =
//         TextEditingController(text: transaction.amount.toString());
//     String? selectedType = transaction.type;
//     // La fecha se maneja con dateController global y se actualiza en editDate

//     await showDialog(
//       // Usar await para esperar el cierre
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Editar transacción'),
//           content: StatefulBuilder(
//             builder: (context, dialogSetState) {
//               // Obtener el setState del diálogo
//               return Form(
//                 key: editFormKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       editDescription(transaction, descriptionController),
//                       const SizedBox(height: 8),
//                       editAmount(transaction, amountController),
//                       const SizedBox(height: 8),
//                       editType(transaction, dialogSetState, selectedType),
//                       const SizedBox(height: 8),
//                       editDate(
//                           transaction, dialogSetState), // Pasar dialogSetState
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 if (editFormKey.currentState!.validate()) {
//                   // Actualizar el objeto transaction con los valores del formulario
//                   transaction.comment = descriptionController.text;
//                   transaction.amount = double.tryParse(amountController.text) ??
//                       transaction.amount;
//                   transaction.type = selectedType ?? transaction.type;
//                   // transaction.date se actualiza dentro de editDate

//                   await DataBaseHelper.instance.updateTransaction(
//                       transaction); // Esperar la actualización
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Guardar'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancelar'),
//             ),
//           ],
//         );
//       },
//     );

//     // 2. Refrescar el widget principal una vez que el diálogo se ha cerrado
//     setState(() {});
//   }

//   // --- Funciones de campos de formulario (ACTUALIZADAS) ---
//   editDescription(Transactions transaction, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       textCapitalization: TextCapitalization.sentences,
//       validator: (value) =>
//           value!.isEmpty ? 'La descripción es obligatoria' : null,
//       decoration: const InputDecoration(labelText: 'Descripción'),
//     );
//   }

//   editAmount(Transactions transaction, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       validator: (value) {
//         if (value!.isEmpty) return 'El monto es obligatorio';
//         if (double.tryParse(value) == null) return 'Monto inválido';
//         return null;
//       },
//       decoration: const InputDecoration(labelText: 'Monto'),
//     );
//   }

//   editDate(Transactions transaction, StateSetter dialogSetState) {
//     var currentYear = DateTime.now().year;
//     var distanceYear = currentYear + 100;

//     // Inicializar el texto del controlador con la fecha actual de la transacción
//     dateController.text =
//         DateFormat('dd-MM-yyyy').format(DateTime.parse(transaction.date));

//     return TextFormField(
//       decoration: const InputDecoration(
//         prefixIcon: Icon(Icons.date_range),
//         labelText: 'Fecha',
//       ),
//       readOnly: true,
//       controller: dateController,
//       onTap: () async {
//         DateTime initialDate = DateTime.parse(transaction.date);
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: initialDate, // Usar la fecha actual de la transacción
//           firstDate: DateTime(currentYear - 5), // Un rango de años razonable
//           lastDate: DateTime(distanceYear),
//         );
//         if (pickedDate != null) {
//           dialogSetState(() {
//             // Usar el setState del diálogo
//             // Actualizar la fecha de la transacción (en formato ISO)
//             transaction.date = pickedDate.toIso8601String();
//             // Actualizar el controlador de texto (en formato legible)
//             dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//           });
//         }
//       },
//       validator: (value) => value!.isEmpty ? 'La fecha es obligatoria' : null,
//     );
//   }

//   editType(Transactions transaction, StateSetter dialogSetState,
//       String? selectedType) {
//     return DropdownButtonFormField<String>(
//       value: selectedType,
//       decoration: const InputDecoration(labelText: 'Tipo'),
//       onChanged: (String? value) => dialogSetState(() {
//         // Usar el setState del diálogo
//         selectedType = value!; // Actualizar la variable local
//       }),
//       items: items.map((String item) {
//         return DropdownMenuItem<String>(value: item, child: Text(item));
//       }).toList(),
//       validator: (value) => value == null ? 'Selecciona un tipo' : null,
//     );
//   }
// }

//??ChatGTp
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
// import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
// import 'package:lleva_cuentas/Database/account_model.dart';
// import 'package:lleva_cuentas/Database/data_base_servie.dart';
// import 'package:lleva_cuentas/Home/widgets/alert.dart';

// class DetailsPage extends StatefulWidget {
//   const DetailsPage({super.key, required this.account});
//   final Account account;

//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }

// class _DetailsPageState extends State<DetailsPage> {
//   String dropDownValue = 'Ahorro';
//   NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
//   final items = ['Ahorro', 'Gasto', 'Ingreso'];
//   final TextEditingController dateController = TextEditingController();
//   final editFormKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     Account account = widget.account;

//     return Scaffold(
//       backgroundColor: const Color(0xff1e234b),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           account.name,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         leading: const BackButton(color: Colors.white),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: FloatingActionButton.small(
//               heroTag: 'addBtn',
//               backgroundColor: Colors.white,
//               elevation: 3,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AmountPage(account: account),
//                   ),
//                 ).then((value) => setState(() {}));
//               },
//               child: const Icon(Icons.add, color: Color(0xff1e234b)),
//             ),
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Transactions>>(
//         future: DataBaseHelper.instance.getTransactionsById(account.id!),
//         builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final transactions = snapshot.data!;
//           transactions.sort(((a, b) => b.date.compareTo(a.date)));
//           var total = getTotal(transactions).toInt();
//           var total2 = myFormat.format(total);

//           return Column(
//             children: [
//               // --- Sección del total con degradado ---
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xff1e234b), Color(0xff2c3170)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Total ${account.name}',
//                       style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '\u0024 $total2',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 42,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // --- Contenedor inferior con las transacciones ---
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(24)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 6,
//                         offset: Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                         child: Text(
//                           'Listado de transacciones',
//                           style: TextStyle(
//                               color: Color(0xff1e234b),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20.0),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: listCards(transactions),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Lógica original sin cambios
//   double getTotal(Iterable<Transactions>? transactions) =>
//       transactions?.isNotEmpty != true
//           ? 0
//           : transactions
//                   ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
//                   .reduce((value, element) => value + element) ??
//               0;

//   Widget listCards(List<Transactions>? transactions) {
//     if (transactions!.isEmpty) {
//       return const Center(
//         child: Text(
//           'No tienes transacciones registradas',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: transactions.length,
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (context, index) {
//         return card(transactions[index], context);
//       },
//     );
//   }

//   // --- UI mejorada del card, misma lógica ---
//   Widget card(Transactions t, BuildContext context) {
//     final isGasto = t.type == 'Gasto';
//     final isIngreso = t.type == 'Ingreso';
//     final isAhorro = t.type == 'Ahorro';

//     Color iconColor;
//     IconData iconData;
//     if (isGasto) {
//       iconColor = Colors.red;
//       iconData = Icons.arrow_downward_rounded;
//     } else if (isAhorro) {
//       iconColor = Colors.blue;
//       iconData = Icons.savings;
//     } else {
//       iconColor = Colors.green;
//       iconData = Icons.arrow_upward_rounded;
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Izquierda: icono + descripción
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: iconColor.withOpacity(0.1),
//                   child: Icon(iconData, color: iconColor),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       t.comment,
//                       style: const TextStyle(
//                           color: Color(0xff1e234b),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       DateFormat('MMM d, yyyy')
//                           .format(DateTime.parse(t.date))
//                           .toString(),
//                       style:
//                           const TextStyle(color: Colors.grey, fontSize: 13.5),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             // Derecha: monto + botones
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   isGasto
//                       ? "-${t.amount.toStringAsFixed(2)}"
//                       : myFormat.format(t.amount),
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     color: isGasto
//                         ? Colors.red
//                         : isAhorro
//                             ? Colors.blue
//                             : Colors.green[700],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     InkWell(
//                       child: const Icon(Icons.edit, size: 18),
//                       onTap: () {
//                         editAlert(context, t);
//                         setState(() {});
//                       },
//                     ),
//                     const SizedBox(width: 10),
//                     InkWell(
//                       child:
//                           const Icon(Icons.delete, color: Colors.red, size: 18),
//                       onTap: () async {
//                         await deleteAlert(
//                             context,
//                             "Seguro de borrar la Transacción",
//                             t.id,
//                             'Transactions');
//                         setState(() {});
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Editar transacción (misma lógica, solo leves mejoras visuales) ---
//   Future editAlert(BuildContext context, Transactions transaction) async {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Editar transacción'),
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return Form(
//                 key: editFormKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       editDescription(transaction),
//                       const SizedBox(height: 8),
//                       editAmount(transaction),
//                       const SizedBox(height: 8),
//                       editType(transaction, setState),
//                       const SizedBox(height: 8),
//                       editDate(transaction),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   editSubmit(transaction);
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Guardar'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancelar'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   editDescription(Transactions transaction) {
//     return TextFormField(
//       initialValue: transaction.comment,
//       textCapitalization: TextCapitalization.sentences,
//       onSaved: ((newValue) => transaction.comment = newValue!),
//       decoration: const InputDecoration(labelText: 'Descripción'),
//     );
//   }

//   editAmount(Transactions transaction) {
//     return TextFormField(
//       initialValue: transaction.amount.toString(),
//       keyboardType: TextInputType.number,
//       onSaved: ((newValue) => transaction.amount = double.parse(newValue!)),
//       decoration: const InputDecoration(labelText: 'Monto'),
//     );
//   }

//   editDate(Transactions transaction) {
//     var currentYear = DateTime.now().year;
//     var distanceYear = currentYear + 100;
//     var date = DateTime.parse(transaction.date);
//     dateController.text = DateFormat('dd-MM-yyyy').format(date);

//     return TextFormField(
//       decoration: const InputDecoration(
//         prefixIcon: Icon(Icons.date_range),
//         labelText: 'Fecha',
//       ),
//       readOnly: true,
//       controller: dateController,
//       onSaved: (String? newValue) => dateController.text = newValue!,
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(currentYear),
//           lastDate: DateTime(distanceYear),
//         );
//         if (pickedDate != null) {
//           setState(() {
//             transaction.date = pickedDate.toString();
//           });
//         }
//       },
//     );
//   }

//   editType(Transactions transaction, StateSetter setState) {
//     dropDownValue = transaction.type;
//     return DropdownButtonFormField(
//       value: transaction.type,
//       decoration: const InputDecoration(labelText: 'Tipo'),
//       onChanged: ((String? value) => setState(() {
//             transaction.type = value!;
//           })),
//       items: items.map((String items) {
//         return DropdownMenuItem(value: items, child: Text(items));
//       }).toList(),
//     );
//   }

//   editSubmit(Transactions transaction) async {
//     editFormKey.currentState!.save();
//     await DataBaseHelper.instance.updateTransaction(transaction);
//     setState(() {});
//   }
// }
