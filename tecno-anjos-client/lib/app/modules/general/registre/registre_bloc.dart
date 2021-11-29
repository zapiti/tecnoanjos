import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:flutter_modular/flutter_modular.dart';

import 'package:regexed_validator/regexed_validator.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/modules/general/login/repositories/auth_repository.dart';
import 'package:tecnoanjosclient/app/modules/general/login/utils/security_preference.dart';

import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'package:tecnoanjosclient/app/utils/utils.dart';

import 'core/registre_user_repository.dart';

class RegistreBloc extends Disposable {


  final _repository = Modular.get<RegistreUserRepository>();
  var strongPassPass = BehaviorSubject<int>.seeded(0);
  var controllerTelefone = MaskedTextController(mask: Utils.getMaskPhone(""));
  var controllerEmail = TextEditingController();

  var controllerConfirmTelefone =
      MaskedTextController(mask: Utils.getMaskPhone(""));
  var phoneFocus = FocusNode();
  var emailFocus = FocusNode();

  // var controllerConfirmEmail = TextEditingController();
  var controllerConfirmPass = TextEditingController();
  var controllerPass = TextEditingController();
  var nameController = TextEditingController();
  var isPhoneValid = BehaviorSubject<bool>.seeded(false);

  var showPassConfirm = BehaviorSubject<bool>.seeded(true);

  var showPass = BehaviorSubject<bool>.seeded(true);

  var userTermAccept = BehaviorSubject<bool>.seeded(false);

  var pinController = TextEditingController();

  var pinFocus = FocusNode();

  var isEmailValid = BehaviorSubject<bool>.seeded(false);
  var typeSocialMedia = BehaviorSubject<String>();


  TextEditingController pinControllerPhone = TextEditingController();

  FocusNode pinFocusPhone = FocusNode();

  FocusNode pinFocusEmail = FocusNode();

  TextEditingController pinControllerEmail = TextEditingController();

  var errorEmail = BehaviorSubject<String>();
  var errorNumber = BehaviorSubject<String>();

  var enableButtonPhone = BehaviorSubject<bool>.seeded(false);
  var enableButtonEmail = BehaviorSubject<bool>.seeded(false);

  var isOptionPhone = BehaviorSubject<bool>.seeded(false);
  var isOptionEmail = BehaviorSubject<bool>.seeded(false);

  var optController = TextEditingController();
  var temController = TextEditingController();

  var showPassActual = BehaviorSubject<bool>.seeded(true);

  var controllerPassActualPass = TextEditingController();

  var controllerToken = TextEditingController();

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    typeSocialMedia.drain();
    showPassActual.drain();
    errorEmail.drain();
    enableButtonPhone.drain();
    isOptionEmail.drain();
    isOptionPhone.drain();
    enableButtonEmail.drain();
    errorNumber.drain();
    controllerTelefone.clear();
    controllerEmail.clear();
    userTermAccept.close();
    isEmailValid.close();
    controllerConfirmTelefone.clear();
    // controllerConfirmEmail.clear();
    strongPassPass.close();
    isPhoneValid.close();
    showPassConfirm.close();
    showPass.close();
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

