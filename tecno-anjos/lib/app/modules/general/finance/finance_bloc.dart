import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

import 'core/finance_repository.dart';

class FinanceBloc extends Disposable {
  var _repository = Modular.get<FinanceRepository>();
  var listElementDinamic = BehaviorSubject<ResponsePaginated>();

  var autoGenPass = BehaviorSubject<bool>.seeded(false);

  getGenericData() async {
    listElementDinamic.add(null);
    var result = await _repository.getListPayment();
    listElementDinamic.add(result);
  }


  @override
  void dispose() {
    listElementDinamic.drain();
    autoGenPass.drain();
  }
}
