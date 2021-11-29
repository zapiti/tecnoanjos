import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/field/field_email_cod_confirm.dart';
import 'package:tecnoanjosclient/app/components/field/field_phone_cod_confirm.dart';
import 'package:tecnoanjosclient/app/modules/general/login/bloc/login_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/login/utils/login/login_utils.dart';
import 'package:tecnoanjosclient/app/modules/general/recovery_pass/recovery_pass_page.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/page/user_term.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../../registre_bloc.dart';

class ChangeNameRegistrePage extends StatefulWidget {
  @override
  _ChangeNameRegistrePageState createState() => _ChangeNameRegistrePageState();
}

class _ChangeNameRegistrePageState extends State<ChangeNameRegistrePage> {
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: AppThemeUtils.colorPrimary,
    borderRadius: BorderRadius.circular(20.0),
  );

  var _passFocus = FocusNode();

  var _confirmPassFocus = FocusNode();
  var registreBloc = Modular.get<RegistreBloc>();
  var acessToken;
  var currentEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmplitudeUtil.createEvent(AmplitudeUtil.eventoCadastroDeUsuario(3));
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            StringFile.bemvindoATecnoANjo,
            style: AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
        ),
        body: WillPopScope(
            onWillPop: () async {
              registreBloc.controllerTelefone.clear();
              registreBloc.controllerEmail.clear();
              registreBloc.controllerConfirmTelefone.clear();
              registreBloc.controllerEmail.clear();
              //    registreBloc.tempRegisterUser.sink.add(RegistreUser());
              return true;
            },
            child: Material(
                child: Container(
                    color: Colors.white,
                    child: Form(
                        child: Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(children: <Widget>[
                        // imageWithBgWidget(context, ImagePath.imagePeople),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 10, bottom: 0),
                            child: Text(
                              StringFile.aquiVoceCadastra,
                              textAlign: TextAlign.left,
                              style: AppThemeUtils.normalSize(
                                  fontSize: 14,
                                  color: AppThemeUtils.colorPrimary),
                            )),
                        StreamBuilder<String>(
                            stream: registreBloc.typeSocialMedia,
                            builder: (context, snapshot) => snapshot.data !=
                                    null
                                ? SizedBox()
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(
                                        right: 20,
                                        left: 20,
                                        top: 10,
                                        bottom: 0),
                                    child: Text(
                                      "Quer usar suas redes sociais?",
                                      textAlign: TextAlign.left,
                                      style: AppThemeUtils.normalSize(
                                          fontSize: 12),
                                    ))),
                        Container(
                            width: MediaQuery.of(context).size.width,

                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 0, bottom: 0),
                            child: StreamBuilder<String>(
                                stream: registreBloc.typeSocialMedia,
                                builder: (context, snapshot) => snapshot.data !=
                                        null
                                    ? Row(children: [
                                        Expanded(
                                            child: Container(
                                                child: Text(
                                                  "Você esta cadastrando com ${snapshot.data}",
                                                  style:
                                                      AppThemeUtils.normalSize(
                                                          color: AppThemeUtils
                                                              .colorPrimary,
                                                          fontSize: 14),
                                                ),
                                                margin:
                                                    EdgeInsets.symmetric())),
                                        Container(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  registreBloc
                                                      .typeSocialMedia.sink
                                                      .add(null);
                                                  registreBloc.controllerToken
                                                      .text = "";
                                                  setState(() {
                                                    acessToken = null;
                                                    currentEmail = null;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: AppThemeUtils
                                                        .colorError),
                                                child: Text("Sair")),
                                            margin: EdgeInsets.symmetric())
                                      ])
                                    : Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppThemeUtils
                                                      .colorFacebook,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  )),
                                              onPressed: () async {
                                                LoginUtils.loginWithFaceBook()
                                                    .then((value) {
                                                  if (value != null) {
                                                    registreBloc.nameController
                                                        .text = value.name;
                                                    registreBloc.controllerEmail
                                                        .text = value.email;
                                                    registreBloc
                                                        .controllerTelefone
                                                        .text = value.telephone;
                                                    registreBloc.controllerToken
                                                        .text = value.token;
                                                    registreBloc
                                                        .typeSocialMedia.sink
                                                        .add(
                                                            LoginBloc.FACEBOOK);

                                                    setState(() {
                                                      if ((value.email ?? "")
                                                          .isNotEmpty) {
                                                        currentEmail =
                                                            (value.email ?? "");
                                                      }
                                                      acessToken = value.token;
                                                    });
                                                  }
                                                });
                                              },
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        5),
                                                    child: Icon(
                                                        MaterialCommunityIcons
                                                            .facebook),
                                                  ),
                                                  // Container(
                                                  //     alignment: Alignment.center,
                                                  //     margin: EdgeInsets
                                                  //         .symmetric(
                                                  //         horizontal:
                                                  //         5),
                                                  //     child: AutoSizeText(
                                                  //       "Facebook",
                                                  //       minFontSize: 8,maxLines: 1,textAlign: TextAlign.center,
                                                  //       style: TextStyle(
                                                  //           color:
                                                  //           Colors.white,
                                                  //           fontSize: 16),
                                                  //     ))
                                                ],
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: Container(
                                            height: 40,
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary:
                                                      AppThemeUtils.colorGoogle,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  )),
                                              onPressed: () {
                                                LoginUtils.loginWithGoogle()
                                                    .then((value) {
                                                  if (value != null) {
                                                    registreBloc.nameController
                                                        .text = value.name;
                                                    registreBloc.controllerEmail
                                                        .text = value.email;
                                                    registreBloc.controllerToken
                                                        .text = value.token;
                                                    registreBloc
                                                        .typeSocialMedia.sink
                                                        .add(LoginBloc.GOOGLE);
                                                    setState(() {
                                                      if ((value.email ?? "")
                                                          .isNotEmpty) {
                                                        currentEmail =
                                                            (value.email ?? "");
                                                      }

                                                      acessToken = value.token;
                                                    });
                                                  }
                                                });
                                              },
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                              child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Icon(
                                                        MaterialCommunityIcons
                                                            .google),
                                                  ),
                                                  // Expanded(
                                                  //     child: Container(
                                                  //         margin: EdgeInsets
                                                  //             .symmetric(
                                                  //                 horizontal:
                                                  //                     5),
                                                  //         child: AutoSizeText(
                                                  //           "Google",
                                                  //           minFontSize: 8,maxLines: 1,
                                                  //           style: TextStyle(
                                                  //               color: Colors
                                                  //                   .white,
                                                  //               fontSize: 16),
                                                  //         )))
                                                ],
                                              ),
                                            ),
                                          )),
                                        ],
                                      ))),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 10, bottom: 0),
                            child: Text(
                              "Qual é o seu nome?",
                              textAlign: TextAlign.left,
                              style: AppThemeUtils.normalSize(fontSize: 12),
                            )),

                        // Container(
                        //     margin: EdgeInsets.only(right: 10, left: 10, top: 10),
                        //     child: Text(
                        //       "Como posso chamar você?",
                        //       textAlign: TextAlign.center,
                        //       style: AppThemeUtils.normalBoldSize(
                        //           color: AppThemeUtils.black, fontSize: 18),
                        //     )),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: TextField(
                              onChanged: (text) {},
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                                FilteringTextInputFormatter.deny(
                                    RegExp("[0-9]"))
                              ],
                              autofocus: false,
                              onSubmitted: (term) {},
                              controller: registreBloc.nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.3),
                                  ),
                                  hintText: StringFile.nomeCompleto,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.3),
                                  ),
                                  fillColor: Colors.grey[300]),
                              style: AppThemeUtils.normalSize(
                                  color: AppThemeUtils.black, fontSize: 18),
                            )),

                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 10, bottom: 0),
                            child: Text(
                              "Qual é o seu telefone?",
                              textAlign: TextAlign.left,
                              style: AppThemeUtils.normalSize(fontSize: 12),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 5, bottom: 5),
                            child: FieldPhoneCodConfirm(
                              textInputAction: TextInputAction.next,
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 10, bottom: 0),
                            child: Text(
                              "Qual é seu E-mail principal?",
                              textAlign: TextAlign.left,
                              style: AppThemeUtils.normalSize(fontSize: 12),
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: FieldEmailCodConfirm(
                              onNext: () {},
                              hideValidate: true,
                              textInputAction: TextInputAction.next,
                              enable: currentEmail == null,
                              onEditingComplete: () {
                                _passFocus.requestFocus();
                                //  node.nextFocus();
                              },
                            )),
                        acessToken != null
                            ? SizedBox()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    right: 20, left: 20, top: 10, bottom: 5),
                                child: Text(
                                  StringFile.agoraDigiteSenha6Digito,
                                  textAlign: TextAlign.left,
                                  style: AppThemeUtils.normalSize(fontSize: 12),
                                )),

                        acessToken != null
                            ? SizedBox()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    right: 20, left: 20, top: 0, bottom: 0),
                                child: StreamBuilder<int>(
                                    stream: registreBloc.strongPassPass.stream,
                                    initialData: 0,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshotStrong) {
                                      return Column(
                                        children: [
                                          Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 0),
                                              child: StreamBuilder<bool>(
                                                  stream: registreBloc
                                                      .showPass.stream,
                                                  initialData: true,
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshotHide) {
                                                    return TextField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        onEditingComplete: () =>
                                                            node.nextFocus(),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              24),
                                                        ],
                                                        obscureText:
                                                            snapshotHide.data,
                                                        controller: registreBloc
                                                            .controllerPass,
                                                        textAlign:
                                                            TextAlign.start,
                                                        focusNode: _passFocus,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        onChanged: (text) {
                                                          registreBloc
                                                              .updatePass(text,
                                                                  context);
                                                        },
                                                        onSubmitted: (term) {
                                                          Utils.fieldFocusChange(
                                                              context,
                                                              _passFocus,
                                                              _confirmPassFocus);
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            5),
                                                                labelText:
                                                                    StringFile
                                                                        .senha,
                                                                suffixIcon:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    snapshotHide
                                                                            .data
                                                                        ? Icons
                                                                            .visibility
                                                                        : Icons
                                                                            .visibility_off,
                                                                    color: AppThemeUtils
                                                                        .colorPrimary,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    registreBloc
                                                                        .showPass
                                                                        .sink
                                                                        .add(!snapshotHide
                                                                            .data);
                                                                  },
                                                                ),
                                                                border:
                                                                    const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          0.3),
                                                                )));
                                                  })),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          widgetLinePass(snapshotStrong.data,
                                              registreBloc.controllerPass.text),
                                        ],
                                      );
                                    })),
                        acessToken != null
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.only(
                                    right: 20, left: 20, top: 10, bottom: 0),
                                child: StreamBuilder<bool>(
                                    stream: registreBloc.showPassConfirm.stream,
                                    initialData: true,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic>
                                            snapshotShowHide2) {
                                      return TextField(
                                          textInputAction: TextInputAction.next,
                                          onEditingComplete: () =>
                                              node.unfocus(),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                24),
                                          ],
                                          obscureText:
                                              snapshotShowHide2.data ?? true,
                                          controller: registreBloc
                                              .controllerConfirmPass,
                                          textAlign: TextAlign.start,
                                          focusNode: _confirmPassFocus,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          onSubmitted: (term) {
                                            _confirmPassFocus.unfocus();
                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                              labelText: StringFile.confirmPass,
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  snapshotShowHide2.data
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: AppThemeUtils
                                                      .colorPrimary,
                                                ),
                                                onPressed: () {
                                                  registreBloc
                                                      .showPassConfirm.sink
                                                      .add(!snapshotShowHide2
                                                          .data);
                                                },
                                              ),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.3),
                                              )));
                                    })),
                        StreamBuilder<bool>(
                            stream: registreBloc.userTermAccept.stream,
                            initialData: false,
                            builder: (context, snapshot) => Container(
                                  padding: EdgeInsets.only(
                                      right: 12, left: 12, top: 12, bottom: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          width: 50,
                                          height: 45,
                                          margin: EdgeInsets.only(right: 0),
                                          child: Checkbox(
                                            value: snapshot.data,
                                            hoverColor:
                                                AppThemeUtils.colorPrimary,
                                            focusColor:
                                                AppThemeUtils.colorPrimary,
                                            activeColor: Colors.grey[300],
                                            checkColor:
                                                AppThemeUtils.colorPrimary,
                                            onChanged: (bool) => registreBloc
                                                .userTermAccept
                                                .add(bool),
                                          )),
                                      Expanded(
                                        child:
                                            // ElevatedButton(
                                            //   padding: EdgeInsets.symmetric(vertical: 5),
                                            //         onPressed: () {
                                            //           goToTerm(context).then((value) {
                                            //             registreBloc.userTermAccept.add(value ?? false);
                                            //             if (value == true) {
                                            //               registreBloc. changeAction(context, 3,null,(){
                                            //
                                            //               });
                                            //             }
                                            //           });
                                            //         },
                                            //         child:
                                            RichText(
                                                textAlign: TextAlign.start,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  text: StringFile.leEConcordo,
                                                  style:
                                                      AppThemeUtils.normalSize(
                                                          color:
                                                              Colors.grey[700],
                                                          fontSize: 18),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: StringFile
                                                            .termoDeUso,
                                                        style: AppThemeUtils.normalSize(
                                                            color: AppThemeUtils
                                                                .colorPrimary,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 18),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                goToTerm(
                                                                        StringFile
                                                                            .termoDeUso,
                                                                        context)
                                                                    .then(
                                                                        (value) {
                                                                  registreBloc
                                                                      .userTermAccept
                                                                      .add(value ??
                                                                          false);
                                                                  if (value ==
                                                                      true) {
                                                                    registreBloc
                                                                        .changeAction(
                                                                      context,
                                                                    );
                                                                  }
                                                                });
                                                              }),
                                                    TextSpan(
                                                        text: ' e ',
                                                        style: AppThemeUtils
                                                            .normalSize(
                                                                color: Colors
                                                                    .grey[700],
                                                                fontSize: 18)),
                                                    TextSpan(
                                                        text: StringFile
                                                            .politicaDePrivacidade,
                                                        style: AppThemeUtils.normalSize(
                                                            color: AppThemeUtils
                                                                .colorPrimary,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 18),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                goToTerm(
                                                                        StringFile
                                                                            .politicaDePrivacidade,
                                                                        context)
                                                                    .then(
                                                                        (value) {
                                                                  registreBloc
                                                                      .userTermAccept
                                                                      .add(value ??
                                                                          false);
                                                                  if (value ==
                                                                      true) {
                                                                    registreBloc
                                                                        .changeAction(
                                                                      context,
                                                                    );
                                                                  }
                                                                });
                                                              }),
                                                  ],
                                                )),
                                      )
                                      //)
                                    ],
                                  ),
                                )),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 40, top: 20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                ),
                                onPressed: () {
                                  registreBloc.changeAction(
                                    context,
                                  );
                                },
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                child: Text(
                                  "CADASTRAR",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ))),
                      ]))),
                    ]))))));
  }
}
