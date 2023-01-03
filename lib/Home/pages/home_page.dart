// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/Details/pages/details_page.dart';
import 'package:lleva_cuentas/Home/widgets/alert.dart';
import 'package:lleva_cuentas/utils/pdf.dart';
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
        // title: const Text('hola'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TextFormField(),
                SizedBox(
                  width: 220.0,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
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
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        saveAccount(nameAccountController.text);
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))
              ],
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
              child: SingleChildScrollView(
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
                      child: accountsCardList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget accountsCardList() {
    return FutureBuilder<List<Account>>(
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
          scrollDirection: Axis.vertical,
          itemCount: account.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return cardAccount(account[index], context);
          },
        );
      },
    );
  }

  Widget cardAccount(Account account, BuildContext context) {
    return GestureDetector(
      onTap: (() {
        // Navigator.pushNamed(context, 'details');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsPage(account: account)));
      }),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xffecedf6),
                  // ignore: unnecessary_const
                  child: Text(
                    account.name[0].toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xff1e234b), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 60.0,
                ),
                Text(
                  account.name,
                  style: const TextStyle(
                      color: Color(0xff1e234b), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () async {
                      final pdf = await ApiPdf.generaPdf(account.id!);
                      // await Share.shareFiles([pdf.path]);
                      ApiPdf.openFile(pdf);
                    },
                    icon: const Icon(Icons.document_scanner)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        deleteAlert(context, 'Seguro de eliminar la cuenta?',
                            account.id!, 'Accounts');
                      });

                      // _deleteAlert();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
