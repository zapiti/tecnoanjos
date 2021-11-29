
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/core/registre_user_repository.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

class RegistreBloc extends Disposable {
  final _repository = RegistreUserRepository();
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

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
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


  void alterMyPass(BuildContext context,Function onSuccess) async{
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
      final response = await _repository.alterMyPass(controllerPassActualPass.text,controllerConfirmPass.text);

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
