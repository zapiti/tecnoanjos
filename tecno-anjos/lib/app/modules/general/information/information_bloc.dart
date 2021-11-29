import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/information/repository/information_repository.dart';



class InformationBloc extends Disposable {
  var listMenuSubject  = BehaviorSubject<ResponsePaginated>();
  var _repository = Modular.get<InformationRepository>();

  void getListMenu()async {
    var result = await _repository.getListReport();
    listMenuSubject.sink.add(result );
  }
  @override
  void dispose() {
    listMenuSubject.drain();
  }
}
