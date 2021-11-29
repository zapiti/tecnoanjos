
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/field/field_email_cod_confirm.dart';
import 'package:tecnoanjosclient/app/components/field/field_phone_cod_confirm.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';
import '../../../profile_bloc.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

class AlterEmail {
  static showAlterEmail(BuildContext context, String email) {
    var registreBloc = Modular.get<RegistreBloc>();
    var profileBloc = Modular.get<ProfileBloc>();
    registreBloc.controllerEmail.text = email;
    showGenericDialog(
        context: context,
        title: "Alterar E-mail",
        description: "",paddingCustom:EdgeInsets.all(0),
        customWidget: Container(

            child: FieldEmailCodConfirm(isVertical: true)),
        iconData: Icons.edit,
        containsPop: false,
        positiveCallback: () {
          if (registreBloc.controllerEmail.text.isEmpty) {
            registreBloc.errorEmail.sink.add("Adicione um email");
          } else if (!registreBloc.isEmailValid.stream.value) {
            registreBloc.errorEmail.sink.add("Valide para continuar");
          } else {
            profileBloc.editFieldProfile(
                'email', registreBloc.controllerEmail.text, context, () {
              profileBloc.getUserData(ignoreCash: true);
              Navigator.pop(context);
            });
          }
        },
        negativeText: StringFile.cancelar,
        negativeCallback: () {
          Navigator.pop(context);
        },
        positiveText: StringFile.alterar);
  }

  static showAlterTelefone(BuildContext context, String phone) {
    var registreBloc = Modular.get<RegistreBloc>();
    var profileBloc = Modular.get<ProfileBloc>();
    registreBloc.controllerTelefone.text = phone;
    showGenericDialog(
        context: context,
        title: "Alterar Telefone",
        description: "",
        customWidget: Container(child: FieldPhoneCodConfirm(isVertical: true)),
        iconData: Icons.edit,
        containsPop: false,
        positiveCallback: () async {
          if (registreBloc.controllerTelefone.text.isEmpty) {
            registreBloc.errorNumber.sink.add("Adicione um telefone");
          } else if (!registreBloc.isPhoneValid.stream.value) {
            registreBloc.errorNumber.sink.add("Valide para continuar");
          } else {

            profileBloc.editFieldProfile(
                'telephone', Utils.removeMask(registreBloc.controllerTelefone.text) , context, () {
              profileBloc.getUserData(ignoreCash: true);
              Navigator.pop(context);
            });
          }
        },
        negativeText: StringFile.cancelar,
        negativeCallback: () {
          Navigator.pop(context);
        },
        positiveText: StringFile.alterar);
  }


}
