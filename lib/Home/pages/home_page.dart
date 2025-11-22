// // ignore_for_file: prefer_is_empty

// // import 'package:flutter/material.dart';
// // import 'package:lleva_cuentas/Database/data_base_servie.dart';
// // import 'package:lleva_cuentas/Details/pages/details_page.dart';
// // import 'package:lleva_cuentas/Home/widgets/alert.dart';
// // import 'package:lleva_cuentas/utils/pdf.dart';
// // import '../../Database/account_model.dart';

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final dbHelper = DataBaseHelper.instance;
// //     final TextEditingController nameAccountController = TextEditingController();
// //     dbHelper.getTest();

// //     saveAccount(String name) {
// //       if (name.trim().isEmpty) {
// //         alert();
// //         return;
// //       }
// //       var account = Account(name: name);
// //       dbHelper.newAccount(account);
// //     }

// //     return Scaffold(
// //       backgroundColor: const Color(0xff1e234b),
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: const Color(0xff1e234b),
// //         title: const Text(
// //           'Mis Cuentas',
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.w600,
// //             letterSpacing: 0.5,
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: Column(
// //         children: [
// //           // 🔹 Caja de texto mejor presentada
// //           Padding(
// //             padding:
// //                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       style: const TextStyle(color: Colors.white),
// //                       controller: nameAccountController,
// //                       decoration: const InputDecoration(
// //                         border: InputBorder.none,
// //                         hintText: 'Nombre de la cuenta...',
// //                         hintStyle: TextStyle(color: Colors.white70),
// //                       ),
// //                     ),
// //                   ),
// //                   IconButton(
// //                     onPressed: () {
// //                       setState(() {
// //                         saveAccount(nameAccountController.text);
// //                       });
// //                     },
// //                     icon: const Icon(Icons.add_circle, color: Colors.white),
// //                   )
// //                 ],
// //               ),
// //             ),
// //           ),

// //           const SizedBox(height: 20),

// //           // 🔹 Contenedor principal
// //           Expanded(
// //             child: Container(
// //               decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: Radius.circular(24),
// //                   topRight: Radius.circular(24),
// //                 ),
// //               ),
// //               child: Column(
// //                 children: [
// //                   const Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //                     child: Align(
// //                       alignment: Alignment.centerLeft,
// //                       child: Text(
// //                         'Lista de cuentas',
// //                         style: TextStyle(
// //                           color: Color(0xff1e234b),
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 20,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   Expanded(child: accountsCardList()),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   alert() {
// //     return showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text("Aviso"),
// //           content: const Text("Debe colocar el nombre de la cuenta!"),
// //           actions: <Widget>[
// //             TextButton(
// //               child: const Text("OK"),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Widget accountsCardList() {
// //     return FutureBuilder<List<Account>>(
// //       future: DataBaseHelper.instance.getTest(),
// //       builder: (context, AsyncSnapshot<List<Account>> snapshot) {
// //         if (!snapshot.hasData) {
// //           return const Center(
// //             child: Padding(
// //               padding: EdgeInsets.only(top: 50),
// //               child: CircularProgressIndicator(color: Color(0xff1e234b)),
// //             ),
// //           );
// //         }

// //         final account = snapshot.data;
// //         account!.sort(
// //           ((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
// //         );

// //         if (account.isEmpty) {
// //           return const Center(
// //             child: Padding(
// //               padding: EdgeInsets.all(16),
// //               child: Text(
// //                 'No tienes cuentas registradas aún',
// //                 style: TextStyle(color: Colors.grey, fontSize: 16),
// //               ),
// //             ),
// //           );
// //         }

// //         return ListView.builder(
// //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //           itemCount: account.length,
// //           itemBuilder: (context, index) {
// //             return cardAccount(account[index], context);
// //           },
// //         );
// //       },
// //     );
// //   }

// //   Widget cardAccount(Account account, BuildContext context) {
// //     return GestureDetector(
// //       onTap: (() {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //               builder: (context) => DetailsPage(account: account)),
// //         );
// //       }),
// //       child: Card(
// //         elevation: 2,
// //         margin: const EdgeInsets.symmetric(vertical: 6),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               // 🔹 Avatar + texto más equilibrado
// //               Row(
// //                 children: [
// //                   CircleAvatar(
// //                     backgroundColor: const Color(0xffecedf6),
// //                     child: Text(
// //                       account.name[0].toUpperCase(),
// //                       style: const TextStyle(
// //                         color: Color(0xff1e234b),
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 16),
// //                   Text(
// //                     account.name,
// //                     style: const TextStyle(
// //                       color: Color(0xff1e234b),
// //                       fontWeight: FontWeight.w600,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //                     onPressed: () async {
// //                       await deleteAlert(
// //                         context,
// //                         '¿Seguro que deseas eliminar la cuenta?',
// //                         account.id!,
// //                         'Accounts',
// //                       );
// //                       setState(() {});
// //                     },
// //                     icon: const Icon(Icons.delete_outline, color: Colors.red),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:lleva_cuentas/Database/data_base_servie.dart';
// import 'package:lleva_cuentas/Details/pages/details_page.dart';
// import 'package:lleva_cuentas/Home/widgets/alert.dart';
// import 'package:lleva_cuentas/Settings/pages/settings_page.dart';
// import 'package:lleva_cuentas/utils/pdf.dart';
// import '../../Database/account_model.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController nameAccountController = TextEditingController();

//   @override
//   void dispose() {
//     nameAccountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dbHelper = DataBaseHelper.instance;
//     dbHelper.getTest();

//     saveAccount(String name) {
//       if (name.trim().isEmpty) {
//         alert();
//         return;
//       }
//       var account = Account(name: name);
//       dbHelper.newAccount(account);
//       nameAccountController.clear();
//       setState(() {});
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xff1e234b),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Mis Cuentas',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 28,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Gestiona tus finanzas',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: IconButton(
//               icon: const Icon(Icons.settings_outlined, size: 28),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SettingsPage(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 🔹 Input mejorado con animación
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.white.withOpacity(0.15),
//                     Colors.white.withOpacity(0.05),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.2),
//                   width: 1.5,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       controller: nameAccountController,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Nombre de la cuenta...',
//                         hintStyle: TextStyle(
//                           color: Colors.white54,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         prefixIcon: Icon(
//                           Icons.account_balance_wallet_outlined,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 4.0),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         onTap: () {
//                           saveAccount(nameAccountController.text);
//                         },
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xff4CAF50), Color(0xff45a049)],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.add_rounded,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),

