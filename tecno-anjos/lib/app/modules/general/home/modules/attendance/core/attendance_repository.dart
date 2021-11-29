import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/response/response_utils.dart';

class AttendanceRepository {
  static const serviceGetListData = "/api/profile/attendance/listdata";
  var _requestManager = Modular.get<RequestCore>();

  static const serviceEditAttendance = "/api/profile/attendance/data/updateAndNotify";
  static const serviceCancellAttendance = '/api/profile/attendance/cancel';
  static const serviceGetDetailAttendance = "/api/profile/attendance/listData/getOne";

  static const ATTENDANCE = "ATTENDANCE_REPOSITORY";

  Future<ResponsePaginated> getListAttendance({int page}) async {
    var body = ResponseUtils.getBodyPageable(
        page: page, mapBody: {"filter": ActivityUtils.FINALIZADO});
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,
        serviceName: serviceGetListData,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

  Future<ResponsePaginated> getDetailsAttendance(int codAttendance) async {
    var body =  {"codAttendance":codAttendance};
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,
        serviceName: serviceGetDetailAttendance,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  getListCancel({int page}) async {
    var body = ResponseUtils.getBodyPageable(
        page: page, mapBody: {"filter": ActivityUtils.CANCELADO});
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,
        serviceName: serviceGetListData,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

  getListSchedule({int page}) async {
    var body = ResponseUtils.getBodyPageable(
        page: page, mapBody: {"filter": ActivityUtils.PENDENTE});
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,
        serviceName: serviceGetListData,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

}
