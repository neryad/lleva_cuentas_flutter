import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../Database/data_base_servie.dart';
import '../../utils/file_handle_api.dart';

class PersonalPdf {
  static Future<void> generaPdf({int? mes, int? anio}) async {
    final pdf = pw.Document();
    final transactions =
        await DataBaseHelper.instance.getPersonalTransactions(mes: mes, anio: anio);
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    final now = DateTime.now();
    final mesNombre = DateFormat('MMMM yyyy', 'es').format(now);

    double ingresos = 0;
    double gastos = 0;
    for (var t in transactions) {
      if (t.type == 'Ingreso' || t.type == 'Ahorro') {
        ingresos += t.amount;
      } else {
        gastos += t.amount;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Finanzas Personales - $mesNombre',
                  style: pw.TextStyle(fontSize: 20)),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Column(
                  children: [
                    pw.Text('Ingresos', style: pw.TextStyle(fontSize: 12)),
                    pw.Text(formatter.format(ingresos),
                        style: pw.TextStyle(
                            fontSize: 14, color: PdfColors.green)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Gastos', style: pw.TextStyle(fontSize: 12)),
                    pw.Text(formatter.format(gastos),
                        style: pw.TextStyle(fontSize: 14, color: PdfColors.red)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Balance', style: pw.TextStyle(fontSize: 12)),
                    pw.Text(formatter.format(ingresos - gastos),
                        style: pw.TextStyle(
                            fontSize: 14, color: PdfColors.blue)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Descripción', 'Fecha', 'Tipo', 'Monto'],
              data: transactions.map((t) => [
                    t.comment.isNotEmpty ? t.comment : t.type,
                    t.date.substring(0, 10),
                    t.type,
                    formatter.format(t.amount),
                  ]).toList(),
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    await FileHandleApi.saveDocument(name: 'FinanzasPersonales_$mesNombre', bytes: bytes);
  }
}
