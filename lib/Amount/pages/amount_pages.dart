import 'package:flutter/material.dart';

class AmountPage extends StatelessWidget {
  const AmountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial Selected Value
    String dropdownvalue = 'Ahorro';

    // List of items in our dropdown menu
    var items = [
      'Ahorro',
      'Gasto',
    ];
    return Scaffold(
      backgroundColor: const Color(0xff1e234b),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1e234b),
        title: const Text('Nueva transacción'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Seleccionar tipo',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          DropdownButton(
                            underline: const SizedBox.shrink(),
                            value: dropdownvalue,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: ((value) {
                              print(value);
                            }),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Monto',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 25),
                            // decoration: new InputDecoration(
                            //     labelText: "Enter your number"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Fecha transacción',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('04/11/2022',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                Row(
                                  children: [
                                    // Text('Tap para cambiar la fecha',
                                    //     style: TextStyle(
                                    //         fontSize: 20,
                                    //         fontWeight: FontWeight.w500)),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.calendar_month),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ])
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Comentario',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          TextField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            // decoration: new InputDecoration(
                            //     labelText: "Enter your number"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff1e234b),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Guardar',
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
