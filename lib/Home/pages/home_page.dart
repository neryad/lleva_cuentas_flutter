import 'package:flutter/material.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';

import '../../Database/account_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final dbHelper = DataBaseHelper.instance;
    final TextEditingController nameAccountController = TextEditingController();
    // var test = Account(name: 'Charky');
    // dbHelper.newAccount(test);
    dbHelper.getTest();

    saveAccount(String name) {
      var account = Account(name: name);
      dbHelper.newAccount(account);
    }

    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1e234b),
        title: const Text('hola'),
      ),
      body: Container(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TextFormField(),
                  SizedBox(
                    width: 220.0,
                    child: TextField(
                      controller: nameAccountController,
                      decoration: const InputDecoration(
                          focusColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          // fillColor: Colors.white,
                          // border: OutlineInputBorder(),
                          hintText: 'Nombre de la cuenta',
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        saveAccount(nameAccountController.text);
                        print('agregar');
                        setState(() {
                          dbHelper.getTest();
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50.0,
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
                children: const [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Lista de cuentas',
                      style: TextStyle(
                          color: Color(0xff1e234b),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: accountsCardList(),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class accountsCardList extends StatelessWidget {
  const accountsCardList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: (() {
        Navigator.pushNamed(context, 'details');
      }),
      child: FutureBuilder<List<Account>>(
        future: DataBaseHelper.instance.getTest(),
        builder: (context, AsyncSnapshot<List<Account>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final account = snapshot.data;
          if (account!.length == 0) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text('No tienes cuentas registradas'),
              ),
            );
          }
          return ListView.builder(
            itemCount: account.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return cardAccount(account![index]);
            },
          );
        },
        // child: Card(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Row(
        //         // ignore: prefer_const_literals_to_create_immutables
        //         children: [
        //           const CircleAvatar(
        //             backgroundColor: Color(0xffecedf6),
        //             // ignore: unnecessary_const
        //             child: const Text(
        //               'A',
        //               style: TextStyle(
        //                   color: Color(0xff1e234b),
        //                   fontWeight: FontWeight.bold),
        //             ),
        //           ),
        //           const SizedBox(
        //             width: 60.0,
        //           ),
        //           const Text(
        //             'Amara',
        //             style: TextStyle(
        //                 color: Color(0xff1e234b), fontWeight: FontWeight.bold),
        //           ),
        //         ],
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           IconButton(
        //               onPressed: () {
        //                 print('pdf');
        //               },
        //               icon: const Icon(Icons.document_scanner)),
        //           IconButton(
        //               onPressed: () {
        //                 print('pdf');
        //               },
        //               icon: const Icon(Icons.delete))
        //         ],
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

Widget cardAccount(Account account) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            CircleAvatar(
              backgroundColor: Color(0xffecedf6),
              // ignore: unnecessary_const
              child: Text(
                account!.name[0].toUpperCase(),
                style: TextStyle(
                    color: Color(0xff1e234b), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 60.0,
            ),
            Text(
              account!.name,
              style: TextStyle(
                  color: Color(0xff1e234b), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  print('pdf');
                },
                icon: const Icon(Icons.document_scanner)),
            IconButton(
                onPressed: () {
                  print('pdf');
                },
                icon: const Icon(Icons.delete))
          ],
        )
      ],
    ),
  );
}
