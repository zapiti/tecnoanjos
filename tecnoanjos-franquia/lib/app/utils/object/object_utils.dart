import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/page/response_paginated.dart';

class ObjectUtils {
  static String parseToString(data, [String defaultValue = '']) {
    if (data == null) return defaultValue;
    try {
      return data as String;
    } on Exception catch (exe) {
     debugPrint("Parse error $exe $data");
      return defaultValue;
    }
  }

  static dynamic parseToInt(data, {dynamic defaultValue = 0}) {
    if (data == null) return defaultValue;
    try {
      return double.parse(data?.toString() ?? "0").toInt();
    } on Exception catch (exe) {
     debugPrint("Parse error $exe $data");
      return 0;
    }
  }

  static dynamic parseToDouble(data, {dynamic defaultValue = 0.0}) {
    if (data == null) return defaultValue;
    try {
      if (data is double) {
        return data;
      } else {
        return double.parse(data.toString());
      }
    } on Exception catch (exe) {
     debugPrint("Parse error $exe $data");
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
        if (object["content"] != null) {
          if (object["content"] is List) {
            return object["content"].cast<T>().toList();
          } else {
            return [object["content"]].cast<T>().toList();
          }
        }
      }
      return object.cast<T>().toList();
    } on Exception catch (exe) {
      return object.cast<T>().toList();
    } catch (error) {
     debugPrint("Parse error $error $object");
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

  static dynamic parseToMap(result, {dynamic defaultValue = "{}"}) {
    if (result is Map) {
      return result;
    } else {
      if (result == null) {
        return defaultValue;
      }
      try {
        var jsons = json.decode(result.toString());
        return jsons;
      } catch (e) {
        return defaultValue;
      }

      return defaultValue;
    }
  }
}

Iterable<E> enumerate<E, T>(
    Iterable<T> items, E Function(int index, T item) f) {
  var index = 0;
  return items.map((item) {
    final result = f(index, item);
    index = index + 1;
    return result;
  });
}
