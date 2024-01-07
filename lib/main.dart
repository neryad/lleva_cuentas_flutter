import 'package:flutter/material.dart';
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
      //theme: ThemeData(colorSchemeSeed: const Color(0xff1e234b)),
      home: const HomePage(),
      routes: {
        'home': (BuildContext context) => const HomePage(),
        // 'details': (BuildContext context) => const DetailsPage(),
        // 'amount': (BuildContext context) => const AmountPage()
      },
    );
  }
}
