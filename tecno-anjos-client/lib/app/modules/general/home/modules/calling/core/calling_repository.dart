import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/calling.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';

class CallingRepository {
  static const serviceCreateData = "/api/profile/attendance/data/create";
  // static const serviceAlterAttendance =
  //     "/api/profile/attendance/data/updateAndNotify";
  static const serviceFavoriteIsOn = "/api/myWalletClient/isOnline";
  static const serviceCurrentUser =
      '/api/profile/system-parameter/data/getOne/attendanceHourPrice';

  static const  servicePaypending = "/api/attendance/client/paypending";
  
  static const serviceAttendanceResend = "/api/attendance/recreate/";
  static const serviceListService = "/api/profile/attendance/items";

  var _requestManager = Modular.get<RequestCore>();

  static const CALLING = "CALLING_REPOSITORY";

  Future<ResponsePaginated> checkFavoriteIsOn() async {
    var result = await _requestManager.requestWithTokenToForm(CALLING,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceFavoriteIsOn,
        funcFromMap: (data) => data,
        body: {},
        typeRequest: TYPEREQUEST.GET,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> soliciteAttendance(Calling calling) async {

      var body = calling.toMapCreate();

      jsonEncode(body);
      var result = await _requestManager.requestWithTokenToForm(CALLING,Flavor.I.getString(Keys.apiUrl),
          serviceName: serviceCreateData,
          funcFromMap: (data) => Attendance.fromMap(data),
          body: body,
          typeRequest: TYPEREQUEST.POST,
          isObject: true);
      return result;

  }

  Future<ResponsePaginated> currentMoney() async {
    var result = await _requestManager.requestWithTokenToForm(CALLING,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceCurrentUser,
        funcFromMap: (data) =>
            ObjectUtils.parseToDouble(data['value'].toString()),
        body: {},
        typeRequest: TYPEREQUEST.GET,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> payPendingAttendance(Attendance attendance, Wallet wallet) async {

    var result = await _requestManager.requestWithTokenToForm(CALLING,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePaypending,
        funcFromMap: (data) => data,
        body:    {
          "attendanceId": attendance.id,
          "cardId": wallet.id
        },
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return result;

  }

  soliciteAttendanceResend(Attendance attendance, DateTime date) async {
    var result = await _requestManager.requestWithTokenToForm(CALLING,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAttendanceResend + attendance.id.toString(),
        funcFromMap: (data) => data,
        body:   {
          "hourAttendance": MyDateUtils.converStringServer(date, null)
        },
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> getListService() async{
    var result = await _requestManager.requestWithTokenToForm(CALLING,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceListService,
        funcFromMap: (data) =>ServiceProd.fromMap(data) ,
        body: {},
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    return result;
    // return ResponsePaginated(content: [
    //   ServiceProd(name:'Antivirus',price: 150,type: ServiceProd.REMOTE),
    //   ServiceProd(name:'Backup',price: 90,type: ServiceProd.REMOTE),
    //   ServiceProd(name:'E-mail', price:70,type: ServiceProd.REMOTE),
    //   ServiceProd(name:'Impressora',price: 60,type: ServiceProd.PRESENTIAL),
    //   ServiceProd(name:'Link Internet',price: 30,type: ServiceProd.PRESENTIAL),
    // ] );
  }
}
