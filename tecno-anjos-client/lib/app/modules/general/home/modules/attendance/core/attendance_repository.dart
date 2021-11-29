import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';

import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';

import 'package:tecnoanjosclient/app/utils/response/response_utils.dart';

class AttendanceRepository {
  static const serviceGetListData = "/api/profile/attendance/listdata";
  var _requestManager = Modular.get<RequestCore>();

  static const serviceCancellAttendance = '/api/profile/attendance/cancel';
  static const serviceGetDetailAttendance = "/api/profile/attendance/listData/getOne";
  static const serviceAcceptAttendance =  '/api/profile/attendance/tecno/schedule/data';
  static const serviceTimeMaxHoursCancell = "/api/profile/system-parameter/data/getOne/maximumAttendanceTimeWithoutTechnician";

  static const ATTENDANCE = "ATTENDANCE_REPOSITORY";



  Future<ResponsePaginated> getListAttendance({int page}) async {
    var body =
        ResponseUtils.getBodyPageable(page: page, mapBody: {"filter": ActivityUtils.FINALIZADO});
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetListData,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

  Future<ResponsePaginated> getDetailsAttendance(int codAttendance) async {
    var body =  {"codAttendance":codAttendance};
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetDetailAttendance,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  getListCancel({int page}) async {
    var body =
        ResponseUtils.getBodyPageable(page: page, mapBody: {"filter": ActivityUtils.CANCELADO});
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetListData,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

  getListSchedule({int page}) async {
    var body =
        ResponseUtils.getBodyPageable(page: page, mapBody: {"filter": ActivityUtils.PENDENTE});
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetListData,
        body: body,
        funcFromMap: (data) => Attendance.fromMap(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return result;
  }

//   cancelAttendance(Attendance attendance) async {
//     var _dateTime =  await MyDateUtils.getTrueTime();
//     attendance?.dateEnd = MyDateUtils.convertDateToDate(_dateTime,_dateTime);
//     attendance?.status = ActivityUtils.CANCELADO;
//     attendance.clientNF = true;
//     var body = ActivityUtils.generateBody(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),_dateTime);
//     var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),
//         serviceName: serviceEditATTENDANCE,Flavor.I.getString(Keys.apiUrl),
//         body: body,
//         funcFromMap: (data) => Attendance.fromMap(data),
//         typerequest: TYPEREQUEST.PUT,
//         isObject: true);
//     return result;
// //    var result = await _requestManager.requestWithTokenToForm(
// //        serviceName: serviceCancellATTENDANCE,Flavor.I.getString(Keys.apiUrl),
// //        body: body,
// //        funcFromMap: (data) => Attendance.fromMap(data),
// //        typerequest: TYPEREQUEST.POST,
// //        isObject: false);
// //    return result;
//   }

  acceptAttendance(Attendance attendance) async {
    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAcceptAttendance,
        body: {
          "codAttendance": attendance?.id
        },
        funcFromMap: (data) =>Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<double> getTimeMaxHoursCancell() async {



    var result = await _requestManager.requestWithTokenToForm(ATTENDANCE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceTimeMaxHoursCancell ,
        body: {},
        funcFromMap: (data) =>data ,
        typeRequest: TYPEREQUEST.GET,
        isObject: true);
    if(result.content.toString().contains("value")){
      var secondValue =  ObjectUtils.parseToDouble(result.content['value']);
      return secondValue ;
    }else{
      return 0  ;
    }

  }

//  getTotalHoursWorked(type) async {
//    var totalHours = await _requestManager.requestWithTokenToForm(
//        serviceName: serviceGetTotal,
//        funcFromMap: (data) => data['totalTime'],
//        isObject: true,
//        typerequest: TYPEREQUEST.GET);
//    return totalHours;
//  }
}
