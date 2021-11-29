import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';

import 'core/avaliation_repository.dart';
import 'models/avaliation.dart';
import 'models/total_avaliation.dart';

class AvaliationBloc extends Disposable {
  var listReceiverEvaluationInfo = BehaviorSubject<ResponsePaginated>();
  var listMakerEvaluationInfo = BehaviorSubject<ResponsePaginated>();
  var listPendentEvaluationInfo = BehaviorSubject<ResponsePaginated>();
  var totalEvaluationMedia = BehaviorSubject<TotalAvaluation>();

  var _repository = Modular.get<AvaliationRepository>();

  getListAvaliationPendent({int page = 1, bool isFilter = false}) async {
    if (page == 1 || isFilter) {
      listPendentEvaluationInfo.sink.add(null);

    }
    var result = await _repository.getListAvaliationPendent(page: page);
    var listTemp = List<Avaliation>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<Avaliation>(result.content));

    }


    if (page != 0) {
      result.content = (listTemp);
    }

    await Future.delayed(Duration(milliseconds: 100),
        () => listPendentEvaluationInfo.sink.add(result));
  }

  getTotal() async {
    var total = await _repository.getTotalAvaliations();

    if(total.error == null){
      var totalAvaliation  = (total.content as TotalAvaluation);
      totalEvaluationMedia.sink.add(totalAvaliation);
    }

  }

  getListAvaliationMaker({int page = 1, bool isFilter = false}) async {
    if (page == 1 || isFilter) {
      listMakerEvaluationInfo.sink.add(null);
    }
    var result = await _repository.getListAvaliationMaker(page: page);


    var listTemp = List<Avaliation>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<Avaliation>(result.content));



    }

    if (page != 0) {
      result.content = (listTemp);
    }

    await Future.delayed(Duration(milliseconds: 100),
        () => listMakerEvaluationInfo.sink.add(result));
  }

  getListAvaliationReceiver({int page = 1, bool isFilter = false}) async {
    if (page == 1 || isFilter) {
      listReceiverEvaluationInfo.sink.add(null);
    }
    var result = await _repository.getListAvaliationReceiver(page: page);
    var listTemp = List<Avaliation>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<Avaliation>(result.content));

    }


    if (page != 0) {
      result.content = (listTemp);
    }

    await Future.delayed(Duration(milliseconds: 100),
        () => listReceiverEvaluationInfo.sink.add(result));
  }

  @override
  void dispose() {
    listReceiverEvaluationInfo?.drain();
    listMakerEvaluationInfo?.drain();
    listPendentEvaluationInfo?.drain();
    totalEvaluationMedia?.drain();

  }

  void getTotalAvaliations() async {

    getTotal();

    // totalEvaluationMedia.sink.add(result.content ?? 0);
  }
}
