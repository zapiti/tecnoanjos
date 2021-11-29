import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

class SugestionRepository {
  var _requestManager = Modular.get<RequestCore>();
  var serviceCreateData = "/api/profile/suggestion";

 static const SUGESTOES = "SUGESTIONS_REPOSITORY";


  Future<ResponsePaginated> creatSuggestion(String descricao, bool isSugestion) async {

    var result = await _requestManager.requestWithTokenToForm(SUGESTOES,
        serviceName: serviceCreateData,
        body: {"description": descricao,    "disapproval": !isSugestion},
        typeRequest: TYPEREQUEST.POST,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }
}
