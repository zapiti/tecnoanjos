import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';

import 'core/table_payment_repository.dart';
import 'models/table_payment.dart';

class TableMoneyBloc extends Disposable {
  var _repository = Modular.get<TablePaymentRepository>();

  var listTableMoneyInfo = BehaviorSubject<ResponsePaginated>();
  var _listTemptableMoney = List<TablePayment>.from([]);

  getListTableMoney({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      listTableMoneyInfo.sink.add(null);
      _listTemptableMoney.clear();
    }
    var result = await _repository.getListTableMoney(page: page);
    var listTemp = List<TablePayment>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<TablePayment>(result.content));
    }
    _listTemptableMoney.addAll(listTemp);
    _listTemptableMoney = _listTemptableMoney.toSet().toList();
    if (page != 0) {
      result.content = (_listTemptableMoney);
    }

    await Future.delayed(
        Duration(milliseconds: 200), () => listTableMoneyInfo.sink.add(result));
  }

  @override
  void dispose() {
    listTableMoneyInfo?.drain();
    _listTemptableMoney.clear();
  }
}
