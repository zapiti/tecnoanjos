import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/faq/models/faq.dart';

class FaqRepository {
  static const serviceGetListData = "/api/help/listdata";
  static const serviceSearchGetListData = "/api/help/search/listdata";
  var _requestManager = Modular.get<RequestCore>();

  static const FAQ = "FAQ_REPOSITORY";

  Future<ResponsePaginated> getListFaq({int page}) async {
    var result = await _requestManager.requestWithTokenToForm(FAQ,
        serviceName: serviceGetListData,
        funcFromMap: (data) => Faq.fromMap(data),
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    return result;
  }
  Future<ResponsePaginated> getListFaqSearch(String search,{int page}) async {
    var body = {
      "content":{
        "search": search,
        "page": 1,
        "numberitens":50,
        "HelpCenter": false
      }
    };
    var result = await _requestManager.requestWithTokenToForm(FAQ,
        serviceName: serviceSearchGetListData,
        funcFromMap: (data) => Faq.fromMap(data),body:body,
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }
}
