import 'dart:convert';

import 'package:tecnoanjos_franquia/app/modules/login/bloc/login_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/code_response.dart';
import '../../models/page/response_paginated.dart';
import '../../utils/object/object_utils.dart';
import '../request_core.dart';

class ResponseUtils {
  static List<T> getResponseList<T>(
      CodeResponse response, Function funcFromMap) {
    if (response?.sucess == null) {
      return [];
    }
    List<T> listElementGeneric = [];
    List listContent = response?.sucess?.contains("content") ?? false
        ? (response?.sucess["content"]?.toList() ?? [])
        : response?.sucess?.toList();

    for (var columns in listContent) {
      var prods = funcFromMap(columns);
      listElementGeneric.add(prods);
    }
    return listElementGeneric;
  }

  static ResponsePaginated getResponsePaginated<T>(
      CodeResponse response, Function funcFromMap,
      {String namedResponse}) {
    if (response?.sucess == null || response.error != null) {
      return ResponsePaginated(
          error: response.error ?? "Falha ao carregar dados");
    }
    if (response.sucess.length == 0) {
      return ResponsePaginated.fromMapSimple(List<T>());
    }
    dynamic tempResp = response?.sucess.toString().contains("content") ? response?.sucess ["content"] :  response?.sucess  ;


    List<T> listElementGeneric = List<T>();
    List listElement = ObjectUtils.parseToObjectList<T>(tempResp,
        defaultValue: tempResp, isContent: true);

    if (listElement.isNotEmpty) {
      for (var columns in listElement) {
        var order = funcFromMap(columns);
        if(order is String){

        }else{
          listElementGeneric.add(order);
        }

      }
    }
    return ResponsePaginated.fromMap(response?.sucess, listElementGeneric);
  }

  static ResponsePaginated getResponsePaginatedObject<T>(
      CodeResponse response, Function funcFromMap,
      {TYPERESPONSE isObject , String namedResponse}) {
    if (isObject == TYPERESPONSE.LIST) {
      return getResponsePaginated(response, funcFromMap,
          namedResponse: namedResponse);
    } else {
      if (response?.sucess == null || response.error != null) {
        return ResponsePaginated(
            error: response.error ?? "Falha ao carregar dados",
            others: response.others);
      }
      Map tempResp = namedResponse != null
          ? response?.sucess[namedResponse]
          : response?.sucess;
      var object = ObjectUtils.parseToMap(tempResp.containsKey("content") ? tempResp["content"]:tempResp,
          defaultValue: response?.sucess);

      return ResponsePaginated.fromMapSimple(funcFromMap(object),
          others: response.others);
    }
  }

  static ResponsePaginated simpleResponse(CodeResponse response) {
    return ResponsePaginated.fromSimpleResponse(response);
  }

  static getBodyPageable(int page, int size, {Map mapBody}) {
    Map pageMap = <String, dynamic>{
      "page": page,
      "size": size,
    };
    if (mapBody != null) {
      pageMap.addAll(mapBody);
    }
    return pageMap;
  }

  static String getUrlPaginate(int page, int size, String service) {
    return "$service?page=$page&size=$size";
  }

  static String getErrorBody(result, {defaultValue}) {
    var error = ObjectUtils.parseToMap(result, defaultValue: defaultValue);

    if (error is Map) {
      return error.containsKey("errorMessage") ?error['errorMessage']["message"] : error.toString()??
          defaultValue?.toString();
    }
    return error?.toString();
  }

  static ResponsePaginated getResponseSKW(Response tempResponse, funcFromMap,
      {bool isObject, Exception error}) {
    CodeResponse codeResponse;


    debugPrint("RESPONSE SKW => ${jsonEncode(tempResponse.data)}");
    if (tempResponse == null) {
      return ResponsePaginated(error: ResponseUtils.getErrorBody(error));
    } else {
      var statusCode = tempResponse?.statusCode;
      if (statusCode == 200) {
        codeResponse = CodeResponse(sucess: tempResponse.data);
      } else {
        codeResponse =
            CodeResponse(error: ResponseUtils.getErrorBody(tempResponse.data));
      }

      if (codeResponse.error == null) {
//      final myTransformer = Xml2Json();
//      myTransformer.parse(codeResponse?.sucess.toString());
        var body = codeResponse.sucess ?? {};
        var status = body['status'];
        if (status == "1" || status == "2") {
          //   if (isObject == true) {
          return ResponsePaginated(content: funcFromMap(body['responseBody']));
//        }else{
//          return ResponsePaginated(content: funcFromMap(body['responseBody']));
//        }
        } else if (status == "0") {
          return ResponsePaginated(error: getErrorBody(body));
        } else if (status == "3") {
          Modular.get<LoginBloc>().getLogout();
          return ResponsePaginated(
              error: getErrorBody({"statusMessage": "usuario foi deslogado"}));
        } else {
          return ResponsePaginated(error: getErrorBody(body));
        }
      } else {
        return ResponsePaginated(
            error: getErrorBody(codeResponse?.error ?? {}));
      }
    }
  }

  static getValueTypeSK(data) {
    try {
      return data['\$'];
    } catch (e) {
      return data;
    }
  }

  static setValueTypeSK(data) {
    try {
      return {'\$': data};
    } catch (e) {
      return data;
    }
  }

  static getBodyLikeSKW({String serviceName, dynamic body}) {
    return {"serviceName": serviceName, "requestBody": body};
  }
}
