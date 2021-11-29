import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';

import 'core/faq_repository.dart';
import 'models/faq.dart';

class FaqBloc extends Disposable {
  var _listFaqInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempFaq = List<Faq>.from([]);
  var _repository = Modular.get<FaqRepository>();

   get listFaqStream {
    return _listFaqInfo.stream;
  }

  Sink<ResponsePaginated> get setFaqValue {
    return _listFaqInfo.sink;
  }

  getListFaq({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      setFaqValue.add(null);
      _listTempFaq.clear();
    }
    var result = await _repository.getListFaq(page: page);
    var listTemp = List<Faq>.from([]);
    if (result.error == null) {
      listTemp.addAll(ObjectUtils.parseToObjectList<Faq>(result.content));
    }
    _listTempFaq.addAll(listTemp);
    _listTempFaq = _listTempFaq.toSet().toList();
    if (page != 0) {
      result.content = (_listTempFaq);
    }

    await Future.delayed(
        Duration(milliseconds: 100), () => setFaqValue.add(result));
  }
  getListSearch(String search) async {
    setFaqValue.add(null);
    var result = await _repository.getListFaqSearch(search);
    setFaqValue.add(result);
  }



  @override
  void dispose() {
    _listFaqInfo?.drain();
    _listTempFaq.clear();
  }
}
