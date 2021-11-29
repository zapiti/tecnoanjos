import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/models/help_center.dart';

class HelpCenterRepository {
  static const serviceGetListData = "/api/helpcenter/listdata";
  static const serviceSearchGetListData = "/api/helpcenter/search/listdata";
  var _requestManager = Modular.get<RequestCore>();

  static const HELPCENTER = "HELP_CENTER_REPOSITORY";

  Future<ResponsePaginated> getListFaq({int page}) async {
    var result = await _requestManager.requestWithTokenToForm(HELPCENTER,
        serviceName: serviceGetListData,
        funcFromMap: (data) => HelpCenter.fromMap(data),
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    return result;
  }

  Future<ResponsePaginated> getListFaqSearch(String search, {int page}) async {
    var body = {
      "content": {
        "search": search,
        "page": 1,
        "numberitens": 50,
        "HelpCenter": false
      }
    };
    var result = await _requestManager.requestWithTokenToForm(HELPCENTER,
        serviceName: serviceSearchGetListData,
        funcFromMap: (data) => HelpCenter.fromMap(data),
        body: body,
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }
}
