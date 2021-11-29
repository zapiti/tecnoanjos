import 'dart:convert';

import 'package:tecnoanjos_franquia/app/core/utils/response_utils.dart';
import 'package:tecnoanjos_franquia/app/models/pairs.dart';

class ResponseConverterUtils {
  static Map convertCnpjResp(Map response) {
    try {
      List fields = response["metadata"]["fields"]['field'].toList();
      List values = listEntity(response);

      Map<String, dynamic> bodyMap = {};
      fields.forEach((element) {
        var index = fields.indexOf(element);
        bodyMap[element["name"].toString()] =
            ResponseUtils.getValueTypeSK(values[index]);
      });
      return bodyMap;
    } catch (e) {
      return null;
    }
  }

  static List<T> convertMapListResponse<T>(
      dynamic response, Function funcFromMap) {
    try {
      if (response is List) {
        List fields = response.map<T>((e) => funcFromMap(e)).toList();

        return fields;
      } else if (response is Map) {
        return [funcFromMap(response)];
      } else {
        return [funcFromMap(response)];
      }
    } catch (e) {
      return null;
    }
  }

  static List listEntity(Map response) {
    return List<int>.generate(15, (i) => i + 1)
        .map((e) => response["entity"]['f${e - 1}'])
        .toList();
  }

  static List convertFformat(Map response) {
    try {
      List fields = response["metadata"]["fields"]['field'].toList();
      List values = listEntity(response);
      var mapTemp = List();

      values.forEach((element) {
        Map<String, dynamic> bodyMap = {};
        fields.forEach((element2) {
          var index = fields.indexOf(element2);
          bodyMap[element2.toString()] = element["f$index"];
        });
        mapTemp.add(jsonEncode(bodyMap));
      });
      return mapTemp;
    } catch (e) {
      return null;
    }
  }

  static List<Pairs> convertNoToPairs(Map arvore) {
    List<Pairs> listMainActivity = arvore["no"]
        .map<Pairs>((e) => Pairs(e["codigo"], e["descricao"],
            third: e['caminho'], four: e['analitico']))
        .toList();

    return listMainActivity;
  }
}
