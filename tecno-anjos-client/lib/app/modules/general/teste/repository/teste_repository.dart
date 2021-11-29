import 'package:flavor/flavor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/teste/model/teste.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

class TesteRepository {
  var _requestManager = Modular.get<RequestCore>();
  var scream = "repositoryteste";
  final servicoDeSalva = "/save";
  final servicoDeGet = "/getOnde";

  Future<ResponsePaginated> saveText(Teste teste) async {
    final result = await _requestManager.requestWithTokenToForm(
        scream, Flavor.I.getString(Keys.apiUrl),
        serviceName: servicoDeSalva,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST);

    return result;
  }

  Future<ResponsePaginated> getText() async {
    final result = await _requestManager.requestWithTokenToForm(
        scream, Flavor.I.getString(Keys.apiUrl),
        typeRequest: TYPEREQUEST.GET,
        isObject: true,
        serviceName: servicoDeGet,
        funcFromMap: (data) => Teste.fromMap(data));
    return result;
  }

  Future<ResponsePaginated> getTextList(page) async {
    final result = await _requestManager.requestWithTokenToForm(
        scream, Flavor.I.getString(Keys.apiUrl),
        isObject: false,
        typeRequest: TYPEREQUEST.GET,
        namedResponse: "rows",
        serviceName: servicoDeGet,
        funcFromMap: (data) => Teste.fromMap(data));
    // return ResponsePaginated();
    return ResponsePaginated(content: [Teste(),Teste(),Teste(),Teste(),Teste(),Teste(),Teste(),Teste()] );
  }
}