//           // 🔹 Contenedor principal mejorado
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.only(top: 12),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(28),
//                   topRight: Radius.circular(28),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 12,
//                     offset: Offset(0, -4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(left: 24, right: 24, top: 20),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Lista de cuentas',
//                         style: TextStyle(
//                           color: Color(0xff1e234b),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(child: accountsCardList()),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future alert() {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: const Text(
//             "Aviso",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             "Debe colocar el nombre de la cuenta!",
//             style: TextStyle(fontSize: 15),
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 foregroundColor: const Color(0xff1e234b),
//               ),
//               child: const Text(
//                 "OK",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget accountsCardList() {
//     return FutureBuilder<List<Account>>(
//       future: DataBaseHelper.instance.getTest(),
//       builder: (context, AsyncSnapshot<List<Account>> snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.only(top: 50),
//               child: CircularProgressIndicator(color: Color(0xff1e234b)),
//             ),
//           );
//         }

//         final account = snapshot.data;
//         account!.sort(
//           ((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
//         );

//         if (account.isEmpty) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(40),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.inbox_outlined,
//                     size: 80,
//                     color: Colors.grey[300],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No tienes cuentas registradas',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Crea una nueva cuenta para comenzar',
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           itemCount: account.length,
//           physics: const BouncingScrollPhysics(),
//           itemBuilder: (context, index) {
//             return cardAccount(account[index], context);
//           },
//         );
//       },
//     );
//   }

