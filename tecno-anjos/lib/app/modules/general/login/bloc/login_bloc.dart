import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/login/repositories/auth_repository.dart';
import 'package:tecnoanjostec/app/modules/general/login/utils/security_preference.dart';
import 'package:tecnoanjostec/app/notification/onsignal_notification.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

class LoginBloc extends Disposable {
  final _savePass = BehaviorSubject<bool>();
  final _checkValue = BehaviorSubject<bool>();
  final isLoad = BehaviorSubject<bool>();
  final _appBloc = Modular.get<AppBloc>();
  var _loginRepository = Modular.get<AuthRepository>();
  final showPass = BehaviorSubject<bool>.seeded(true);
  var controllerUser =
      MaskedTextController(mask: Utils.getMaskPhone(""), text: "");

  var controllerEmail = TextEditingController(text: "");

  var controllerPass = TextEditingController(text: "");
  var tokenController = TextEditingController();
  var showFieldPass = BehaviorSubject<bool>.seeded(false);
  var strongPassPass = BehaviorSubject<int>.seeded(0);
  var currentStatus = BehaviorSubject<int>.seeded(0);

  var isPassCode = BehaviorSubject<bool>.seeded(false);

  final phoneController = MaskedTextController(mask: Utils.getMaskPhone(""));
  final emailController = TextEditingController();

  bool get getSavePassValue => _savePass.stream.value;

  Sink<bool> get setSavePassValue => _savePass.sink;

  Stream<bool> get getCheckValue => _checkValue.stream;

  Sink<bool> get checkValue => _checkValue.sink;

  verifyAuth(BuildContext context, {bool devMode = false}) async {

  }

  Future getLogin(
      BuildContext context) async {
    //var no sucesso

    isLoad.add(true);

    var username = Utils.removeMask(controllerUser.text)?.trim();
    var password = controllerPass.text;
    var codeReponse =
        await _loginRepository.getLogin(username: username, password: password);

    if (codeReponse.error != null) {
      isLoad.add(false);
      showGenericDialog(
          context: context,
          title: "Atenção!",
          description: "${codeReponse.error}",
          iconData: Icons.person_sharp,
          positiveCallback: () {
            if (codeReponse.status == 406) {
              currentStatus.sink.add(406);
              isPassCode.sink.add(true);
            }
          },
          positiveText: StringFile.OK);
    } else {
      if (currentStatus.stream.value != 406) {
        var profileBloc = Modular.get<ProfileBloc>();

        var responseProfile = await profileBloc.getDataOnly();
        isLoad.add(false);
        if (responseProfile == null) {
        } else if ((responseProfile?.isFirstLogin ?? false)) {
          profileBloc.requestTokenSms(context, username, onSuccess: () {
            isPassCode.sink.add(true);
          });
        } else {
          await setTokenUser(_appBloc.currentToken.stream.value);

          SecurityPreference.save(username: username, password: password);
          if (!kIsWeb) {
            OnsignalNotification().initPlatformState();
            OnsignalNotification().handleSetExternalUserId();
          }
          _goToHome();
        }
      } else {
        currentStatus.sink.add(406);
        isPassCode.sink.add(true);
      }
    }
  }

  Future setTokenUser(String token) async {
    if (token != null) {
      await codePreferences.set(key: CurrentUser.KID, value: token);
    }
  }

  Future getLogout() async {
    print("Logout ==========");
      _loginRepository.getLogout().then((value) {

        OnsignalNotification().handleRemoveExternalUserId();
        codePreferences.set(key: CurrentUser.USERLOG, value: null);
        codePreferences.set(key: CurrentUser.KID, value: null);
        codePreferences.set(key: CurrentUser.REFRESH, value: null);
        codePreferences.clear();
        Modular.get<ProfileBloc>().userProfile.sink.add(null);
        Modular.get<ProfileBloc>().userInfos.sink.add(null);
        Modular.get<ProfileBloc>().userImage.sink.add(null);
        _appBloc.getDefaultTheme();
        _appBloc.setCurrent(null);
        _appBloc.isFirstLogin.sink.add(true);
        _goToLogin();
      });

  }



  void _goToLogin() {
    Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
  }

  void _goToHome() {
    isPassCode.sink.add(false);
    Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
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
    isLoad.drain();
    isLoad.close();
    isPassCode.drain();
    currentStatus.drain();
    showPass.drain();
  }

  void goToChangeEmployer() {}

  void goToRecoverPass() {}

  void recoveryPass(BuildContext context,
      {bool isPhone}) async {
    var email = emailController.text;
    var phone = phoneController.text;
    if ((phone ?? "") == "" && (email ?? "") == "") {
      Utils.showSnackBar(StringFile.adicioneUmTelefoneEmail, context);
    } else if (Validator.phone(phone ?? "") && (phone ?? "") != "") {
      Utils.showSnackBar(StringFile.invalidPhone, context);
    } else if (Validator.email(email ?? "") && (email ?? "") != "") {
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
            title: StringFile.atencao,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    }
  }

