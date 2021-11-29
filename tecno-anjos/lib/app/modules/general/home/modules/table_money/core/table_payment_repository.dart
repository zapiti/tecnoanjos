import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/models/table_payment.dart';

class TablePaymentRepository {
  static const serviceGetListData = "/api/profile/qualification/listdata";
  var _requestManager = Modular.get<RequestCore>();
  static const TABLE = "TABLE_PAYMENT_REPOSITORY";
  Future<ResponsePaginated> getListTableMoney({int page}) async {
    var listhours = await _requestManager.requestWithTokenToForm(TABLE,
        serviceName: serviceGetListData,
        funcFromMap: (data) => TablePayment.fromMap(data),
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    return listhours;
  }
}
