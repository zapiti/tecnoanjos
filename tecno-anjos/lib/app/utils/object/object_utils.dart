import 'dart:convert';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';

class ObjectUtils {
  bool _containsElement(Conversation e,List element) {
    for (Conversation element in element) {
      if (element?.id.toString().compareTo(e?.id.toString()) == 0) return true;
    }
    return false;
  }

  List<Conversation> removeDuplicates(List element) {
    List<Conversation> tempList = [];

    element.forEach((element) {
      if (!_containsElement(element,tempList)) tempList.add(element);
    });

    return tempList;
  }
  static String parseToString(data, [String defaultValue = '']) {
    if (data == null) return defaultValue;
    try {
      return data as String;
    } on Exception catch (exe) {
      print("Parse error $exe $data");
      return defaultValue;
    }
  }

  static dynamic parseToInt(data, {dynamic defaultValue = 0}) {
    if (data == null) return defaultValue;
    try {
      return double.parse(data?.toString() ?? "0").toInt();
    } on Exception catch (exe) {
      print("Parse error $exe $data");
      return 0;
    }
  }

  static double parseToDouble(data, {double defaultValue = 0.0}) {
    if (data == null) return defaultValue;
    if (data == "null") return defaultValue;
    if (data.toString().isEmpty) return defaultValue;
    try {
      if (data is double) {
        return data;
      } else {
        return double.parse(data.toString());
      }
    } on Exception catch (exe) {
      print("Parse error $exe $data");
      return defaultValue;
    }
  }

  static parseToObjectList<T>(dynamic object,
      {dynamic defaultValue, dynamic type, bool isContent = false}) {
    if (object == null) {
      return [];
    }
    try {
      if (isContent) {
        if (object is Map) {
          if (object["content"] != null) {
            if (object["content"] is List) {
              return object["content"].cast<T>().toList();
            } else {
              return [object["content"]].cast<T>().toList();
            }
          }
        }
      } else if (object is List) {
        return object.cast<T>().toList();
      }
      return object.cast<T>().toList();
    } on Exception catch (_) {
      return object.cast<T>().toList();
    } catch (error) {
      print("Parse error $error $object");
      return defaultValue;
    }
  }

  static bool isEmpty(data) {
    if (data == null) {
      return true;
    } else if (data is ResponsePaginated) {
      if (data.content == null) {
        return true;
      }
      if (data.content is List) {
        return data.content.isEmpty;
      } else {
        return false;
      }
    }

    return data.toString().isEmpty;
  }

  static Object isNumeric(value) {
    if (value == null || value is List) {
      return false;
    }
    return double.tryParse(value) != null || int.tryParse(value) != null;
  }

  static dynamic parseToMap(
    result, {
    dynamic defaultValue = "{}",
  }) {
    if (result is Map) {
      return result;
    } else {
      if (result == null) {
        return defaultValue;
      }
      try {
        var resulted = json.decode(result.toString());
        return resulted;
      } catch (e) {
        return defaultValue;
      }
    }
  }

  static double getValueWithMoney(String value) {
    if(value == ""){
      return 0.0;
    }else{
      String _onlyDigits = value.replaceAll(RegExp('[^0-9]'), "");
      double _doubleValue = double.parse(_onlyDigits) / 100;
      return  _doubleValue;
    }
  }
}
