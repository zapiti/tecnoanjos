import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';


import 'package:regexed_validator/regexed_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';

import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/login/models/auth/user_entity.dart';
import 'package:tecnoanjosclient/app/modules/general/login/repositories/auth_repository.dart';
import 'package:tecnoanjosclient/app/modules/general/login/utils/login/login_utils.dart';
import 'package:tecnoanjosclient/app/modules/general/login/utils/security_preference.dart';
import 'package:tecnoanjosclient/app/notification/onsignal_notification.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

class LoginBloc extends Disposable {
  static const FACEBOOK = "facebook";
  static const GOOGLE = "google";

  final phoneController = MaskedTextController(mask: Utils.getMaskPhone(""));
  final emailController = TextEditingController();

  final _savePass = BehaviorSubject<bool>();
  final _checkValue = BehaviorSubject<bool>();
  final isLoad = PublishSubject<bool>();
  final _appBloc = Modular.get<AppBloc>();
  var _loginRepository = Modular.get<AuthRepository>();
  var controllerUser = MaskedTextController(
    mask: Utils.getMaskPhone(""),
  );
  var controllerPass = TextEditingController();
  var strongPassPass = BehaviorSubject<int>.seeded(0);
  final showPass = BehaviorSubject<bool>.seeded(true);

  var controllerConfirmPass = TextEditingController();
  var tokenController = TextEditingController();

  var showFieldPass = BehaviorSubject<bool>.seeded(false);

  var isPassCode = BehaviorSubject<bool>.seeded(false);

  bool get getSavePassValue => _savePass.stream.value;

  Sink<bool> get setSavePassValue => _savePass.sink;

  get getCheckValue => _checkValue.stream;

  Sink<bool> get checkValue => _checkValue.sink;

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
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {
    isLoad.add(true);

    var username = Utils.removeMask(controllerUser.text);
    var password = controllerPass.text;
    var codeReponse =
        await _loginRepository.getLogin(username: username, password: password);
    isLoad.add(false);
    if (codeReponse.error != null) {
      Utils.showSnackBar('${codeReponse.error ?? ""}', context);
      if (codeReponse.status == 406) {
        isPassCode.sink.add(true);
      }
    } else {
      SecurityPreference.save(username: username, password: password);
      if (!kIsWeb) {
        OnsignalNotification().initPlatformState();
        OnsignalNotification().handleSetExternalUserId();
      }
      _goToHome();
    }
  }

  Future getLoginWithSocialMedia(
      BuildContext context, String type, String token) async {
    isLoad.add(true);

    var username = Utils.removeMask(controllerUser.text);
    var password = controllerPass.text;
    var codeReponse = await _loginRepository.getLoginWithSocialMedia(
        username: username, type: type, token: token);
    isLoad.add(false);
    if (codeReponse.error != null) {
      Utils.showSnackBar('${codeReponse.error ?? ""}', context);
      if (codeReponse.status == 406) {
        isPassCode.sink.add(true);
      }
    } else {
      SecurityPreference.save(username: username, password: password);
      if (!kIsWeb) {
        OnsignalNotification().initPlatformState();
        OnsignalNotification().handleSetExternalUserId();
      }
      _goToHome();
    }
  }

  Future getLogout({bool callLogout = true}) async {
    showLoading(true);
    _loginRepository.getLogout().then((value) {
      showLoading(false);
      _appBloc.getDefaultTheme();

      OnsignalNotification().handleRemoveExternalUserId();
      codePreferences.set(key: UserEntity.USERLOG, value: null);
      codePreferences.set(key: UserEntity.KID, value: null);
      codePreferences.set(key: UserEntity.REFRESH, value: null);
      codePreferences.clear();
      Modular.get<ProfileBloc>().userProfile.sink.add(null);
      Modular.get<ProfileBloc>().userInfos.sink.add(null);
      Modular.get<ProfileBloc>().userImage.sink.add(null);
      _appBloc.getDefaultTheme();
      _appBloc.setCurrent(null);
      _goToLogin();
    });
  }

  void _goToLogin() {
    Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
  }

  void _goToHome() {
    isPassCode.sink.add(false);
    Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
    // AttendanceUtils.goToHome(null);
  }

  void savePass(bool checked) {
    setSavePassValue.add(checked);
  }

  @override
  void dispose() {
    _savePass.drain();
    _savePass.close();

    showFieldPass.drain();
    strongPassPass.drain();
    _checkValue.drain();
    _checkValue.close();
    isPassCode.drain();
    isLoad.drain();
    isLoad.close();
    showPass.drain();
  }

