import 'package:flutter/material.dart';
import 'package:lleva_cuentas/Amount/pages/amount_pages.dart';
import 'package:lleva_cuentas/Details/pages/details_page.dart';
import 'package:lleva_cuentas/Home/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Llevacuentas',
      home: HomePage(),
      routes: {
        'home': (BuildContext context) => const HomePage(),
        // 'details': (BuildContext context) => const DetailsPage(),
        // 'amount': (BuildContext context) => const AmountPage()
      },
    );
  }
}
