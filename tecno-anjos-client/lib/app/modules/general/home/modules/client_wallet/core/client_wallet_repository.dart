import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/client_wallet/models/client_wallet.dart';


import 'package:tecnoanjosclient/app/utils/response/response_utils.dart';

class ClientWalletRepository {
  static const serviceGetListData = "/api/myWalletClient/client/listData";
  static const serviceCreateData = "/api/myWalletClient/data";
  static const serviceRemoveData = '/api/myWalletClient/delete/data';
  static const CLIENT = "CLIENT_REPOSITORY";
  var _requestManager = Modular.get<RequestCore>();
  final appBloc = Modular.get<AppBloc>();

  Future<ResponsePaginated> getListClientWallet({int page}) async {
    var currentUser =  appBloc.getCurrentUserFutureValue().stream.value;
    var body = ResponseUtils.getBodyPageable(
        page: page ?? 0, mapBody: {"filter": currentUser?.id});
    var result = await _requestManager.requestWithTokenToForm(CLIENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetListData,
        body: body,namedResponse: "content",
        funcFromMap: (data) => ClientWallet.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

  Future<ResponsePaginated> saveCodClient(String data) async {
    var currentUser =  appBloc.getCurrentUserFutureValue().stream.value;
    var body = {
      "idClient": currentUser?.id,
      "tagTechnician": data
    };
    var result = await _requestManager.requestWithTokenToForm(CLIENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceCreateData,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated>  removeTecno(ClientWallet clientWallet) async{

    var body = {
        "walletId": clientWallet.walletId
    };
    var result = await _requestManager.requestWithTokenToForm(CLIENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceRemoveData,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }
}