  sendVerificationCod(BuildContext context, Function onSuccess,
      {bool isTypePhone = true}) async {
    showLoading(true);
    var codeReponse = isTypePhone
        ? await _repository.sendVerificationCod(
            telefone: controllerTelefone.text)
        : await _repository.sendVerificationCodEmail(
            email: controllerEmail.text, name: nameController.text);

    // var codeReponse =  await _repository.sendVerificationCod(
    //     telefone: controllerTelefone.text) ;
    showLoading(false);
    pinController.clear();

    if (codeReponse?.error != null) {
      showGenericDialog(
          context: context,
          title: "Ops!!!",
          description: "${codeReponse?.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {
            pinController.clear();
          },
          positiveText: StringFile.ok);
    } else {
      if (isTypePhone) {
        isOptionPhone.sink.add(true);
      } else {
        isOptionEmail.sink.add(true);
      }
      onSuccess();
      // SmsAutoFill().listenForCode.then((value) {
      //   print("codigo ");
      // });
      // showGenericDialog(
      //     context: context,
      //     title: "Sucesso",
      //     description: "Código enviado com sucesso.\nAguarde para digitá-lo",
      //     iconData: Icons.error_outline,
      //     positiveCallback: () {
      //       onSucess();
      //       SmsAutoFill().listenForCode.then((value) {
      //         print("codigo ");
      //       });
      //     },
      //     positiveText: StringFile.ok);
    }
  }

  sendVerifyCodExists(
      BuildContext context, TextEditingController controller, Function onSucess,
      {bool isTypePhone = true}) async {
    if (optController.text.length == 6 &&
        optController.text != temController.text) {
      var code = optController.text;
      temController.text = code;
      showLoading(true);
      var codeReponse = isTypePhone
          ? await _repository.sendVerifiCodExists(code, controllerTelefone.text)
          : await _repository.sendVerifiCodExistsEmail(
              code, controllerEmail.text);

      // var codeReponse =  await _repository.sendVerifiCodExists(code, controllerTelefone.text);
      showLoading(false);
      pinController.clear();
      optController.clear();
      temController.clear();
      controller.clear();
      if (codeReponse.error != null) {
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${codeReponse.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.ok);
      } else {
        if (isTypePhone) {
          onSucess();
          isPhoneValid.sink.add(true);
        } else {
          onSucess();
          isEmailValid.sink.add(true);
        }
      }
    }
  }

  Future<void> validateUser(
      BuildContext context, int index, Function onSucess) async {
    showLoading(true);
    List map = index == 0
        ? [
            {
              "field": 'name',
              "value": nameController.text,
              "role": "CLIENT",
            }
          ]
        : index == 1
            ? [
                {
                  "field": 'email',
                  "value": controllerEmail.text.replaceAll(" ", ""),
                  "role": "CLIENT",
                },
                {
                  "field": 'telephone',
                  "value": Utils.removeMask(controllerTelefone.text),
                  "role": "CLIENT",
                }
              ]
            : [
                {
                  "field": 'password',
                  "value": controllerPass.text,
                  "role": "CLIENT",
                }
              ];
    var body = {"content": map};
    var result = await _repository.validadeNewUser(body);

    showLoading(false);
    if (result?.content != null) {
      var isvalid = result.content['isValid'] ?? false;
      var message = result.content['message'] ?? "Sem mensagem de erro";
      if (isvalid) {
        onSucess();
      } else {
        Future.delayed(Duration(seconds: 1), () {
          FocusScope.of(context).requestFocus(FocusNode());
        });

        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: message,
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.ok);
      }
    } else {
      Future.delayed(Duration(seconds: 1), () {
        FocusScope.of(context).requestFocus(FocusNode());
      });
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result?.error ?? "Sem resposta"}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  Future<void> _registreUser(BuildContext context) async {
    showLoading(true);
    var body = {
      'name': nameController.text,
      'email': controllerEmail.text.replaceAll(" ", ""),
      'telephone': Utils.removeMask(controllerTelefone.text),
      'password': controllerPass.text,
      "role": "CLIENT",
    };
    if (controllerToken.text.isNotEmpty) {
      final loginRepository = AuthRepository();
      var result = await loginRepository.getLoginWithSocialMedia(
          username: Utils.removeMask(controllerTelefone.text),
          type: typeSocialMedia.stream.value,
          token: controllerToken.text);

      if (result.error == null) {
        showLoading(false);
        SecurityPreference.save(
            username: Utils.removeMask(controllerTelefone.text),
            password: controllerPass.text);
        controllerTelefone.clear();
        controllerEmail.clear();
        controllerConfirmTelefone.clear();
        Navigator.of(context).pop();
        AmplitudeUtil.createEvent(AmplitudeUtil.eventoSucessoAoCadastrar);
        Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
      } else {
        showLoading(false);
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.ok);
      }
    } else {
      var result = await _repository.createNewUser(body);

      if (result.error == null) {
        var auth = Modular.get<AuthRepository>();

        var codeReponse = await auth.getLogin(
            username: Utils.removeMask(controllerTelefone.text),
            password: controllerPass.text);
        showLoading(false);
        if (codeReponse.error != null) {
          AmplitudeUtil.createEvent(AmplitudeUtil.eventoFalhaAoCadastrar);
          showGenericDialog(
              context: context,
              title: StringFile.opps,
              description: "${codeReponse.error}",
              iconData: Icons.error_outline,
              positiveCallback: () {},
              positiveText: StringFile.ok);
        } else {
          showLoading(false);
          SecurityPreference.save(
              username: Utils.removeMask(controllerTelefone.text),
              password: controllerPass.text);
          controllerTelefone.clear();
          controllerEmail.clear();
          controllerConfirmTelefone.clear();
          Navigator.of(context).pop();
          AmplitudeUtil.createEvent(AmplitudeUtil.eventoSucessoAoCadastrar);
          Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);

          // AttendanceUtils.goToHome(context);
        }
      } else {
        showLoading(false);
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.ok);
      }
    }
  }

  changeAction(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());


    if ((nameController.text ?? "").length < 3) {
      Utils.showSnackBar(StringFile.nameMenos3Letras, context);
    }
    // else if (!isEmailValid.stream.value && index == 1) {
    //   Utils.showSnackBar(StringFile.validarEmailParaContinuar, context);
    // }
    else if (!isPhoneValid.stream.value) {
      Utils.showSnackBar(StringFile.validarTelefonePraContinuar, context);
    } else if (controllerEmail.text == "") {
      Utils.showSnackBar(StringFile.emailNaoPodeSerVazio, context);
    } else if (!EmailValidator.validate(controllerEmail.text) &&
        controllerEmail.text.isNotEmpty) {
      Utils.showSnackBar(StringFile.invalidEmail, context);
    } else if (userTermAccept.stream.value != true) {
      Utils.showSnackBar(StringFile.paraCadastrar, context);
    } else if (controllerToken.text.isEmpty) {
      if ((controllerPass.text ?? "1") != controllerConfirmPass.text) {
        Utils.showSnackBar(StringFile.senhasEstaoDiferente, context);
      } else if (controllerConfirmPass.text == "" &&
          controllerPass.text == "") {
        Utils.showSnackBar(StringFile.senhaNaoPodeSerVazia, context);
      } else if ((!Utils.hasDigits(controllerPass.text))) {
        Utils.showSnackBar(StringFile.adicioneNumerosAsenha, context);
      } else if ((!Utils.isCharacter(controllerPass.text))) {
        Utils.showSnackBar(
            StringFile.agoraDigiteSenhaCaracterEspecial, context);
      } else if ((!Utils.isUppercase(controllerPass.text))) {
        Utils.showSnackBar(StringFile.adicioneMaiusculoMinusculo, context);
      } else if ((!Utils.isMinLetter(controllerPass.text, 6))) {
        Utils.showSnackBar(StringFile.umaSenhaNoMinimo6, context);
      } else {
        if (userTermAccept.stream.value) {
          validateUser(context, 0, () {
            _registreUser(context);
          });
        } else {
          Utils.showSnackBar(StringFile.paraConcluirAceiteermo, context);
        }
      }
    } else {
      if (userTermAccept.stream.value) {
        validateUser(context, 0, () {
          _registreUser(context);
        });
      } else {
        Utils.showSnackBar(StringFile.paraConcluirAceiteermo, context);
      }
    }
  }

  void alterMyPass(BuildContext context, Function onSuccess) async {
    if (controllerPassActualPass.text.isEmpty) {
      Utils.showSnackBar("Senha atual não pode ser vazia", context);
    } else if ((controllerPass.text ?? "1") != controllerConfirmPass.text) {
      Utils.showSnackBar(StringFile.senhasEstaoDiferente, context);
    } else if (controllerConfirmPass.text == "" && controllerPass.text == "") {
      Utils.showSnackBar(StringFile.senhaNaoPodeSerVazia, context);
    } else if ((!Utils.hasDigits(controllerPass.text))) {
      Utils.showSnackBar(StringFile.adicioneNumerosAsenha, context);
    } else if ((!Utils.isCharacter(controllerPass.text))) {
      Utils.showSnackBar(StringFile.agoraDigiteSenhaCaracterEspecial, context);
    } else if ((!Utils.isUppercase(controllerPass.text))) {
      Utils.showSnackBar(StringFile.adicioneMaiusculoMinusculo, context);
    } else if ((!Utils.isMinLetter(controllerPass.text, 6))) {
      Utils.showSnackBar(StringFile.umaSenhaNoMinimo6, context);
    } else {
      final response = await _repository.alterMyPass(
          controllerPassActualPass.text, controllerConfirmPass.text);

      if (response.error != null) {
        showGenericDialog(
            context: context,
            title: StringFile.atencao,
            description: "${response.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      } else {
        controllerPassActualPass.clear();
        controllerConfirmPass.clear();
        controllerPassActualPass.clear();
        onSuccess();
      }
    }
  }
}
