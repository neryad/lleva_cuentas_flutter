import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  // @override
  // void initState() {
  //   //refresh the page here

  //   super.initState();
  // }
  String dropdownValue = 'Ahorro';
  final items = ['Ahorro', 'Gasto'];
  final editFormKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();

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
                        builder: (context) => AmountPage(account: account)));
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
        leading: BackButton(
          onPressed: () {
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
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Total en la cuenta de ${account.name}',
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
                  children: [
                    Text(getTotal(transactions!).toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 50,
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
                            'Lista de cuentas',
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
                              child: listCards(transactions, account)),
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

  Widget listCards(List<Transactions>? transactions, Account account) {
    if (transactions!.length == 0) {
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
        return card(transactions![index], context, account);
      },
    );
  }

  card(Transactions transactions, BuildContext context, Account account) {
    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
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
                  Text(
                    transactions!.comment,
                    style: const TextStyle(
                        color: Color(0xff1e234b), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    DateFormat('MMM d, yyyy')
                        .format(DateTime.parse(transactions!.date))
                        .toString(),
                    style: const TextStyle(
                        color: const Color(0xff1e234b),
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
                          '-' + transactions!.amount.toString(),
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          transactions!.amount.toString(),
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
                            setState(() {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => EditAmountPage(
                              //             transaction: transactions)));
                            });
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
                                transactions!.id,
                                'Transactions');
                            setState(() {});
                          }),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Future editAlert(BuildContext context, Transactions transaction) async {
    // final _editFormKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar transacción'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Form(
                  key: editFormKey,
                  child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        editDescription(transaction),
                        editDate(transaction),
                        editAmount(transaction),
                        editType(transaction, setState)
                      ]),
                );
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _editDubimt(transaction);
                  },
                  child: Text('guardar'))
            ],
          );
        });
  }

  void _editDubimt(Transactions transaction) {
    editFormKey.currentState!.save();
    // DBProvider.db.updateProd(articulos[index]);
  }

  editDescription(Transactions transaction) {
    return TextFormField(
      initialValue: transaction.comment,
      textCapitalization: TextCapitalization.sentences,
      onSaved: (value) => transaction.comment = value!,
    );
  }

  editAmount(Transactions transaction) {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: transaction.amount.toString(),
      textCapitalization: TextCapitalization.sentences,
      onSaved: (value) => transaction.amount = double.parse(value!),
    );
  }

  editDate(Transactions transaction) {
    var date = DateTime.parse(transaction.date);
    dateController.text = DateFormat('dd-MM-yyyy').format(date).toString();
    return TextFormField(
      keyboardType: TextInputType.datetime,
      readOnly: true,
      controller: dateController,
      textCapitalization: TextCapitalization.sentences,
      onSaved: (value) => transaction.date = dateController.text!,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          dateController.text = pickedDate.toString();
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          setState(() {
            dateController.text = formattedDate.toString();
          });
        }
      },
    );
  }

  editType(Transactions transaction, StateSetter setState) {
    //dropdownValue = transaction.type;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        value: dropdownValue,
        underline: const SizedBox.shrink(),
        onChanged: ((String? value) {
          setState((() => dropdownValue = value!));
          // setState(() {
          //   dropdownValue = value!;
          // });
          // dropdownValue = value.toString();
        }),
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
            ),
          );
        }).toList(),
      ),
    );
  }
}
