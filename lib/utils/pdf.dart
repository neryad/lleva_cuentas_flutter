import 'dart:io';

import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class ApiPdf {
  static Future<File> generaPdf(int id) async {
    final pdf = Document();

    final account = await DataBaseHelper.instance.getAccountById(id);
    final transactions = await DataBaseHelper.instance.getTransactionsById(id);
    transactions.sort(((a, b) => b.date.compareTo(a.date)));

    pdf.addPage(MultiPage(
        build: (context) => [
              documentTitle(account!),
              documentBody(transactions),
              buildFooter(transactions)
            ]));

    return savePdf('${account?.name}Resumen', pdf);
  }

  static documentTitle(Account account) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('Resumen de la cuenta: ${account.name}',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))
    ]);
  }

  static documentBody(List<Transactions> transactions) {
    final header = ['Monto', 'Descripción', 'Tipo', 'Fecha'];

    final filterData = transactions.map((e) {
      var date = DateFormat('MMM d, yyyy').format(DateTime.parse(e.date));

      return [e.amount, e.comment, e.type, date];
    }).toList();

    return Table.fromTextArray(
        data: filterData,
        headers: header,
        headerDecoration: const BoxDecoration(color: PdfColors.green300),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.centerRight,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight
        });
  }

  static Future<File> savePdf(String name, Document pdf) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(bytes);

    return file;
  }

  static double getTotal(Iterable<Transactions>? transactions) =>
      transactions?.isNotEmpty != true
          ? 0
          : transactions
                  ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
                  .reduce((value, element) => value + element) ??
              0;
  static Future openFile(File file) async {
    final url = file.path;
    await OpenFilex.open(url);
  }

  static buildFooter(List<Transactions> transactions) {
    final total = getTotal(transactions).toString();
    return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Row(children: [
          Expanded(
              child:
                  Text('Total: $total', style: const TextStyle(fontSize: 16)))
        ]));
  }
}
