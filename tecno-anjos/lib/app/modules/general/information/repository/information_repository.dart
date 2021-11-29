import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

class InformationRepository {
  static const serviceReport = "/api/franchise/controlPanel/report";

  var _requestManager = Modular.get<RequestCore>();
  static const INFO = "INFORMATION_REPOSITORY";

  Future<ResponsePaginated> getListReport() async {
    //  var _body = generateBodyGeneric(null, nameEntity);
    var result = await _requestManager.requestWithTokenToForm(INFO,
        serviceName: serviceReport,
        funcFromMap: (data) => data,
        body: generateBodyGeneric(),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

  Map<String, dynamic> generateBodyGeneric() {
    return {
      "data": {"numberitens": 50, "page": 1}
    };
  }
}