//   Widget cardAccount(Account account, BuildContext context) {
//     return GestureDetector(
//       onTap: (() {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailsPage(account: account),
//           ),
//         ).then((_) => setState(() {}));
//       }),
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Material(
//           borderRadius: BorderRadius.circular(16),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(16),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetailsPage(account: account),
//                 ),
//               ).then((_) => setState(() {}));
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.white,
//                     Colors.grey[50]!,
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Colors.grey[200]!,
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // 🔹 Avatar + texto mejorado
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 56,
//                           height: 56,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 const Color(0xff1e234b).withOpacity(0.8),
//                                 const Color(0xff2c3170),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Center(
//                             child: Text(
//                               account.name[0].toUpperCase(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 account.name,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   color: Color(0xff1e234b),
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 17,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Ver detalles',
//                                 style: TextStyle(
//                                   color: Colors.grey[500],
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // 🔹 Acciones mejoradas
//                   Row(
//                     children: [
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(10),
//                           onTap: () async {
//                             final pdf = await ApiPdf.generaPdf(account.id!);
//                             ApiPdf.openFile(pdf);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.picture_as_pdf_outlined,
//                               color: Colors.red[600],
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(10),
//                           onTap: () async {
//                             await deleteAlert(
//                               context,
//                               '¿Seguro que deseas eliminar la cuenta?',
//                               account.id!,
//                               'Accounts',
//                             );
//                             setState(() {});
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.delete_outline,
//                               color: Colors.red[600],
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/Details/pages/details_page.dart';
import 'package:lleva_cuentas/Home/widgets/alert.dart';
import 'package:lleva_cuentas/Settings/pages/settings_page.dart';
import 'package:lleva_cuentas/utils/pdf.dart';
import 'package:lleva_cuentas/theme_manager.dart';
import '../../Database/account_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameAccountController = TextEditingController();

  @override
  void dispose() {
    nameAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = DataBaseHelper.instance;
    dbHelper.getTest();

    saveAccount(String name) {
      if (name.trim().isEmpty) {
        alert();
        return;
      }
      var account = Account(name: name);
      dbHelper.newAccount(account);
      nameAccountController.clear();
      setState(() {});
    }

    return Consumer<ThemeManager>(
      builder: (context, themeManager, _) {
        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mis Cuentas',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Gestiona tus finanzas',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Input mejorado con color dinámico
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.15),
                        colorScheme.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          controller: nameAccountController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nombre de la cuenta...',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              saveAccount(nameAccountController.text);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.primary.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                color: colorScheme.onPrimary,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Contenedor principal con colores dinámicos
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lista de cuentas',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: accountsCardList(colorScheme)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future alert() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Aviso",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Debe colocar el nombre de la cuenta!",
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget accountsCardList(ColorScheme colorScheme) {
    return FutureBuilder<List<Account>>(
      future: DataBaseHelper.instance.getTest(),
      builder: (context, AsyncSnapshot<List<Account>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            ),
          );
        }

        final account = snapshot.data;
        account!.sort(
          ((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
        );

        if (account.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: colorScheme.outline.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes cuentas registradas',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea una nueva cuenta para comenzar',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          itemCount: account.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return cardAccount(account[index], context, colorScheme);
          },
        );
      },
    );
  }

  Widget cardAccount(
    Account account,
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(account: account),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(account: account),
                ),
              ).then((_) => setState(() {}));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withOpacity(0.8),
                                colorScheme.primary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              account.name[0].toUpperCase(),
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ver detalles',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            await ApiPdf.generaPdf(account.id!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.picture_as_pdf_outlined,
                              color: colorScheme.error,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            await deleteAlert(
                              context,
                              '¿Seguro que deseas eliminar la cuenta?',
                              account.id!,
                              'Accounts',
                            );
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete_outline,
                              color: colorScheme.error,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
