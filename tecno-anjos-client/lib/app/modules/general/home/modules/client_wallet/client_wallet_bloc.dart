import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';


import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'core/client_wallet_repository.dart';
import 'models/client_wallet.dart';

class ClientWalletBloc extends Disposable {
  var _listFaqInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempClientWallet = List<ClientWallet>.from([]);
  var _repository = Modular.get<ClientWalletRepository>();

  var codTecnoanjo = BehaviorSubject<String>.seeded("");

  get listClientWalletStream {
    return _listFaqInfo.stream;
  }

  Sink<ResponsePaginated> get setClientWalletValue {
    return _listFaqInfo.sink;
  }

  getListClientWallet({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      setClientWalletValue.add(null);
      _listTempClientWallet.clear();
    }
    var result = await _repository.getListClientWallet(page: page);
    var listTemp = List<ClientWallet>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<ClientWallet>(result.content));
    }
    _listTempClientWallet.addAll(listTemp);
    _listTempClientWallet = _listTempClientWallet.toSet().toList();
    if (page != 0) {
      result.content = (_listTempClientWallet);
    }

    await Future.delayed(
        Duration(milliseconds: 100), () => setClientWalletValue.add(result));
  }

  @override
  void dispose() {
    _listFaqInfo?.drain();
    codTecnoanjo?.drain();
    _listTempClientWallet.clear();
  }

  void saveCodClient(BuildContext context, String data) async {
    showLoading(true);

    var result = await _repository.saveCodClient(data);
    showLoading(false);
    if (result.error == null) {
      getListClientWallet();
    } else {
      showGenericDialog(context:context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  void removeTecno(
    BuildContext context,
    ClientWallet clientWallet,Function onSuccess
  ) async {
    showLoading(true);

    var result = await _repository.removeTecno(clientWallet);
    showLoading(false);
    if (result.error == null) {
      onSuccess();
      getListClientWallet();
    } else {
      showGenericDialog(context:context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }
}
