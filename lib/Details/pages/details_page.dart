import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';

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
    setState(() {});
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
                // var test = new Transactions(
                //     type: 'Ahorro',
                //     amount: 22,
                //     date: '29-11-2022',
                //     comment: 'comment',
                //     accountId: 1);

                // DataBaseHelper.instance.addTransaction(test);
              },
              icon: const Icon(Icons.add),
            ),
          )
          // CircleAvatar(
          //   backgroundColor: Colors.white,
          //   child: Text(
          //     'A',
          //     style: TextStyle(color: Color(0xff1e234b)),
          //   ),
          // )
        ],
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
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
            children: const [
              Text('100,000',
                  style: TextStyle(
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
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          listCards(account),
                          // const SizedBox(
                          //   height: 290,
                          // ),
                          // ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 50, vertical: 10),
                          //         textStyle: const TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     onPressed: () {},
                          //     child: const Text('Agregar'))
                        ],
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget listCards(Account account) {
  return FutureBuilder<List<Transactions>>(
    future: DataBaseHelper.instance.getTransactionsById(account.id!),
    builder: ((context, AsyncSnapshot<List<Transactions>> snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final transactions = snapshot.data;

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
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return card(transactions![index], context);
        },
      );
    }),
  );
}

Widget card(Transactions transactions, BuildContext context) {
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
                  Icons.arrow_circle_down_rounded,
                  color: Color(0xff1e234b),
                )),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              children: [
                Text(
                  transactions!.comment,
                  style: TextStyle(
                      color: Color(0xff1e234b), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  transactions!.date,
                  style: TextStyle(
                      color: Color(0xff1e234b), fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                Text(
                  transactions!.amount.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        child: const Icon(
                          Icons.delete,
                          size: 18,
                        ),
                        onTap: () {
                          print('tapped');
                        }),
                    // TextButton(
                    //   onPressed: () {
                    //     print('pdf');
                    //   },
                    //   child: Icon(Icons.abc),
                    // ),
                    // TextButton(
                    //   onPressed: () {
                    //     print('pdf');
                    //   },
                    //   style:
                    //       TextButton.styleFrom(fixedSize: Size.fromHeight(2)),
                    //   child: Icon(Icons.abc),
                    // ),
                  ],
                )
              ],
            )

            // Column(
            //   children: [
            //     IconButton(
            //         onPressed: () {
            //           print('pdf');
            //         },
            //         icon: const Icon(Icons.document_scanner)),
            //     IconButton(
            //         onPressed: () {
            //           print('pdf');
            //         },
            //         icon: const Icon(Icons.delete))
            //   ],
            // )
          ],
        ),
      ],
    ),
  );
}
