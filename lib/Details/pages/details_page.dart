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
//           style: const TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 24,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         leading: const BackButton(color: Colors.white),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: FloatingActionButton.small(
//               heroTag: 'addBtn',
//               backgroundColor: Colors.white,
//               elevation: 5,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AmountPage(account: account),
//                   ),
//                 ).then((value) => setState(() {}));
//               },
//               child: const Icon(Icons.add, color: Color(0xff1e234b), size: 24),
//             ),
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Transactions>>(
//         future: DataBaseHelper.instance.getTransactionsById(account.id!),
//         builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.white70),
//               ),
//             );
//           }

//           final transactions = snapshot.data ?? [];
//           transactions.sort(((a, b) => b.date.compareTo(a.date)));

//           var total = getTotal(transactions);
//           var total2 = myFormat.format(total.toInt());

//           // Calcular Ahorro, Gasto e Ingreso
//           var ahorro = transactions
//               .where((t) => t.type == 'Ahorro')
//               .fold<double>(0, (sum, t) => sum + t.amount);
//           var gasto = transactions
//               .where((t) => t.type == 'Gasto')
//               .fold<double>(0, (sum, t) => sum + t.amount);
//           var ingreso = transactions
//               .where((t) => t.type == 'Ingreso')
//               .fold<double>(0, (sum, t) => sum + t.amount);

//           return Column(
//             children: [
//               // --- Header mejorado con degradado (FIJO) ---
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
//                       'Balance Total',
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       '\u0024 $total2',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // --- Resumen de categorías ---
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _summaryCard(
//                           icon: Icons.savings,
//                           label: 'Ahorro',
//                           amount: ahorro,
//                           color: Colors.blue,
//                         ),
//                         _summaryCard(
//                           icon: Icons.arrow_upward_rounded,
//                           label: 'Ingreso',
//                           amount: ingreso,
//                           color: Colors.green,
//                         ),
//                         _summaryCard(
//                           icon: Icons.arrow_downward_rounded,
//                           label: 'Gasto',
//                           amount: gasto,
//                           color: Colors.red,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // --- Lista de transacciones (CON SCROLL) ---
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(28)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 8,
//                         offset: Offset(0, -4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(left: 20, right: 20, top: 24),
//                         child: Text(
//                           'Transacciones',
//                           style: const TextStyle(
//                             color: Color(0xff1e234b),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: ListView.builder(
//                             physics: const BouncingScrollPhysics(),
//                             itemCount: transactions.length,
//                             itemBuilder: (context, index) {
//                               if (transactions.isEmpty) {
//                                 return Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 40.0),
//                                     child: Column(
//                                       children: [
//                                         Icon(Icons.inbox_outlined,
//                                             size: 64, color: Colors.grey[300]),
//                                         const SizedBox(height: 12),
//                                         Text(
//                                           'Sin transacciones',
//                                           style: TextStyle(
//                                             color: Colors.grey[500],
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }
//                               return card(transactions[index], context);
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
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

//   // --- Card de resumen ---
//   Widget _summaryCard({
//     required IconData icon,
//     required String label,
//     required double amount,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: color, size: 28),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white70,
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           '\$ ${myFormat.format(amount.toInt())}',
//           style: TextStyle(
//             color: color,
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   double getTotal(Iterable<Transactions>? transactions) =>
//       transactions?.isNotEmpty != true
//           ? 0
//           : transactions
//                   ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
//                   .reduce((value, element) => value + element) ??
//               0;

//   Widget _buildTransactionsList(List<Transactions>? transactions) {
//     if (transactions == null || transactions.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 40.0),
//           child: Column(
//             children: [
//               Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
//               const SizedBox(height: 12),
//               Text(
//                 'Sin transacciones',
//                 style: TextStyle(
//                   color: Colors.grey[500],
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Column(
//       children: List.generate(
//         transactions.length,
//         (index) => card(transactions[index], context),
//       ),
//     );
//   }

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

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {},
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // --- Izquierda: icono + descripción ---
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               iconColor.withOpacity(0.2),
//                               iconColor.withOpacity(0.05),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: Icon(iconData, color: iconColor, size: 26),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               t.comment,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Color(0xff1e234b),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               DateFormat('MMM d, yyyy')
//                                   .format(DateTime.parse(t.date)),
//                               style: TextStyle(
//                                 color: Colors.grey[500],
//                                 fontSize: 12.5,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // --- Derecha: monto + botones ---
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       isGasto
//                           ? "-${t.amount.toStringAsFixed(2)}"
//                           : "+${myFormat.format(t.amount.toInt())}",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: isGasto
//                             ? Colors.red[600]
//                             : isAhorro
//                                 ? Colors.blue[600]
//                                 : Colors.green[600],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(8),
//                             onTap: () async {
//                               await editAlert(context, t);
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: Icon(Icons.edit,
//                                   size: 18, color: Colors.blue[600]),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(8),
//                             onTap: () async {
//                               await deleteAlert(
//                                   context,
//                                   "Seguro de borrar la Transacción",
//                                   t.id,
//                                   'Transactions');
//                               setState(() {});
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: Icon(Icons.delete,
//                                   size: 18, color: Colors.red[600]),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future editAlert(BuildContext context, Transactions transaction) async {
//     final TextEditingController descriptionController =
//         TextEditingController(text: transaction.comment);
//     final TextEditingController amountController =
//         TextEditingController(text: transaction.amount.toString());
//     String? selectedType = transaction.type;

//     await showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: const Text(
//             'Editar transacción',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: StatefulBuilder(
//             builder: (context, dialogSetState) {
//               return Form(
//                 key: editFormKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       editDescription(transaction, descriptionController),
//                       const SizedBox(height: 16),
//                       editAmount(transaction, amountController),
//                       const SizedBox(height: 16),
//                       editType(transaction, dialogSetState, selectedType),
//                       const SizedBox(height: 16),
//                       editDate(transaction, dialogSetState),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancelar'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xff1e234b),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: () async {
//                 if (editFormKey.currentState!.validate()) {
//                   transaction.comment = descriptionController.text;
//                   transaction.amount = double.tryParse(amountController.text) ??
//                       transaction.amount;
//                   transaction.type = selectedType ?? transaction.type;

//                   await DataBaseHelper.instance.updateTransaction(transaction);
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Guardar',
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         );
//       },
//     );

//     setState(() {});
//   }

//   editDescription(Transactions transaction, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       textCapitalization: TextCapitalization.sentences,
//       validator: (value) =>
//           value!.isEmpty ? 'La descripción es obligatoria' : null,
//       decoration: InputDecoration(
//         labelText: 'Descripción',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         prefixIcon: const Icon(Icons.description_outlined),
//       ),
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
//       decoration: InputDecoration(
//         labelText: 'Monto',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         prefixIcon: const Icon(Icons.attach_money),
//       ),
//     );
//   }

//   editDate(Transactions transaction, StateSetter dialogSetState) {
//     var currentYear = DateTime.now().year;
//     var distanceYear = currentYear + 100;

//     dateController.text =
//         DateFormat('dd-MM-yyyy').format(DateTime.parse(transaction.date));

//     return TextFormField(
//       decoration: InputDecoration(
//         prefixIcon: const Icon(Icons.date_range),
//         labelText: 'Fecha',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       readOnly: true,
//       controller: dateController,
//       onTap: () async {
//         DateTime initialDate = DateTime.parse(transaction.date);
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: initialDate,
//           firstDate: DateTime(currentYear - 5),
//           lastDate: DateTime(distanceYear),
//         );
//         if (pickedDate != null) {
//           dialogSetState(() {
//             transaction.date = pickedDate.toIso8601String();
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
//       decoration: InputDecoration(
//         labelText: 'Tipo',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         prefixIcon: const Icon(Icons.category_outlined),
//       ),
//       onChanged: (String? value) => dialogSetState(() {
//         selectedType = value!;
//       }),
//       items: items.map((String item) {
//         return DropdownMenuItem<String>(value: item, child: Text(item));
//       }).toList(),
//       validator: (value) => value == null ? 'Selecciona un tipo' : null,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/Home/widgets/alert.dart';
import 'package:lleva_cuentas/theme_manager.dart';

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

    return Consumer<ThemeManager>(
      builder: (context, themeManager, _) {
        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              account.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            leading: const BackButton(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: FloatingActionButton.small(
                  heroTag: 'addBtn',
                  backgroundColor: colorScheme.primary,
                  elevation: 5,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AmountPage(account: account),
                      ),
                    ).then((value) => setState(() {}));
                  },
                  child:
                      Icon(Icons.add, color: colorScheme.onPrimary, size: 24),
                ),
              ),
            ],
          ),
          body: FutureBuilder<List<Transactions>>(
            future: DataBaseHelper.instance.getTransactionsById(account.id!),
            builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                );
              }

              final transactions = snapshot.data ?? [];
              transactions.sort(((a, b) => b.date.compareTo(a.date)));

              var total = getTotal(transactions);
              var total2 = myFormat.format(total.toInt());

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
                  // --- Header con degradado dinámico ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 28),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surface,
                          colorScheme.surface.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Balance Total',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '\u0024 $total2',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _summaryCard(
                              icon: Icons.savings,
                              label: 'Ahorro',
                              amount: ahorro,
                              color: colorScheme.primary,
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
                              color: colorScheme.error,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Lista de transacciones ---
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 24),
                            child: Text(
                              'Transacciones',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
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
                                            Icon(
                                              Icons.inbox_outlined,
                                              size: 64,
                                              color: colorScheme.outline
                                                  .withOpacity(0.3),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Sin transacciones',
                                              style: TextStyle(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return card(transactions[index], context,
                                      colorScheme);
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
      },
    );
  }

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

  Widget card(Transactions t, BuildContext context, ColorScheme colorScheme) {
    final isGasto = t.type == 'Gasto';
    final isIngreso = t.type == 'Ingreso';
    final isAhorro = t.type == 'Ahorro';

    Color iconColor;
    IconData iconData;
    if (isGasto) {
      iconColor = colorScheme.error;
      iconData = Icons.arrow_downward_rounded;
    } else if (isAhorro) {
      iconColor = colorScheme.primary;
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
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM d, yyyy')
                                  .format(DateTime.parse(t.date)),
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
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
                            ? colorScheme.error
                            : isAhorro
                                ? colorScheme.primary
                                : Colors.green,
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
                              await editAlert(context, t, colorScheme);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.edit,
                                  size: 18, color: colorScheme.primary),
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
                                  size: 18, color: colorScheme.error),
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

  Future editAlert(BuildContext context, Transactions transaction,
      ColorScheme colorScheme) async {
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
                backgroundColor: colorScheme.primary,
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
                    fontWeight: FontWeight.bold,
                  )),
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
