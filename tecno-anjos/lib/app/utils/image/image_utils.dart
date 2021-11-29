import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjostec/app/models/pairs.dart';
import '../activity/activity_utils.dart';
import 'image_path.dart';
import 'package:universal_html/html.dart' as html;

class ImageUtils {
  static Image imageFromBase64String(String base64String,
      {double height, fit}) {
    return Image.memory(
      base64Decode(base64String),
      height: height,
      fit: fit,
    );
  }

 static Future<Pairs> pickImage() async {
    print('pickImage');
    final Map<String, dynamic> data = {};
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input..accept = 'image/*';

    input.click();
    await input.onChange.first;
    if (input.files.isEmpty) return null;
    final reader = html.FileReader();
    reader.readAsDataUrl(input.files[0]);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    // remove data:image/*;base64
    final stripped =
    encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    //final imageBase64 = base64.decode(stripped);
    final imageName = input.files?.first?.name;
    final imagePath = input.files?.first?.relativePath;
    data.addAll({'name': imageName, 'data': stripped, 'path': imagePath});
    final imageData = base64.decode(data['data']);
    return Pairs(Image.memory(imageData, semanticLabel: imageName,width: 120,height: 120,),data['data']);
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Widget getImageWithType({String tipo, String image}) {
    var noContainsImage = image == null;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: noContainsImage
                  ? null
                  : tipo == ActivityUtils.INICIADO
                      ? ImageUtils.imageFromBase64String(image,
                              fit: BoxFit.cover)
                          .image
                      : FadeInImage.assetNetwork(
                          placeholder: ImagePath.loadingPage,
                          image: image,

                        ).image)),
    );
  }



}
class WebImageInfo{
  String fileName;
  String filePath;
  String base64;
  String base64WithScheme;
  Uint8List data;
}