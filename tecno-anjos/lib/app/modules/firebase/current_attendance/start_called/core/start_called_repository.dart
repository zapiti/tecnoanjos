import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/models/avaliation.dart';

import '../current_attendance_bloc.dart';

class StartCalledRepository {
  static const serviceCreate = "/api/profile/attendance/user";

  static const serviceFinishData =
      "/api/profile/attendance/client/called/shutdown/data";

  static const serviceGetListDataCalled =
      "/api/profile/attendance/tecno/getAvailableAttendances";

  static const serviceGetQrcode =
      "/api/profile/attendance/tecno/schedule/qrcode/data";

  static const serviceInitAttendance =
      "/api/profile/attendance/tecno/init/data";

  static const serviceCreateAvaliation = "/api/avaliation/data";
  var _requestManager = Modular.get<RequestCore>();

  var serviceAlterStatus = "/api/profile/attendance/data/updateAndNotify";
  var serviceAddPendency = '/api/profile/attendance/itemsAndPendecy';

  var serviceAddValidation = '/api/profile/attendance/items/validation';
  static const STARTCALLED = "STARTCALLED_REPOSITORY";

  static const serviceGetDetailAttendance =
      "/api/profile/attendance/listData/getOne";

  var serviceAlterStatusNotNotify = "/api/profile/attendance/data/update";

  Future<ResponsePaginated> createAttendanceFake(
      String description, String date, String hours) async {
    var body = {
      "date": date,
      "description": description,
      "hours": hours,
      "status": "AB",
    };
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceCreate,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> getQrcode(int codAttendance) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceGetQrcode,
        body: {"codAttendance": codAttendance.toString()},
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> finishCalled(int codAttendance) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceFinishData,
        body: {
          "content": {"codAttendance": codAttendance}
        },
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> initAttendance(String qrCode) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceInitAttendance,
        body: {"codAttendance": qrCode.toString()},
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  avaluateAttendance(
      BuildContext context, resenha, rating, Attendance attendance) async {
    var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

    var avaliation = rating == null && resenha == null
        ? null
        : Avaliation(
            description: resenha,
            rating: rating,
            userReceiverId: attendance.userClient?.id,
            codAttendanceId: attendance?.id);
    currentBloc.patchAvaliation(context, attendance, avaliation);
  }

  Future<ResponsePaginated> getAcceptCalled() async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceGetListDataCalled,
        body: {"page": 1, "numberitens": 1},
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    if (result.content is List) {
      if (result.content.length > 0) {
        result.content = result.content.first;
      } else {
        result.content = null;
      }
    }

    return result;
  }

  notAlterStatus(Map body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceAlterStatusNotNotify,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  alterStatus(Map body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceAlterStatus,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  addPendency(Map<String, Map<String, Object>> body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceAddPendency,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> editOnlyAttendance(
      Map<String, Map<String, Object>> body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceAddPendency,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> acceptRefusedAlter(Map<String, Object> body) async {
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceAddValidation,
        body: body,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> getDetailsAttendance(int codAttendance) async {
    var body = {"codAttendance": codAttendance};
    var result = await _requestManager.requestWithTokenToForm(STARTCALLED,
        serviceName: serviceGetDetailAttendance,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }
}
