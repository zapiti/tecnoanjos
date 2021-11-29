import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

class FinanceRepository {
  static const serviceListPayment= "/api/franchise/controlPanel/listPayment";

  var _requestManager = Modular.get<RequestCore>();

  static const FINANCE = "FINANCE_REPOSITORY";


  Future<ResponsePaginated> getListPayment() async {
    var _body = generateBodyGeneric();
    var result = await _requestManager.requestWithTokenToForm(FINANCE,
        serviceName: serviceListPayment,
        funcFromMap: (data) => data,
        body: _body,
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }


  Map<String, dynamic> generateBodyGeneric() {
    return {
      "data":  {"numberitens": 50, "page": 1}
    };
  }
}
