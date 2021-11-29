import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/code_response.dart';

import 'package:tecnoanjostec/app/models/pairs.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/models/payment.dart';
import 'package:tecnoanjostec/app/utils/response/response_utils.dart';

class PaymentRepository {
  static const serviceGetListData =
      "/api/payments/technician/invoices/list/data";
  static const PAYMENT = "PAYMENT_REPOSITORY";
  static const RECUSADO = "refused";
  static const ESTORNO = "refunded";
  static const PAGO = "paid";
  var _requestManager = Modular.get<RequestCore>();
  static const RECEIVED = 'RECEIVED';
  static const RECEIVABLE = 'RECEIVABLE';
  static const DISPUTE = 'DISPUTE';
  static const REFUSED = 'REFUSED';
  static const REFUNDED = 'REFUNDED';

  Future<Pairs> getListPayment(String tipo,
      {int page}) async {
    // var body =
    // ResponseUtils.getBodyPageable(page: page, mapBody: {"status": tipo});
    var response = await _requestManager.requestWithTokenToForm(PAYMENT,
        serviceName: serviceGetListData,
        typeRequest: TYPEREQUEST.POST,
        body: {
          "page":page+1,
          "numberItens":20,
          "status": tipo
        },
        funcFromMap: (data) => data,
        isObject: true);
    if(response.error == null){
      var contentResponse =  ResponseUtils.getResponsePaginatedObject(
          CodeResponse(
              sucess:  response?.content),
              (data) =>   Payment.fromMap(data),
          namedResponse: "invoices",
          isObject: false,
          status: 200);
      return Pairs(contentResponse,  response?.content["invoices"]["totalSum"] ?? 0.0);
    }else{
      return Pairs(response, 0.0);
    }


  }
}
