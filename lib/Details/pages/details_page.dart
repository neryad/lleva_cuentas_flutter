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

@override
class _DetailsPageState extends State<DetailsPage> {
  String dropDownValue = 'Ahorro';
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  final items = ['Ahorro', 'Gasto', 'Ingreso'];
  final TextEditingController dateController = TextEditingController();
  final editFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    //refresh the page here

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Account account = widget.account;

    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1e234b),
        // title: const Text('Amara'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              color: const Color(0xff1e234b),
              onPressed: () {
                //Navigator.pushNamed(context, 'amount');
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AmountPage(account: account)))
                    .then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
        leading: BackButton(
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const HomePage()));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Transactions>>(
          future: DataBaseHelper.instance.getTransactionsById(account.id!),
          builder: ((context, AsyncSnapshot<List<Transactions>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final transactions = snapshot.data;
            transactions!.sort(((a, b) => b.date.compareTo(a.date)));
            var total = getTotal(transactions).toInt();
            var total2 = myFormat.format(total);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total ${account.name}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('\u0024 $total2 ',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w800))
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    // color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Listado de transacciones',
                            style: TextStyle(
                                color: Color(0xff1e234b),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: listCards(transactions)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }

  double getTotal(Iterable<Transactions>? transactions) =>
      transactions?.isNotEmpty != true
          ? 0
          : transactions
                  ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
                  .reduce((value, element) => value + element) ??
              0;
  Widget listCards(List<Transactions>? transactions) {
    if (transactions!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Text('No tienes transacciones registradas'),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return card(transactions[index], context);
      },
    );
  }

  card(Transactions transactions, BuildContext context) {
    return Card(
        elevation: 0,
        child: Column(
          children: [
            Text(
              DateFormat('MMM d, yyyy')
                  .format(DateTime.parse(transactions.date))
                  .toString(),
              style: const TextStyle(
                  color: Color(0xff1e234b), fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const CircleAvatar(
                        backgroundColor: Color(0xffecedf6),
                        // ignore: unnecessary_const
                        child: Icon(
                          Icons.monetization_on_outlined,
                          color: Color(0xff1e234b),
                        )),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          transactions.comment,
                          style: const TextStyle(
                              color: Color(0xff1e234b),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        transactions.type == 'Gasto'
                            ? Text(
                                '-${transactions.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )
                            : Text(
                                myFormat.format(transactions.amount),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                        Row(
                          children: [
                            InkWell(
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                                onTap: () {
                                  editAlert(context, transactions);

                                  setState(() {});
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                child: const Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                onTap: () async {
                                  await deleteAlert(
                                      context,
                                      "Seguro de borrar la Transacción",
                                      transactions.id,
                                      'Transactions');
                                  setState(() {});
                                }),
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Future editAlert(BuildContext context, Transactions transaction) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar transacción'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: editFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      editDescription(transaction),
                      editAmount(transaction),
                      editType(transaction, setState),
                      editDate(transaction),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    editSubmit(transaction);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'))
          ],
        );
      },
    );
  }

  editDescription(Transactions transaction) {
    return TextFormField(
      initialValue: transaction.comment,
      textCapitalization: TextCapitalization.sentences,
      onSaved: ((newValue) => transaction.comment = newValue!),
    );
  }

  editAmount(Transactions transaction) {
    return TextFormField(
      initialValue: transaction.amount.toString(),
      keyboardType: TextInputType.number,
      onSaved: ((newValue) => transaction.amount = double.parse(newValue!)),
    );
  }

  editDate(Transactions transaction) {
    var currentYear = DateTime.now().year;
    var distanceYear = currentYear + 100;
    var date = DateTime.parse(transaction.date);

    dateController.text = DateFormat('dd-MM-yyyy').format(date);
    return TextFormField(
      decoration: const InputDecoration(prefixIcon: Icon(Icons.date_range)),
      readOnly: true,
      controller: dateController,
      onSaved: (String? newValue) => dateController.text = newValue!,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(currentYear),
            lastDate: DateTime(distanceYear));

        if (pickedDate != null) {
          setState(() {
            transaction.date = pickedDate.toString();
          });
        }
      },
    );
  }

  editType(Transactions transaction, StateSetter setState) {
    dropDownValue = transaction.type;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        value: transaction.type,
        onChanged: ((String? value) => setState(() {
              transaction.type = value!;
            })),
        items: items.map((String items) {
          return DropdownMenuItem(value: items, child: Text(items));
        }).toList(),
      ),
    );
  }

  editSubmit(Transactions transaction) async {
    editFormKey.currentState!.save();
    await DataBaseHelper.instance.updateTransaction(transaction);
    setState(() {});
  }
}
