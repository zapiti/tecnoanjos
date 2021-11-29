import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/model/heaven.dart';

class CallHeavenRepository {
  final _requestManager = Modular.get<RequestCore>();
  static const createProtocol = "/api/protocol";
  static const CALLHEAVEN = "CALLHEAVEN_REPOSITORY";

  Future<ResponsePaginated> createMyProtocol(int id) async {
    var body = {
      "attendance": {"id": id}
    };
    var result = await _requestManager.requestWithTokenToForm(CALLHEAVEN,
        serviceName: createProtocol,
        body: body,
        funcFromMap: (data) => Heaven.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }
}
