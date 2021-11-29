import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

class ReceiverCalledRepository {

  static const serviceAccept = "/api/profile/attendance/tecno/schedule/data";
  static const serviceRefuse = "/api/profile/attendance/tecno/schedule/data/refused";
  static const serviceGetListDataCalled = "/api/profile/attendance/tecno/getAvailableAttendances";
  var _requestManager = Modular.get<RequestCore>();
  static const RECEIVER = "RECEIVER_CALLED_REPOSITORY";



  Future<ResponsePaginated> acceptCalled(Attendance attendance) async {
    var result = await _requestManager.requestWithTokenToForm(RECEIVER,
        serviceName: serviceAccept,
        body: {"codAttendance": attendance?.id},
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> refusedCalled(int codAtendance) async {
    var result = await _requestManager.requestWithTokenToForm(RECEIVER,
        serviceName: serviceRefuse,
        body: {"codAttendance": codAtendance},
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> getLisCalled() async {
    var result = await _requestManager.requestWithTokenToForm(RECEIVER,
        serviceName: serviceGetListDataCalled,
        body:
        {"page":1,"numberitens":50},
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.GET,
        isObject: false);

    return result;
  }
}
