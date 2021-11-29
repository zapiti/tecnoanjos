
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/models/avaliation.dart';



class StartCalledRepository {
  static const STARTCALLED = "STARTCALLED_REPOSITORY";

  static const serviceGetListData = "/api/payments/client/invoices/list/data";
  static const withoutTechnician =
      '/api/profile/attendance/client/listData/withoutTechnician';
  static const serviceCreate = "/api/profile/attendance/user";

  static const serviceInvoices = "/api/payments/invoice";
  static const serviceFinishData =
      "/api/profile/attendance/client/called/shutdown/data";

  static const serviceGetQrcode =
      "/api/profile/attendance/tecno/schedule/qrcode/data";

  static const serviceInitAttendance =
      "/api/profile/attendance/tecno/init/data";

  var _requestManager = Modular.get<RequestCore>();

  static const serviceManuali =
      "/api/profile/attendance/tecno/schedule/qrcode/data";

  static const serviceFinishAttendance =
      "/api/profile/attendance/client/called/finish/data";
  static const serviceShutdownAttendance =
      "/api/profile/attendance/client/called/shutdown/data";

  // static const serviceNextAttendance =
  //     "/api/profile/attendance/client/schedule/next/data";
  static const serviceCurrentAttendance =
      "/api/profile/attendance/client/called/listData";

  var serviceCreateAvaliation = "/api/avaliation/data";
  static const serviceGetDetailAttendance =
      "/api/profile/attendance/listData/getOne";
  var serviceAlterStatus = "/api/profile/attendance/data/updateAndNotify";
  var serviceAlterStatusNotNotify = "/api/profile/attendance/data/update";
  var serviceAddPendency = '/api/profile/attendance/itemsAndPendecy';

  var serviceAddValidation = '/api/profile/attendance/items/validation';
  static const serviceUpdateCvv = "/api/payments/card/";

  // /api/profile/attendance/data/update
  initAttendance(String qrCode) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceInitAttendance,
        body: {"codAttendance": qrCode},
        typeRequest: TYPEREQUEST.POST,
        funcFromMap: (data) => data,
        isObject: true);

    return result;
  }

  generateQrcode(String codAttendance) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceManuali,
        body: {"codAttendance": codAttendance},
        typeRequest: TYPEREQUEST.POST,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }

  finishAttendance(Attendance value) async {
    return await finishOnly(value);
  }

  Future<ResponsePaginated> finishOnly(Attendance value) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceFinishAttendance,
        body: {"codAttendance": value?.id},
        typeRequest: TYPEREQUEST.POST,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }

  shutDownAttendance(Attendance value) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceShutdownAttendance,
        body: {
          "content": {"codAttendance": value?.id}
        },
        typeRequest: TYPEREQUEST.POST,
        funcFromMap: (data) => Attendance.fromMap(data),
        isObject: true);
    return result;
  }



  avaliateAttendance(
      BuildContext context, resenha, rating, Attendance attendance) async {
    var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

    var avaliation = rating == null && resenha == null
        ? null
        : Avaliation(
            description: resenha,
            rating: rating,
            userReceiverId: attendance.userTecno?.id,
            codAttendanceId: attendance?.id);
    currentBloc.patchAvaliation(context, attendance, avaliation);

  }

  Future<ResponsePaginated> createAttendanceFake(
      String description, String date, String hours) async {
    var body = {
      "date": date,
      "description": description,
      "hours": hours,
      "status": "AB",
    };
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceCreate,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> getQrcode(int codAttendance) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetQrcode,
        body: {"codAttendance": codAttendance.toString()},
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> finishCalled(int codAttendance) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceFinishData,
        body: {
          "content": {"codAttendance": codAttendance}
        },
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  // Future<ResponsePaginated> getNextCalled() async {
  //   var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
  //       serviceName: serviceNextAttendance,
  //       funcFromMap: (data) => Attendance.fromMap(data),
  //       typerequest: TYPEREQUEST.GET,
  //       isObject: true);
  //
  //   if (result.content is List) {
  //     if (result.content.length > 0) {
  //       print("retorna a lista");
  //     } else {
  //       result.content = null;
  //     }
  //   }
  //
  //   return result;
  // }

  alterStatus(Map body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAlterStatus,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  addPendency(Map<String, Map<String, Object>> body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAddPendency,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> editOnlyAttendance(
      Map<String, Map<String, Object>> body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAddPendency,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> acceptRefusedAlter(Map<String, Object> body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAddValidation,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  alterStatusNotNotfy(Map body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAlterStatusNotNotify,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> getDetailsAttendance(int codAttendance) async {
    var body = {"codAttendance": codAttendance};
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetDetailAttendance,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> checkInvoice(Attendance attendance) async {
    //todo essa funcao nao vai funciona em producao
    var result2 = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceInvoices,
        body: {"codAttendance": attendance?.id},
        typeRequest: TYPEREQUEST.POST,
        funcFromMap: (data) => data,
        isObject: true);

    return result2;
  }

  Future<ResponsePaginated> updateCvv(
      Attendance attendance, String novoCvv) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,Flavor.I.getString(Keys.apiUrl),
        serviceName:
            serviceUpdateCvv + attendance.paymentMethod?.paymentMethodId.toString() + "/cvv",
        body: {"cvv": novoCvv},
        typeRequest: TYPEREQUEST.PATCH,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }
}
