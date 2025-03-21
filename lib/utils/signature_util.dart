import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class SignatureUtil {
  static Future<String> saveSignatureToFile(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
