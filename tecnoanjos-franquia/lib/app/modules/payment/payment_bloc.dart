import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjos_franquia/app/modules/payment/core/payment_repository.dart';
import 'package:tecnoanjos_franquia/app/utils/object/object_utils.dart';

import 'model/payment.dart';

class PaymentBloc extends Disposable {
  final listPaymentSubject = BehaviorSubject<List<Payment>>();

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    listPaymentSubject.drain();
  }

  var _repository = PaymentRepository();

   getListPayment() async {
    listPaymentSubject.sink.add(null);
    var response = await _repository.getListPayment();

    listPaymentSubject.sink
        .add(ObjectUtils.parseToObjectList<Payment>(response.content ?? []));

  }
}
