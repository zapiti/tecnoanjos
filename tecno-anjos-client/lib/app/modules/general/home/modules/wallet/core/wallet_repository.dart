import 'dart:convert';

import 'package:flavor/flavor.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/main.dart';


class WalletRepository {
  static const serviceGetListData = "/api/v1/cards/";

  var _requestManager = Modular.get<RequestCore>();
  static const WALLET = "WALLET_REPOSITORY";
  static const serviceDeleteItem = "/api/v1/cards/";
  static const serviceCreateItem = "/api/v1/cards?withCardHash=false";
  static const serviceTransacao = "/api/v1/transactions";



  Future<ResponsePaginated> getListWallet({int page}) async {
    var result = await _requestManager.requestWithTokenToForm(WALLET,Flavor.I.getString(paymentUrl),
        serviceName: serviceGetListData,
        body: {"page": 1, "numberitens": 50},
        funcFromMap: (data) => Wallet.fromMap(data),
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    return result;
   //  return ResponsePaginated(content: [Wallet(number:"10839838654",
   //  verificationValue:"123",
   //  month:"09",
   //
   // holderCpf:"10839838654",
   //  cvvExpDate:"123", pagarmeCardId:"123456",
   //  year:"2020", main:true,
   //  description:"teste",
   //  id:"at",
   //  holderName:"Nathan ranghel",
   // brand:"visa")]);
  }

  // makePayment(Attendance attendance) async {
  //
  //   var result = await _requestManager.requestWithTokenToForm(WALLET,
  //       serviceName: serviceTransacao,url:AwsConfiguration.paymentUrl(),
  //       body:  {
  //       "cardId": attendance.paymentMethod.id,
  //       "value": 75.00,
  //       "attendance": attendance.toMap()},
  //       typeRequest: TYPEREQUEST.POST,
  //       funcFromMap: (data) => data,
  //       isObject: true);
  //   return result;
  // }


  deleteWallet(Wallet wallet) async {

    var result = await _requestManager.requestWithTokenToForm(WALLET,Flavor.I.getString(paymentUrl),
        serviceName: serviceDeleteItem + wallet.id,
        body: {},
        typeRequest: TYPEREQUEST.DELETE,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }
  updateCvv(Wallet wallet) async {


    var result = await _requestManager.requestWithTokenToForm(WALLET,Flavor.I.getString(paymentUrl),
        serviceName: serviceDeleteItem + wallet.id,
        body: {
          "cvv": wallet.verificationValue
        },
        typeRequest: TYPEREQUEST.PATCH,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }
  // editPaymentForm(Wallet wallet) async {
  //   var myAddress = wallet.toMap();
  //   jsonEncode(myAddress);
  //   var result = await _requestManager.requestWithTokenToForm(WALLET,
  //       serviceName: serviceUpdateItem,
  //       body: myAddress,
  //       typerequest: TYPEREQUEST.POST,
  //       funcFromMap: (data) => data,
  //       isObject: true);
  //   return result;
  // }

  savePaymentForm(Wallet wallet) async {

    //

    var myAddress = wallet.toMapCreate();
    jsonEncode(myAddress);
  //  if(wallet.paymentMethodId ==  null){
      var result = await _requestManager.requestWithTokenToForm(WALLET,Flavor.I.getString(paymentUrl),
          serviceName: serviceCreateItem,
          body: myAddress,
          typeRequest: TYPEREQUEST.POST,
          funcFromMap: (data) => Wallet.fromMap(data) ,
          isObject: true);
      return result;
    // }else{
    //   var result = await _requestManager.requestWithTokenToForm(WALLET,
    //       serviceName: serviceUpdateItem,
    //       body: myAddress,
    //       typerequest: TYPEREQUEST.POST,
    //       funcFromMap: (data) => data,
    //       isObject: true);
    //   return result;
    // }

  }

 Future<Wallet> getOneWallet() async {

   var result = await getListWallet();
    if(result.content == null ){
      return result.content;
    }else{
      return result.content.isEmpty ? null: result.content.first;
    }

  }
}
