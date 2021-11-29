import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjos_franquia/app/core/request_core.dart';
import 'package:tecnoanjos_franquia/app/models/page/response_paginated.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/model/attendance.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';

class AttendanceRepository {
  var _requestManager = Modular.get<RequestCore>();
  static const  serviceAttendance = "/api/franchise/list/attendance";
  Future<ResponsePaginated> getListAttedance() async {
    // _getTitleItemWidget('Ação', 100),
    var user = await _requestManager.requestWithTokenToForm(
        serviceName: serviceAttendance,
        body: {},
        typeResponse: TYPERESPONSE.LIST,
        isXhttp: true,
        funcFromMap: (data) => Attendance.fromMap(data) ,
        typeRequest: TYPEREQUEST.GET);
    return user;
    // return ResponsePaginated(content: [
    //   Attendance(userTecno: Profile(name: "Tecnico nathan"),
    //       userClient: Profile(name: "Cliente nathan"),
    //       status: "F",
    //       hourAttendance: DateTime.now(),
    //       dateInit: DateTime.now().add(Duration(hours: -5)),
    //       dateEnd: DateTime.now()),
    //   Attendance(userTecno: Profile(name: "Tecnico nathan"),
    //       userClient: Profile(name: "Cliente nathan"),
    //       status: "IR",
    //       hourAttendance: DateTime.now(),
    //       dateInit: DateTime.now().add(Duration(hours: -5)),
    //       dateEnd: DateTime.now()),
    //   Attendance(userTecno: Profile(name: "Tecnico nathan"),
    //       userClient: Profile(name: "Cliente nathan"),
    //       status: "NQR",
    //       hourAttendance: null,
    //       dateInit: DateTime.now().add(Duration(hours: -5)),
    //       dateEnd: null),
    //   Attendance(userTecno: Profile(name: "Tecnico nathan"),
    //       userClient: Profile(name: "Cliente nathan"),
    //       status: "P",
    //       hourAttendance: DateTime.now(),
    //       dateInit: null,
    //       dateEnd: null)
    // ]);
  }

}