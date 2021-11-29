import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/core/help_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/models/help_center.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';

class HelpCenterBloc extends Disposable {
  var _listFaqInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempFaq = List<HelpCenter>.from([]);
  var _repository = Modular.get<HelpCenterRepository>();

  Stream<ResponsePaginated> get listFaqStream {
    return _listFaqInfo.stream;
  }

  Sink<ResponsePaginated> get setFaqValue {
    return _listFaqInfo.sink;
  }
  getListSearch(String search) async {
    setFaqValue.add(null);
    var result = await _repository.getListFaqSearch(search);
    setFaqValue.add(result);
  }
  getListFaq({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      setFaqValue.add(null);
      _listTempFaq.clear();
    }
    var result = await _repository.getListFaq(page: page);
    var listTemp = List<HelpCenter>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<HelpCenter>(result.content));
    }
    _listTempFaq.addAll(listTemp);
    _listTempFaq = _listTempFaq.toSet().toList();
    if (page != 0) {
      result.content = (_listTempFaq);
    }

    await Future.delayed(
        Duration(milliseconds: 100), () => setFaqValue.add(result));
  }

  @override
  void dispose() {
    _listFaqInfo?.drain();
    _listTempFaq.clear();
  }
}
