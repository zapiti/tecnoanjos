import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/image/user_image_widget.dart';
import 'package:tecnoanjostec/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/profile/widget/registre/registre_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/recovery_pass/recovery_pass_page.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import '../profile_bloc.dart';

Widget profileBuilder(
    BuildContext context, Profile profile, ProfileBloc profileBloc,
    {Widget header}) {
  final _appBloc = Modular.get<AppBloc>();
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: UserImageWidget(height: 70, width: 70),
            margin: EdgeInsets.all(10),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  child: Text(
                    profile.name ?? "--",
                    style: AppThemeUtils.normalBoldSize(fontSize: 20),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                  child: Text(
                    profile?.level?.tag ?? "--",
                    style: AppThemeUtils.normalSize(),
                  )),
              // Container(
              //     margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //         Icon(
              //           Icons.star,
              //           color: Theme.of(context).primaryColor,
              //         ),
              //         Text(
              //           '${profile?.point} pontos',
              //           style: AppThemeUtils.normalSize(
              //               color: Theme.of(context).textTheme.bodyText2.color),
              //         )
              //       ],
              //     )),
              SizedBox(
                height: 10,
              ),
            ],
          ))
        ],
      ),
      header ?? SizedBox(),
      // lineViewWidget(),
      // titleDescriptionBigMobileWidget(
      //   context,
      //   customTitle: RichText(
      //       text: TextSpan(
      //     text: "Seu anjo: ",
      //     style: AppThemeUtils.normalSize(
      //         color: Theme.of(context).textTheme.bodyText2.color, fontSize: 18),
      //     children: <TextSpan>[
      //       TextSpan(
      //           text: profile?.level,
      //           style: AppThemeUtils.normalSize(
      //               color: Theme.of(context).primaryColor, fontSize: 18)),
      //     ],
      //   )),
      //   color: Theme.of(context).textTheme.bodyText1.color,
      //   title: '',
      //   description: profile?.levelInfo,
      // ),
      lineViewWidget(),
      Container(
        margin: EdgeInsets.all(10),
        child: StreamBuilder<CurrentUser>(
            stream: _appBloc.getCurrentUserFutureValue(),
            builder: (ctx, futureShot) => titleDescriptionMobileWidget(context,
                title: StringFile.suatag,
                isSelectable: true,
                description: futureShot.data?.tag?.toString() ?? "-")),
      ),
      lineViewWidget(top: 10),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        title: StringFile.telefone,
//        action: () {
//          profileBloc.editField(context, 'Adicione o Telefone',
//              cellPhone: profile?.cellPhone);
//        },
        iconData: MaterialCommunityIcons.phone,
        description: MaskedTextController(
                mask: Utils.getMaskPhone(profile.telephone ?? ""),
                text: profile.telephone ?? "")
            .text,
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        title: StringFile.email,
        iconData: MaterialCommunityIcons.email,
//        action: () {
//          profileBloc.editField(context, 'Adicione o Email',
//              email: profile?.email);
//        },
        description: profile?.email ?? "--",
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        // action: () {
        //   showAlterGender(context);
        //       },
        title: StringFile.genero,
        iconData: MaterialCommunityIcons.gender_male_female,
        description: profile?.gender ?? "--",
      ),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(context,
          color: Theme.of(context).textTheme.bodyText1.color,
          // action:() async {
          //   var date =
          //       await DialogDateTime.selectDate(
          //       context);
          //   if(date != null){
          //     var birthDate = MyDateUtils.converStringServer(date);
          //     profileBloc.editFieldProfile("birthDate",birthDate,context,(){});
          //   }
          //
          //       },
          title: StringFile.dataNasc,
          iconData: MaterialCommunityIcons.calendar,
          description: profile?.birthDate ?? "--"),
      lineViewWidget(),
      titleDescriptionBigMobileWidget(
        context,
        color: Theme.of(context).textTheme.bodyText1.color,
        // action: () {
        //   profileBloc.callAddCpf(context, () {});
        // },
        iconData: MaterialCommunityIcons.account_card_details,
        title: ((profile.cpf ?? "").length <= 11)
            ? StringFile.cpf
            : StringFile.cnpj,
        description: MaskedTextController(
                mask: Utils.cpfCnpj(profile.cpf ?? ""), text: profile.cpf ?? "")
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
          alterPass(context, registreBloc);
        },
        iconData: MaterialCommunityIcons.lock,
        title: "Alterar senha",
        description: "Crie uma senha nova",
      ),
      lineViewWidget(),
    ],
  );
}

void alterPass(BuildContext context, RegistreBloc registreBloc,{hasNegative = true, Function() onSuccess}) {
  showGenericDialog(
      context: context,
      title: "Altere sua senha",
      description: "",
      paddingCustom: EdgeInsets.all(0),
      customWidget: bodyElementAlterPass(registreBloc),
      iconData: Icons.edit,
      containsPop: false,
      positiveCallback: () {
        registreBloc.alterMyPass(context, () {
          if(onSuccess == null){
            Navigator.pop(context);
            Utils.showSnackBar("Senha alterada com sucesso", context);
          }else{
            onSuccess();
          }

        });
      },
      negativeText: StringFile.cancelar,
      negativeCallback:hasNegative ? () {
        Navigator.pop(context);
      }:null,
      positiveText: "alterar");
}

Future<void> showBottomSheetAlterPass(
    BuildContext context, RegistreBloc registreBloc,{hasNegative = true, Function() onSuccess}) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) => Column(mainAxisSize: MainAxisSize.min,children: [
      Container(
        margin: EdgeInsets.only(top: 10, right: 20, left: 20,bottom: 10),
        child: Text(
          "Altere sua senha pré cadastrada para uma de sua preferência",
          style: AppThemeUtils.normalBoldSize(
              fontSize: 20, color: AppThemeUtils.colorPrimary),
        ),
        padding: EdgeInsets.all(10),
      ),
      bodyElementAlterPass(registreBloc),
      Container(
          padding: EdgeInsets.all(15),
          child: ElevatedButton(
            onPressed: () {
              registreBloc.alterMyPass(context, () {
                if(onSuccess == null){
                  Navigator.pop(context);
                  Utils.showSnackBar("Senha alterada com sucesso", context);
                }else{
                  onSuccess();
                }

              });
            },
            style: ElevatedButton.styleFrom(
                primary: AppThemeUtils.colorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: AppThemeUtils.colorError))),
            child: Container(
                height: 45,
                child: Center(
                    child: Text(
                      "Concluir",
                      style: AppThemeUtils.normalSize(
                          color: AppThemeUtils.whiteColor),
                    ))),
          ))
    ],),
  );
}

Widget bodyElementAlterPass(RegistreBloc registreBloc) {
  return Column(
    children: [
      StreamBuilder<int>(
          stream: registreBloc.strongPassPass.stream,
          initialData: 0,
          builder:
              (BuildContext context, AsyncSnapshot<dynamic> snapshotStrong) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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
                              onChanged: (text) {},
                              onSubmitted: (term) {},
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
                        })),
                SizedBox(
                  height: 10,
                ),
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
                              onSubmitted: (term) {},
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
                    child: widgetLinePass(
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
                    onSubmitted: (term) {},
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
    ],
  );
}
