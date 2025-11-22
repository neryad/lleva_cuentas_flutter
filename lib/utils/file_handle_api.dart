import 'dart:typed_data';

import 'file_handle_api_mobile.dart'
    if (dart.library.html) 'file_handle_api_web.dart';

abstract class FileHandleApi {
  static Future<void> saveDocument(
      {required String name, required Uint8List bytes}) async {
    await FileHandleApiImpl.saveDocument(name: name, bytes: bytes);
  }
}
