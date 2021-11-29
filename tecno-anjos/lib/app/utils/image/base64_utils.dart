import 'dart:convert';
import 'dart:typed_data';

class Base64Utils {
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static String base64DataToString(String base64String) {
    var data = dataFromBase64String(base64String);

    return utf8.decode(data);
  }
}