  void recoveryPassMyPass(
      BuildContext context) async {
    if (tokenController.text == "") {
      Utils.showSnackBar("Adicione um token válido.", context);
    } else if ((!Utils.hasDigits(controllerPass.text))) {
      Utils.showSnackBar("Adicione números a sua senha.", context);
    } else if ((!Utils.isCharacter(controllerPass.text))) {
      Utils.showSnackBar(
          "Adicione caracteres especial a sua senha (\$@%).", context);
    } else if ((!Utils.isUppercase(controllerPass.text))) {
      Utils.showSnackBar("Adicione letra maiúscula.", context);
    } else if ((!Utils.isMinLetter(controllerPass.text, 6))) {
      Utils.showSnackBar(
          "Adicione uma senha de no mínimo 6 caracteres.", context);
    } else {
      isLoad.add(true);
      var result = await _loginRepository.recoveryPassMyPass(
        tokenController.text,
        controllerPass.text,
      );
      isLoad.add(false);
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
            title: StringFile.Erro,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {

            },
            positiveText: StringFile.OK);
      }
    }
  }

  Future<bool> getLoginWithToken(BuildContext context, String pin) async {
    var profileBloc = Modular.get<  ProfileBloc>();

    if (pin.length == 6 && isLoad.stream.value == false) {
      isLoad.add(true);
      var username = Utils.removeMask(controllerUser.text)?.trim();
      var password = controllerPass.text;
      if (currentStatus.stream.value != 406) {
        var responseProfile = await profileBloc.getDataOnly();
        isLoad.add(false);
        if (responseProfile == null) {
          isLoad.add(false);
          showGenericDialog(
              context: context,
              title: StringFile.ops,
              description: "Falha ao autenticar token",
              iconData: Icons.error_outline,
              positiveCallback: () {
                //   _loginRepository.getLogout().then((value) {});
              },
              positiveText: "OK");

          return false;
        } else {
          if ((responseProfile?.isFirstLogin ?? false)) {
            showLoading(true);
            var codeReponse =
                await profileBloc.sendVerifiCodExists(pin, username);
            showLoading(false);
            isLoad.add(false);
            if (codeReponse.error != null) {
              isLoad.add(false);
              showGenericDialog(
                  context: context,
                  title: StringFile.ops,
                  description: "${codeReponse.error}",
                  iconData: Icons.error_outline,
                  positiveCallback: () {
                    //_loginRepository.getLogout().then((value) {});
                  },
                  positiveText: "OK");
              return false;
            } else {
              isLoad.add(false);
              isPassCode.sink.add(false);
              setTokenUser(_appBloc.currentToken.stream.value);
              SecurityPreference.save(username: username, password: password);
              if (!kIsWeb) {
                OnsignalNotification().initPlatformState();
                OnsignalNotification().handleSetExternalUserId();
              }
              _goToHome();
            }
          } else {
            isLoad.add(true);

            var username = Utils.removeMask(controllerUser.text)?.trim();
            var password = controllerPass.text;
            var result = await _loginRepository
                .getLoginWithToken(username, password, pin: pin);
            isLoad.add(false);
            if (result.error != null) {
              isLoad.add(false);
              showGenericDialog(
                  context: context,
                  title: StringFile.Erro,
                  description: "${result.error}",
                  iconData: Icons.error_outline,
                  positiveCallback: () {},
                  positiveText: StringFile.OK);
            } else {
              isLoad.add(false);
              setTokenUser(_appBloc.currentToken.stream.value);
              SecurityPreference.save(username: username, password: password);
              if (!kIsWeb) {
                OnsignalNotification().initPlatformState();
                OnsignalNotification().handleSetExternalUserId();
              }
              _goToHome();
            }
            return false;
          }
        }
      } else {
        isLoad.add(true);

        var username = Utils.removeMask(controllerUser.text)?.trim();
        var password = controllerPass.text;
        var result = await _loginRepository
            .getLoginWithToken(username, password, pin: pin);
        isLoad.add(false);
        if (result.error != null) {
          isLoad.add(false);
          showGenericDialog(
              context: context,
              title: StringFile.Erro,
              description: "${result.error}",
              iconData: Icons.error_outline,
              positiveCallback: () {},
              positiveText: StringFile.OK);
        } else {
          isLoad.add(false);
          setTokenUser(_appBloc.currentToken.stream.value);
          SecurityPreference.save(username: username, password: password);
          if (!kIsWeb) {
            OnsignalNotification().initPlatformState();
            OnsignalNotification().handleSetExternalUserId();
          }
          _goToHome();
        }
        return false;
      }
    } else {    return false;}
    return false;
  }

  updatePass(String pass) {
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
}

