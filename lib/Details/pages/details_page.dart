import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/Home/widgets/alert.dart';

import '../../Home/pages/home_page.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account});
  final Account account;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

@override
class _DetailsPageState extends State<DetailsPage> {
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
        return card(transactions![index], context);
      },
    );
  }

  card(Transactions transactions, BuildContext context) {
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
                            print('tapped');
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
}