  void goToChangeEmployer() {}

  void goToRecoverPass() {}

  void recoveryPass(BuildContext context, {bool isPhone}) async {
    var email = emailController.text;
    var phone = phoneController.text;
    if ((phone ?? "") == "" && (email ?? "") == "") {
      Utils.showSnackBar(StringFile.adicioneUmTelefoneEmail, context);
    } else if (!EmailValidator.validate(email ?? "") && (email ?? "") != "") {
      Utils.showSnackBar(StringFile.invalidEmail, context);
    } else {
      isLoad.sink.add(true);
      var result = isPhone == true
          ? await _loginRepository.recoveryPass(phone, "")
          : await _loginRepository.recoveryPass("", email);
      isLoad.sink.add(false);
      if (result.error == null) {
        showGenericDialog(
            context: context,
            title: StringFile.sucesso,
            description: isPhone
                ? StringFile.sucessoReverySms
                : StringFile.sucessoRevery,
            iconData: Icons.check_circle,
            positiveCallback: () {
              showFieldPass.sink.add(true);
            },
            positiveText: StringFile.OK);
      } else {
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    }
  }

  void recoveryPassMyPass(BuildContext context) async {
    if (tokenController.text == "") {
      Utils.showSnackBar(StringFile.adicioneTokenValor, context);
    } else if (controllerPass.text == "") {
      Utils.showSnackBar(StringFile.senhaNaoPodeSerVazia, context);
    } else if ((!Utils.hasDigits(controllerPass.text))) {
      Utils.showSnackBar(StringFile.adicioneNumerosAsenha, context);
    } else if ((!Utils.isCharacter(controllerPass.text))) {
      Utils.showSnackBar(StringFile.caracterEspecial, context);
    } else if ((!Utils.isUppercase(controllerPass.text))) {
      Utils.showSnackBar(StringFile.adicioneMaiusculoMinusculo, context);
    } else if ((!Utils.isMinLetter(controllerPass.text, 6))) {
      Utils.showSnackBar(StringFile.umaSenhaNoMinimo6, context);
    } else {
      var result = await _loginRepository.recoveryPassMyPass(
        tokenController.text,
        controllerPass.text,
      );

      if (result.error == null) {
        showFieldPass.sink.add(false);
        tokenController.clear();
        controllerPass.clear();

        showGenericDialog(
            context: context,
            title: StringFile.sucesso,
            description: StringFile.senhaAlterada,
            iconData: Icons.check_circle,
            positiveCallback: () {
              Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
            },
            positiveText: StringFile.OK);
      } else {
        showFieldPass.sink.add(false);
        tokenController.clear();
        controllerPass.clear();

        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    }
  }

  Future<bool> getLoginWithToken(BuildContext context, String pin) async {
    if (pin.length == 6) {
      isLoad.add(true);

      var username = Utils.removeMask(controllerUser.text);
      var password = controllerPass.text;
      var result = await _loginRepository.getLoginWithToken(username, password,
          pin: pin);
      isLoad.add(false);
      if (result.error != null) {
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      } else {
        SecurityPreference.save(username: username, password: password);
        if (!kIsWeb) {
          OnsignalNotification().initPlatformState();
          OnsignalNotification().handleSetExternalUserId();
        }
        _goToHome();
      }
      return false;
    } else {
      return true;
    }
  }

  updatePass(String pass, BuildContext context) {
    Utils.showMessagePass(pass, context);
    if (pass.length > 5 && !validator.mediumPassword(pass)) {
      strongPassPass.sink.add(1);
    } else if (validator.password(pass) && pass.length > 12) {
      strongPassPass.sink.add(4);
    } else if (validator.password(pass) && pass.length > 5) {
      strongPassPass.sink.add(3);
    } else if (validator.mediumPassword(pass)) {
      strongPassPass.sink.add(2);
    } else {
      strongPassPass.sink.add(0);
    }
  }

  void getFacebookLogin(BuildContext context) {
    LoginUtils.loginWithFaceBook().then((value) async {
      if (value == null) {
        Utils.showSnackBar("Não foi possível conectar-se ao facebook", context);
      } else {
        await getLoginWithSocialMedia(context, FACEBOOK, value.token);
      }
    });
  }

  void getLoginGoogle(BuildContext context) {
    LoginUtils.loginWithGoogle().then((value) async {
      if (value == null) {
        Utils.showSnackBar("Não foi possível conectar-se ao google", context);
      } else {
        await getLoginWithSocialMedia(context, GOOGLE, value.token);
      }
    });
  }
}
