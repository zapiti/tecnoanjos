import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjos_franquia/app/core/request_core.dart';
import 'package:tecnoanjos_franquia/app/models/page/response_paginated.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/model/attendance.dart';
import 'package:tecnoanjos_franquia/app/modules/payment/model/payment.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';

class PaymentRepository {
  static const servicePayment = "/api/franchise/list/payments";
  var _requestManager = Modular.get<RequestCore>();

  Future<ResponsePaginated> getListPayment() async {
    // _getTitleItemWidget('Ação', 100),

    var user = await _requestManager.requestWithTokenToForm(
        serviceName: servicePayment,
        body: {},
        typeResponse: TYPERESPONSE.LIST,
        isXhttp: true,
        funcFromMap: (data) => Payment.fromMap(data),
        typeRequest: TYPEREQUEST.GET);
    return user;
    //
    // return ResponsePaginated(content: [
    //   Payment(
    //       paidAmount: 15.0,
    //       amount: 18.0,
    //       attendance:
    //       Attendance(userTecno: Profile(name: "Tecnico nathan"),
    //           userClient: Profile(name: "Cliente nathan"),
    //           status: "IR",
    //           hourAttendance: DateTime.now(),
    //           dateInit: DateTime.now().add(Duration(hours: -5)),
    //           dateEnd: DateTime.now())), Payment(
    //       paidAmount: 250.0,
    //       amount: 280.0,
    //       attendance:
    //       Attendance(userTecno: Profile(name: "Tecnico nathan"),
    //           userClient: Profile(name: "Cliente nathan"),
    //           status: "IR",
    //           hourAttendance: DateTime.now(),
    //           dateInit: DateTime.now().add(Duration(hours: -5)),
    //           dateEnd: DateTime.now())), Payment(
    //       paidAmount: 350.0,
    //       amount: 280.0,
    //       attendance:
    //       Attendance(userTecno: Profile(name: "Tecnico nathan"),
    //           userClient: Profile(name: "Cliente nathan"),
    //           status: "IR",
    //           hourAttendance: DateTime.now(),
    //           dateInit: DateTime.now().add(Duration(hours: -5)),
    //           dateEnd: DateTime.now()))
    // ]);
  }
}
