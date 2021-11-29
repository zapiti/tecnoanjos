import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/page/user_term.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import '../../registre_bloc.dart';

var _confirmPassFocus = FocusNode();
var _passFocus = FocusNode();

class PassRegistrePage extends StatefulWidget {
  final Function onNext;
  final Widget bottom;

  PassRegistrePage(this.onNext, {this.bottom});

  @override
  _PassRegistrePageState createState() => _PassRegistrePageState();
}

class _PassRegistrePageState extends State<PassRegistrePage> {
  var registreBloc = Modular.get<RegistreBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmplitudeUtil.createEvent(AmplitudeUtil.eventoCadastroDeUsuario(4));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      imageWithBgWidget(context, ImagePath.imageAureula),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: "",
                style: AppThemeUtils.normalSize(
                    color: AppThemeUtils.black, fontSize: 26),
                children: <TextSpan>[
                  TextSpan(
                      text: StringFile.agoraDigiteSenha6Digito,
                      style: AppThemeUtils.normalSize(fontSize: 18)),
                ],
              ))),
      StreamBuilder<int>(
          stream: registreBloc.strongPassPass.stream,
          initialData: 0,
          builder:
              (BuildContext context, AsyncSnapshot<dynamic> snapshotStrong) {
            return Column(
              children: [
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
                              focusNode: _passFocus,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (text) {
                                registreBloc.updatePass(text, context);
                              },
                              onSubmitted: (term) {
                                Utils.fieldFocusChange(
                                    context, _passFocus, _confirmPassFocus);
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  labelText: StringFile.senha,
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
                widgetLinePass(
                    snapshotStrong.data, registreBloc.controllerPass.text),
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
                    focusNode: _confirmPassFocus,
                    textAlignVertical: TextAlignVertical.center,
                    onSubmitted: (term) {
                      _confirmPassFocus.unfocus();
                      widget.onNext();
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        labelText: StringFile.confirmPass,
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
      StreamBuilder<bool>(
          stream: registreBloc.userTermAccept.stream,
          initialData: false,
          builder: (context, snapshot) => Container(
                padding:
                    EdgeInsets.only(right: 12, left: 12, top: 12, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 50,
                        height: 45,
                        margin: EdgeInsets.only(right: 0),
                        child: Checkbox(
                          value: snapshot.data,
                          hoverColor: AppThemeUtils.colorPrimary,
                          focusColor: AppThemeUtils.colorPrimary,
                          activeColor: Colors.grey[300],
                          checkColor: AppThemeUtils.colorPrimary,
                          onChanged: (bool) =>
                              registreBloc.userTermAccept.add(bool),
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
                                style: AppThemeUtils.normalSize(
                                    color: Colors.grey[700], fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: StringFile.termoDeUso,
                                      style: AppThemeUtils.normalSize(
                                          color: AppThemeUtils.colorPrimary,
                                          decoration: TextDecoration.underline,
                                          fontSize: 18),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          goToTerm(StringFile.termoDeUso,
                                                  context)
                                              .then((value) {
                                            registreBloc.userTermAccept
                                                .add(value ?? false);
                                            if (value == true) {
                                              registreBloc
                                                  .changeAction(context);
                                            }
                                          });
                                        }),
                                  TextSpan(
                                      text: ' e ',
                                      style: AppThemeUtils.normalSize(
                                          color: Colors.grey[700],
                                          fontSize: 18)),
                                  TextSpan(
                                      text: StringFile.politicaDePrivacidade,
                                      style: AppThemeUtils.normalSize(
                                          color: AppThemeUtils.colorPrimary,
                                          decoration: TextDecoration.underline,
                                          fontSize: 18),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          goToTerm(
                                                  StringFile
                                                      .politicaDePrivacidade,
                                                  context)
                                              .then((value) {
                                            registreBloc.userTermAccept
                                                .add(value ?? false);
                                            if (value == true) {
                                              registreBloc
                                                  .changeAction(context);
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
      widget.bottom
    ]));
  }

  Widget widgetLinePass(int data, String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                StringFile.minimo6Digitos,
                style: new TextStyle(
                    color:
                        Utils.isMinLetter(text, 6) ? Colors.green : Colors.grey,
                    decoration: Utils.isMinLetter(text, 6)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 12),
              )),
              Expanded(
                  child: Text(
                StringFile.numero,
                style: new TextStyle(
                    color: Utils.hasDigits(text) ? Colors.green : Colors.grey,
                    decoration: Utils.hasDigits(text)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 12),
              ))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                StringFile.letrasMaiusculas,
                style: new TextStyle(
                    color: Utils.isUppercase(text) ? Colors.green : Colors.grey,
                    decoration: Utils.isUppercase(text)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 12),
              )),
              Expanded(
                  child: Text(
                StringFile.caracterEsp,
                style: new TextStyle(
                    color: Utils.isCharacter(text) ? Colors.green : Colors.grey,
                    decoration: Utils.isCharacter(text)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 12),
              ))
            ],
          ),

          // Text(
          //   data < 0
          //       ? "Senha muito curta adicione uma senha mais forte"
          //       : data == 0
          //           ? ""
          //           : data == 1
          //               ? "Sua senha e muito fraca"
          //               : data == 2
          //                   ? "Adicione letra maiúscula, caracteres especiais e no mínimo 6 dígitos."
          //                   : data == 3
          //                       ? "Senha forte"
          //                       : "Senha muito forte",
          //   style: AppThemeUtils.normalSize(
          //       fontSize: 10,
          //       color: data == -1
          //           ? Colors.black
          //           : data == 1
          //               ? Colors.grey
          //               : data == 2
          //                   ? Colors.yellow[800]
          //                   : data == 3
          //                       ? Colors.green[800]
          //                       : AppThemeUtils.colorError),
          // )
        ],
      ),
    );
  }
}
