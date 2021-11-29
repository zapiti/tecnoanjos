import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tecnoanjos_franquia/app/app_bloc.dart';

import 'package:tecnoanjos_franquia/app/modules/login/models/auth/local_user.dart';
import 'package:tecnoanjos_franquia/app/modules/login/repositories/auth_repository.dart';

import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/preferences/local_storage.dart';

import 'package:tecnoanjos_franquia/app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc extends Disposable {
  final savePass = BehaviorSubject<bool>.seeded(true);

  final isLoad = PublishSubject<bool>();
  final localUserSubject = BehaviorSubject<LocalUser>();
  var _loginRepository = Modular.get<AuthRepository>();

  var showPass = BehaviorSubject<bool>.seeded(true);
  var loginUserController = TextEditingController();
  var loginPassController  = TextEditingController();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPhoneController = new MaskedTextController(mask: Utils.getMaskPhone(""));
  TextEditingController signupCpfController = new MaskedTextController(mask: Utils.cpfCnpj(""));
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();

  verifyAuth(BuildContext context, {bool devMode = false}) async {
    // StartBloc().getLayoutConfig(context).then((value) {
//    StartBloc.getEmployerSelected().then((employer) {
//      if (employer != null || devMode) {
//        LoginRepository.getTokenUser().then((token) {
//          StartBloc().getLayoutConfig(context).then((value) {
//            Future.delayed(Duration(seconds: 1), () {
//              if (token != null) {
//                _goToHome(context);
//              } else {
//                _goToLogin(context);
//              }
//            });
//          });
//        });
//      } else {
//        _goToChangeEmployer(context);
//      }
//    });
//    //});
  }

  Future getLogin(
      BuildContext context) async {
    isLoad.add(true);

    var username = loginUserController.text;
    var password = loginPassController.text;
    var codeReponse =
    await _loginRepository.getLogin(username: username, password: password);
    isLoad.add(false);
    if (codeReponse.error != null) {
      Utils.showSnackBar('${codeReponse.error ?? ""}', context);

    } else {

      _goToHome();
    }
  }

  Future getLogout() async {
    storage.clear().then((value) {
      Modular.get<AppBloc>().setCurrent(null);
      _loginRepository.getLogout();
    });


  }

  void _goToHome() async {
     Modular.to.pushReplacementNamed(ConstantsRoutes.HOME);
  }

  @override
  void dispose() {
    savePass.drain();
    savePass.close();
    isLoad.drain();
    isLoad.close();
    showPass.drain();
    localUserSubject.drain();
    showPass.close();
  }

  void goToChangeEmployer() {}

  void goToRecoverPass() {}






}
