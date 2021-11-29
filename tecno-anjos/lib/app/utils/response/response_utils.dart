import 'package:tecnoanjostec/app/models/code_response.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../object/object_utils.dart';

class ResponseUtils {

  static launchURL(url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
      {String namedResponse, int status}) {
    if (response?.sucess == null || response.error != null) {
      return ResponsePaginated(
          error: response.error ?? "Sem resposta do servidor!",status:status);
    }
    if (response.sucess.length == 0) {
      return ResponsePaginated.fromMapSimple(List<T>.from([]));
    }
    var tempResp = namedResponse != null
        ? response?.sucess[namedResponse]
        : response?.sucess;
    List<T> listElementGeneric = List<T>.from([]);
    List listElement = ObjectUtils.parseToObjectList<T>(tempResp,
        defaultValue: tempResp, isContent: true);

    if (listElement.isNotEmpty) {
      for (var columns in listElement) {
        var order = funcFromMap(columns);
        listElementGeneric.add(order);
      }
    }
    return ResponsePaginated.fromMap(response?.sucess, listElementGeneric,status:status);
  }

  static ResponsePaginated getResponsePaginatedObject<T>(
      CodeResponse response, Function funcFromMap,
      {bool isObject = true, String namedResponse, int status}) {
    if (!isObject) {
      return getResponsePaginated(response, funcFromMap,
          namedResponse: namedResponse,status:status);
    } else {
      if (response?.sucess == null || response.error != null) {
        return ResponsePaginated(
            error: response.error ?? "Sem resposta do servidor!",
            others: response.others,status:status);
      }
      var object = ObjectUtils.parseToMap(response?.sucess,
          defaultValue: response?.sucess);

      return ResponsePaginated.fromMapSimple(funcFromMap(object),
          others: response.others,status:status);
    }
  }

  static ResponsePaginated simpleResponse(CodeResponse response) {
    return ResponsePaginated.fromSimpleResponse(response);
  }

  static getBodyPageable({
    int page,
    int numberitens = 50,
    Map<String, dynamic> mapBody,
  }) {
    Map pageMap = <String, dynamic>{
      "page": page == 0 ? 1 : page,
      "numberitens": numberitens,
    };
    if (mapBody != null) {
      pageMap.addAll(mapBody);
    }
    return pageMap;
  }

  static String getUrlPaginate(int page, int size, String service) {
    return "$service?page=$page&size=$size";
  }
  static String getErrorBody(String service,String token,dynamic body, result, {defaultValue,bool showDev = false}) {
    var error = ObjectUtils.parseToMap(result, defaultValue: defaultValue) ?? result;
    if (service != null) {
      // reportError({"ServiceError":"$service => ${error.toString()}","TokenUser":token ??"", "Body":body},
      //     StackTrace.fromString(result?.toString() ?? ""))
      //     .then((value) => {print("error result $value")});
    }

    if (error is Map) {

      try{
        return (error["errorMessage"] != null) ? error["errorMessage"]["message"]?.toString() :
        (error["errorDevMessage"] != null) ?      error["errorDevMessage"]["message"]?.toString() :
        error["titulo"]?.toString() ??
            error["message"]?.toString() ??
            error["error_description"]?.toString() ??
            error["error"]?.toString() ??
            defaultValue?.toString();
      }catch(e){

      }

    }
    if(error?.toString()?.contains("html") ?? false){
      return (error?.toString()?.contains("Cannot") ?? false) ? "Serviço não existe": "Servidor indisponível";
    }else{
      return error?.toString();
    }
  }
}