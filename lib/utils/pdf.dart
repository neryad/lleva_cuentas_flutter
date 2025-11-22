import 'dart:math';

import 'package:intl/intl.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/data_base_servie.dart';
import 'package:lleva_cuentas/utils/file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class ApiPdf {
  static Future<void> generaPdf(int id) async {
    final pdf = Document();

    final account = await DataBaseHelper.instance.getAccountById(id);
    final transactions = await DataBaseHelper.instance.getTransactionsById(id);
    transactions.sort(((a, b) => b.date.compareTo(a.date)));

    pdf.addPage(MultiPage(
        build: (context) => [
              documentTitle(account!),
              SizedBox(height: 3 * PdfPageFormat.cm),
              buildTitle(account),
              documentBody(transactions),
              Divider(),
              buildTotal(transactions),
              // buildFooter(transactions)
            ],
        footer: (context) => buildFooter()));

    await savePdf('${account?.name}Resumen', pdf);
  }

  static Widget buildAccountName(Account account) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(account.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('ID: ${account.id}'),
        ],
      );

  static documentTitle(Account account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildAccountName(account),
            Container(
              height: 50,
              width: 50,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data:
                    'https://play.google.com/store/apps/details?id=com.neryad.lleva_cuentas',
              ),
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            //buildCustomerAddress(invoice.customer),
            buildInvoiceInfo(),
          ],
        ),
      ],
    );
  }

  static Widget buildTitle(Account account) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen cuenta',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoiceInfo() {
    Random random = Random();
    var digits = random.nextInt(4);
    var currentDate = DateTime.now();

    final titles = <String>[
      'Numero de resumen:',
      'Fecha de resumen:',
    ];
    final data = <String>[
      digits.toString(),
      DateFormat('dd-MM-yyyy').format(currentDate)
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static documentBody(List<Transactions> transactions) {
    final header = ['Descripción', 'Fecha', 'Tipo', 'Monto'];

    final filterData = transactions.map((e) {
      var date = DateFormat('MMM d, yyyy').format(DateTime.parse(e.date));

      return [
        e.comment,
        date,
        e.type,
        e.amount,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: header,
      data: filterData,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Future<void> savePdf(String name, Document pdf) async {
    final bytes = await pdf.save();
    await FileHandleApi.saveDocument(name: name, bytes: bytes);
  }

  static double getTotal(Iterable<Transactions>? transactions) =>
      transactions?.isNotEmpty != true
          ? 0
          : transactions
                  ?.map((e) => e.amount * (e.isSaving() ? 1 : -1))
                  .reduce((value, element) => value + element) ??
              0;

  static buildTotal(List<Transactions> transactions) {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    final total = getTotal(transactions);
    var totalFormatted = myFormat.format(total);
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total en la cuenta \u0024  ',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: totalFormatted,
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Developer by', value: 'Neryad'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Donaciones',
              value: 'https://www.paypal.com/paypalme/neryad'),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }
}
