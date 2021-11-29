import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/teste/repository/teste_repository.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import 'model/teste.dart';

class TesteBloc extends Disposable {
  final listTeste = BehaviorSubject<ResponsePaginated>();
  final oneTeste = BehaviorSubject<ResponsePaginated>();

  @override
  void dispose() {
    listTeste.drain();
    oneTeste.drain();
  }

  final _repository = Modular.get<TesteRepository>();

  saveText(BuildContext context, Teste teste) async {
    showLoading(true);
    final result = await _repository.saveText(teste);
    showLoading(false);
    if (result.error == null) {
      //faca algo
    } else {
      Utils.showSnackBar(result.error, context);
    }
  }

  getText() async {
    final result = await _repository.getText();
    oneTeste.sink.add(result);
  }

  getTextList({page}) async {
    final result = await _repository.getTextList(page);
    listTeste.sink.add(result);
  }
}
