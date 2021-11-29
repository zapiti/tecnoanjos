
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/pendency.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';


class CurrentAttendanceRepository {
  var _requestManager = Modular.get<RequestCore>();
  static const CURRENT = "CURRENT_ATTENDANCE";
  var servicePatchInit = "/api/attendance/init/";
  var servicePatchAccept = "/api/attendance/accept/";
  var servicePatchStart = "/api/attendance/tecno/start/";
  var servicePatchEnd = "/api/attendance/end/";
  var servicePatchConclude = "/api/attendance/tecno/conclude/";
  var servicePatchConcludeCancel = "/api/attendance/generic/conclude/";
  var servicePatchConcludeClient = "/api/attendance/client/conclude/";
  var servicePatchAvaliation = "/api/attendance/tecno/avaliation/";
  var servicePatchNotInitNow = "/api/attendance/notinitnow/";
  var servicePatchCancel = "/api/attendance/cancel/";
  var servicePatchAcceptReview = "/api/attendance/technician/review/accept/";
  var serviceDeleteAwait = "/api/attendance/await/";
  var servicePatchCancelCurrent = "/api/attendance/cancel/alert/";
  var servicePatchReview = '/api/attendance/technician/review/refused/';

  Future<ResponsePaginated> patchAccept(Attendance attendance) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchAccept + attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchInit(Attendance attendance) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchInit + attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchStart(Attendance attendance, String text) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchStart + attendance?.id.toString()+ "?attendanceCode=${text?.toLowerCase()}",
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH ,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchEnd(Attendance attendance) async {

    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchEnd + attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchConclude(Attendance attendance) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName:  (attendance.status == ActivityUtils.CANCELADO
            ? servicePatchConcludeCancel
            : servicePatchConclude)  + attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchAvaliation(Attendance attendance,Avaliation avaliation) async {

    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchAvaliation + attendance?.id.toString(),body: avaliation?.toMap(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchNotInitNow(Attendance attendance) async {

    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchNotInitNow + attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchCancel(Attendance attendance, Pendency pendency) async {

    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchCancel + attendance?.id.toString(),body: pendency?.toMap(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchAcceptReview(Attendance attendance) async {

    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchAcceptReview+ attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  deleteAwait(Attendance attendance) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: serviceDeleteAwait+ attendance?.id.toString(),
        funcFromMap: (data) => data ,
        typeRequest: TYPEREQUEST.DELETE,
        isObject: true);
    return current;
  }

  patchCancelCurrentAttendance(Attendance attendance)async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchCancelCurrent+ attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  review(Attendance attendance, Pendency pendency) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchReview+ attendance?.id.toString(),body: pendency?.toMap(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchConcludeClient(Attendance attendance) async {

    var current = await _requestManager.requestWithTokenToForm(CURRENT,
        serviceName: servicePatchConcludeClient + attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

}
