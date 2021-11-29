
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';

import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/pendency.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';


class CurrentAttendanceRepository {
  var _requestManager = Modular.get<RequestCore>();
  static const CURRENT = "CURRENT_ATTENDANCE";
  static const serviceUpdateCvv = "/api/payments/card/";

  // get - /api/attendance/requestpullback
  // patch - /api/attendance/init/:id
  var servicePatchInit = "/api/attendance/init/";

  // patch - /api/attendance/accept/:id
  var servicePatchAccept = "/api/attendance/accept/";

  // patch - /api/attendance/tecno/start/:id
  // patch - /api/attendance/client/start/:id
  var servicePatchStart = "/api/attendance/client/start/";

  // patch - /api/attendance/end/:id
  var servicePatchEnd = "/api/attendance/end/";

  // patch - /api/attendance/client/conclude/:id
  // patch - /api/attendance/tecno/conclude/:id
  var servicePatchConclude = "/api/attendance/client/conclude/";
  var servicePatchConcludeCancel = "/api/attendance/generic/conclude/";

  // patch - /api/attendance/client/avaliation/:id
  // patch - /api/attendance/tecno/avaliation/:id
  var servicePatchAvaliation = "/api/attendance/client/avaliation/";

  // patch - /api/attendance/notinitnow/:id
  var servicePatchNotInitNow = "/api/attendance/notinitnow/";

  // patch - /api/attendance/cancel/:id
  var servicePatchCancel = "/api/attendance/cancel/";

  var servicePatchReview = "/api/attendance/client/review/";

  var serviceDeleteAwait = "/api/attendance/await/";

  var servicePatchCancelCurrent = "/api/attendance/cancel/alert/";

  var servicePatchAcceptReview = "/api/attendance/technician/review/accept/";

  var servicePatchReschedule = '/api/attendance/reschedule/';


  Future<ResponsePaginated> patchInit(Attendance attendance) async {
    // attendance.status = ActivityUtils.REMOTAMENTE;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchInit + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchAccept(Attendance attendance) async {
    // attendance.status = ActivityUtils.REMOTAMENTE;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchAccept + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchStart(Attendance attendance) async {
    // attendance.status = ActivityUtils.EM_ATENDIMENTO;
    // attendance.dateInit = Modular.get<AppBloc>().dateNowWithSocket.stream.value;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();j

    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchStart + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchEnd(Attendance attendance) async {
    // attendance.status = ActivityUtils.ENCERRADO;
    // attendance.dateEnd = Modular.get<AppBloc>().dateNowWithSocket.stream.value;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchEnd + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchConclude(Attendance attendance) async {
    // attendance.clientNF = true;
    // attendance.status = ActivityUtils.FINALIZADO;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: (attendance.status == ActivityUtils.CANCELADO
                ? servicePatchConcludeCancel
                : servicePatchConclude) +
            attendance?.id.toString(),
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchAvaliation(
      Attendance attendance, Avaliation avaliation) async {
    // attendance.clientAvaliation  = true;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchAvaliation + attendance?.id.toString(),
        body: avaliation?.toMap(),
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchNotInitNow(Attendance attendance) async {
    // attendance.status  = ActivityUtils.PENDENTE;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchNotInitNow + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchCancel(
      Attendance attendance, Pendency pendency) async {
    // attendance.status  = ActivityUtils.CANCELADO;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchCancel + attendance?.id.toString(),
        body: pendency?.toMap(),
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> updateCvv(
      Attendance attendance, String novoCvv) async {
    var result = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceUpdateCvv + attendance?.id.toString() + "/cvv",
        body: {"cvv": novoCvv},
        typeRequest: TYPEREQUEST.PATCH,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> review(
      Attendance attendance, Pendency pendency) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchReview + attendance?.id.toString(),
        body: pendency?.toMap(),
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  deleteAwait(Attendance attendance) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceDeleteAwait + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.DELETE,
        isObject: true);
    return current;
  }

  patchCancelCurrentAttendance(Attendance attendance) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchCancelCurrent + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchAcceptReview(Attendance attendance) async {
    // attendance.status  = ActivityUtils.PENDENTE;
    // _updateStatus(attendance,attendance);
    // return ResponsePaginated();
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchAcceptReview + attendance?.id.toString(),
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }

  Future<ResponsePaginated> patchReschedule(Attendance attendance) async {
    var current = await _requestManager.requestWithTokenToForm(CURRENT,Flavor.I.getString(Keys.apiUrl),
        serviceName: servicePatchReschedule + attendance?.id.toString(),
        funcFromMap: (data) => data,
        body: attendance.toMap(),
        typeRequest: TYPEREQUEST.PATCH,
        isObject: true);
    return current;
  }
}
