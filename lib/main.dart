import 'package:flutter/material.dart';
import 'package:lleva_cuentas/Home/pages/home_page.dart';
import 'package:lleva_cuentas/theme_manager.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       //theme: ThemeData(colorSchemeSeed: Color(0xff1e234b)),
//       title: 'Llevacuentas',
//       home: const HomePage(),
//       routes: {
//         'home': (BuildContext context) => const HomePage(),
//         // 'details': (BuildContext context) => const DetailsPage(),
//         // 'amount': (BuildContext context) => const AmountPage()
//       },
//     );
//   }
// }
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final themeManager = ThemeManager();
//   themeManager.loadTheme(); // Esperar a que cargue las preferencias

//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => themeManager,
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeManager>(
//       builder: (context, themeManager, _) {
//         return MaterialApp(
//           title: 'Lleva Cuentas',
//           debugShowCheckedModeBanner: false,
//           theme: themeManager.getThemeData(),
//           home: const HomePage(),
//         );
//       },
//     );
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeManager = ThemeManager();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeManager,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, _) {
        return MaterialApp(
          title: 'Lleva Cuentas',
          debugShowCheckedModeBanner: false,
          theme: themeManager.getThemeData(),
          home: const HomePage(),
        );
      },
    );
  }
}
