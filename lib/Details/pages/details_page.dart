import 'package:flutter/material.dart';

import '../../Home/pages/home_page.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1e234b),
        // title: const Text('Amara'),
        actions: const [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              'A',
              style: TextStyle(color: Color(0xff1e234b)),
            ),
          )
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
            children: const [
              Text(
                'Total en la cuenta de Amara',
                style: TextStyle(
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
                  Padding(padding: const EdgeInsets.all(8.0), child: card())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget card() {
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
              children: const [
                Text(
                  'Amara',
                  style: TextStyle(
                      color: Color(0xff1e234b), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '10-27-2022',
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
                const Text(
                  '-35',
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
