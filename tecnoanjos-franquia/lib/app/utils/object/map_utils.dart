

import 'package:tecnoanjos_franquia/app/models/pairs.dart';

import 'object_utils.dart';





class MapUtils {
  static List<Pairs> convertObjectToListPairs(Map<String, dynamic> decoded) {
    var listPairs = List<Pairs>();
    for (var colour in decoded.keys) {
      listPairs.add(Pairs(colour.toString(), decoded[colour]));
    }
//
//    decoded.keys.map(
//        (colour) => listPairs.add(Pairs(colour.toString(), decoded[colour])));
    return listPairs;
  }

  static Map convertListPairsToObject(List<Pairs> listPairs) {
    var tempObject = {};
    (listPairs).forEach((e) {
      tempObject.addAll(e.toSimpleMap(e.first));
    });

    listPairs.map((e) => tempObject.addAll(e.toSimpleMap(e.first)));
    return tempObject;
  }

  static List<Map<String, dynamic>> convertArrayToListMap(content) {
    if (content == null) {
      return List<Map<String, dynamic>>();
    }
    if (content.isEmpty) {
      return List<Map<String, dynamic>>();
    }
    var listTemp = ObjectUtils.parseToObjectList<Map<String, dynamic>>(content);

    return listTemp;
  }
}
