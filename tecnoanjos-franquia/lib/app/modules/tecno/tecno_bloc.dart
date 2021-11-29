import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjos_franquia/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjos_franquia/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjos_franquia/app/models/myaddress.dart';
import 'package:tecnoanjos_franquia/app/models/page/response_paginated.dart';
import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';
import 'package:tecnoanjos_franquia/app/utils/object/object_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';

import 'core/tecno_repository.dart';

class TecnoBloc extends Disposable {
  final listMyFuncionarySubject = BehaviorSubject<List<Profile>>();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final listAddress = BehaviorSubject<List<Pairs>>.seeded([]);

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    listAddress.drain();
    listMyFuncionarySubject.drain();
  }

  var _repository = TecnoRepository();

  getListMyFunctionary() async {
    listMyFuncionarySubject.sink.add(null);
    var response = await _repository.getListMyFunctionary();

    listMyFuncionarySubject.sink
        .add(ObjectUtils.parseToObjectList<Profile>(response.content ?? []));
  }

  void createOrUpdateTecno(BuildContext context, Profile tempLocalProduct) {}

  void save(BuildContext context, bool bool, Profile users) {
    var error;

    if (users.name.isEmpty) {
      error = ("Nome não pode ser vazio");
    } else if (users.email.isEmpty) {
      error = ("E-mail não pode ser vazio");
    } else if (Validator.email(users.email)) {
      error = ("E-mail está com formato inválido");
    }
    // else if (passController.text.isEmpty && users.id == null) {
    //   error = ("Senha não pode ser vazia");
    // } else if (confirmPassController.text != passController.text &&
    //     users.id == null) {
    //   error = ("Senha não podem ser diferentes");
    // }
    else if (users.telephone.isEmpty) {
      error = ("Telefone não pode ser vazio");
    } else if (users.gender.isEmpty) {
      error = ("Genero não pode ser vazio");
    } else if (users.birthDate.isEmpty) {
      error = ("Data de nascimento não pode ser vazio");
    } else if (Utils.isValidDate(users.birthDate)) {
      error = ("Data de nascimento inválida");
    }

    final mlistAddress = listAddress.stream.value;
    if (mlistAddress.isNotEmpty) {
      users.address = mlistAddress
          .map<MyAddress>((e) => MyAddress(name: e.second, state: MyState(name:  e.third))).toList();
    } else {
      users.address = null;
    }

    showLoadingDialog(true);

    if (error != null) {
      showLoadingDialog(false);
      showGenericDialog(context,
          iconData: Icons.warning,
          title: "Erro ao criar usuário",
          description: error,
          positiveCallback: () {},
          positiveText: "OK");
    } else {
      _repository.createOrUpdate(users).then((value) {
        showLoadingDialog(false);
        if (value.error != null) {
          showGenericDialog(context,
              iconData: Icons.warning,
              title: "Erro ao criar",
              description: value.error,
              positiveCallback: () {},
              positiveText: "OK");

          return;
        }
        showLoadingDialog(false);

        showGenericDialog(context,
            iconData: Icons.check_circle,
            title: "Oba!",
            description: users.id != null
                ? "Usuario editado com sucesso"
                : "Usuario criado com sucesso", positiveCallback: () {
          getListMyFunctionary();
          Modular.to.pop();
        }, positiveText: "OK");

        return;
      });
    }
  }

  Future<ResponsePaginated> getListAvaliableAddress() {
    return _repository.getListAvaliableAddress();
  }

  void blockedFunctionary(BuildContext context, {String status, Profile profile}) {
    _repository.blockedFunctionary(status:status,profile: profile).then((value) {
      showLoadingDialog(false);
      if (value.error != null) {
        showGenericDialog(context,
            iconData: Icons.warning,
            title: "Erro ao criar",
            description: value.error,
            positiveCallback: () {},
            positiveText: "OK");

        return;
      }
      showLoadingDialog(false);

      getListMyFunctionary();
    });
  }
}
