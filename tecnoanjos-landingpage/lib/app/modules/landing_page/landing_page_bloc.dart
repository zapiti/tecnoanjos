import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_bloc.dart';
import 'core/lading_page_repository.dart';

class LandingPageBloc extends Disposable {
  var currentFranquise ;
  var currentIndividual ;


  //dispose will be called automatically by closing its streams
  var _repository = Modular.get<LadingPageRepository>();

  var userNameValue = BehaviorSubject<String>();

  var showPass = BehaviorSubject<bool>.seeded(true);

  var passwordValue = BehaviorSubject<String>();

  Future<void> solicitateFranquise(BuildContext context) async {

  }

  Future<void> getAddressByCepFranquise(
      BuildContext context, String cep) async {

  }

  Future<void> getAddressByCepIndividual(
      BuildContext context, String cep) async {

  }

  Future<void> solicitateFranquiseIndividual(BuildContext context) async {

  }

  @override
  void dispose() {
    showPass.drain();
    userNameValue.drain();
    currentFranquise.drain();
    currentIndividual.drain();
    passwordValue.drain();
  }

  void login(BuildContext context) async {

  }
}
