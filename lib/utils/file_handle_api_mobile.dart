import 'dart:io';
import 'dart:typed_data';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileHandleApiImpl {
  static Future<void> saveDocument(
      {required String name, required Uint8List bytes}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(bytes);
    await OpenFilex.open(file.path);
  }
}
