import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/image/user_image_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/recovery_pass/recovery_pass_page.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import 'mobile/email_phone/alter_email.dart';

Widget profileBuilder(
    BuildContext context, Profile profile, ProfileBloc profileBloc) {
  var controllerProfile = MaskedTextController(
      mask: Utils.getMaskPhone(profile.telephone ?? ""),
      text: profile.telephone ?? "");
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: UserImageWidget(height: 100, width: 100),
            margin: EdgeInsets.all(10),
          ),

          SizedBox(
            height: 10,
          )
        ],
      ),

      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        title: StringFile.nome,
        // action: () {
        //
        //   profileBloc.editField(
        //     context,
        //     'Digite o seu nome:',
        //     inputFormatters: [
        //       LengthLimitingTextInputFormatter(50),
        //       FilteringTextInputFormatter.deny(RegExp("[0-9]"))
        //     ],
        //     nameUser: profile?.name,
        //   );
        // },
        iconData: MaterialCommunityIcons.account,
        description: TextEditingController(text: profile.name ?? "").text,
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        title: StringFile.telefone,
        action: () {
          AlterEmail.showAlterTelefone(context,profile?.telephone);
        },
        iconData: MaterialCommunityIcons.phone,
        description: controllerProfile.text,
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        title: StringFile.email,
        iconData: MaterialCommunityIcons.email,
       action: () {
         AlterEmail.showAlterEmail(context,profile?.email);
       },
        description: profile?.email ?? "--",
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        // action: () {
        //   showAlterGender(context);
        // },
        title: StringFile.sexo,
        iconData: MaterialCommunityIcons.gender_male_female,
        description: profile?.gender ?? "--",
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(context,
          color: Theme.of(context).textTheme.bodyText1.color,
      //     action: () async {
      //   DialogDateTime.selectDateNasc(context, (date) async {
      //     if (date != null) {
      //       var birthDate = await MyDateUtils.converStringServer(date,date);
      //       profileBloc.editFieldProfile(
      //           "birthDate", birthDate, context, () {});
      //     }
      //   });
      // },
          title: StringFile.dataNasc,
          iconData: MaterialCommunityIcons.calendar,
          description: profile?.birthDate ?? "--"),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        // action: () {
        //   profileBloc.callAddCpf(context, (value) {},defaultNumber: profile.cpf  );
        // },
        iconData: MaterialCommunityIcons.account_card_details,
        title: StringFile.cpf,
        description: MaskedTextController(
                mask: Utils.cpfCnpj(""), text: profile.cpf ?? "")
            .text,
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        action: () {
          var registreBloc = Modular.get<RegistreBloc>();
          registreBloc.controllerPassActualPass.clear();
          registreBloc.controllerConfirmPass.clear();
          registreBloc.controllerPassActualPass.clear();

          showGenericDialog(
              context: context,
              title: "Altere sua senha",
              description: "",paddingCustom:EdgeInsets.all(0),
              customWidget: _bodyElement(registreBloc),
              iconData: Icons.edit,
              containsPop: false,
              positiveCallback: () {

                registreBloc.alterMyPass(context,(){
                  Navigator.pop(context);
                  Utils.showSnackBar("Senha alterada com sucesso", context);
                });

              },
              negativeText: StringFile.cancelar,
              negativeCallback: () {
                Navigator.pop(context);
              },
              positiveText: StringFile.alterar);

        },
        iconData: MaterialCommunityIcons.lock,
        title: "Alterar senha",
        description: "Crie uma senha nova",
      ),
      lineViewWidget(),



    ],
  );


}

Widget _bodyElement( RegistreBloc registreBloc){
  return Column(children: [
    StreamBuilder<int>(
        stream: registreBloc.strongPassPass.stream,
        initialData: 0,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshotStrong) {
          return Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 0),
                  margin: EdgeInsets.only(bottom: 0),
                  child: StreamBuilder<bool>(
                      stream: registreBloc.showPassActual.stream,
                      initialData: true,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshotHide) {
                        return TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(24),
                            ],
                            obscureText: snapshotHide.data,
                            controller: registreBloc.controllerPassActualPass,
                            textAlign: TextAlign.start,

                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) {

                            },
                            onSubmitted: (term) {

                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                labelText: "Senha atual",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    snapshotHide.data
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppThemeUtils.colorPrimary,
                                  ),
                                  onPressed: () {
                                    registreBloc.showPassActual.sink
                                        .add(!snapshotHide.data);
                                  },
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.3),
                                )));
                      })),SizedBox(height: 10,),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.only(bottom: 0),
                  child: StreamBuilder<bool>(
                      stream: registreBloc.showPass.stream,
                      initialData: true,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshotHide) {
                        return TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(24),
                            ],
                            obscureText: snapshotHide.data,
                            controller: registreBloc.controllerPass,
                            textAlign: TextAlign.start,

                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) {
                              registreBloc.updatePass(text, context);
                            },
                            onSubmitted: (term) {

                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                labelText: "Nova senha",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    snapshotHide.data
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppThemeUtils.colorPrimary,
                                  ),
                                  onPressed: () {
                                    registreBloc.showPass.sink
                                        .add(!snapshotHide.data);
                                  },
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.3),
                                )));
                      })),
              SizedBox(
                height: 5,
              ),
              Container(
              padding: EdgeInsets.symmetric(horizontal: 12),

              child:    widgetLinePass(
                  snapshotStrong.data, registreBloc.controllerPass.text)),
              SizedBox(
                height: 10,
              )
            ],
          );
        }),
    Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: EdgeInsets.only(bottom: 0),
        child: StreamBuilder<bool>(
            stream: registreBloc.showPassConfirm.stream,
            initialData: true,
            builder: (BuildContext context,
                AsyncSnapshot<dynamic> snapshotShowHide2) {
              return TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(24),
                  ],
                  obscureText: snapshotShowHide2.data ?? true,
                  controller: registreBloc.controllerConfirmPass,
                  textAlign: TextAlign.start,

                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: (term) {

                  },
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      labelText: "Confirmar nova senha",
                      suffixIcon: IconButton(
                        icon: Icon(
                          snapshotShowHide2.data
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppThemeUtils.colorPrimary,
                        ),
                        onPressed: () {
                          registreBloc.showPassConfirm.sink
                              .add(!snapshotShowHide2.data);
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey, width: 0.3),
                      )));
            })),
  ],);
}
