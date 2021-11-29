import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/core/payment_repository.dart';


class PaymentsBloc extends Disposable {
  var listPaymentInfoSubject = BehaviorSubject<ResponsePaginated>();

  var _repository = Modular.get<PaymentRepository>();

  var totalPagamento = BehaviorSubject<double>.seeded(0.0);

  var listPaymentPendetesStream = BehaviorSubject<ResponsePaginated>();

  getListPayment({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      totalPagamento.sink.add(0.0);
      listPaymentInfoSubject.sink.add(null);
    }
    var result =
    await _repository.getListPayment(PaymentRepository.RECEIVED, page: page);
    //   var listTemp = List<Payment>.from([]);
    if (result.first.error == null) {
      // listTemp.addAll(ObjectUtils.parseToObjectList<Payment>(result.first.content));
    }
    double total = double.tryParse(result.second.toString());
    totalPagamento.sink.add(total);
    await Future.delayed(
        Duration(milliseconds: 100), () => listPaymentInfoSubject.add(result.first));
  }

  getListPaymentPendetes({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      totalPagamento.sink.add(0.0);
      listPaymentPendetesStream.sink.add(null);
    }
    var result =
    await _repository.getListPayment(PaymentRepository.REFUSED, page: page);
    // var listTemp = List<Payment>.from([]);
    if (result.first.error == null) {
      // listTemp.addAll(ObjectUtils.parseToObjectList<Payment>(result.first.content));
    }
    double total = double.tryParse(result.second.toString());

    totalPagamento.sink.add(total);
    await Future.delayed(
        Duration(milliseconds: 100), () => listPaymentPendetesStream.add(result.first));
  }

  @override
  void dispose() {
    listPaymentInfoSubject?.drain();
    listPaymentPendetesStream.drain();
    totalPagamento.drain();
  }
}
