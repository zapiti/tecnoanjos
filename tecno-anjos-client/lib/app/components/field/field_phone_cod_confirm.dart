import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import 'field_opt.dart';

class FieldPhoneCodConfirm extends StatefulWidget {
  final bool isVertical;
  final TextInputAction textInputAction;
  final Function onEditingComplete;

  FieldPhoneCodConfirm(
      {this.isVertical = false, this.textInputAction, this.onEditingComplete});

  @override
  _FieldPhoneCodConfirmState createState() => _FieldPhoneCodConfirmState();
}

class _FieldPhoneCodConfirmState extends State<FieldPhoneCodConfirm> {
  var registreBloc = Modular.get<RegistreBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registreBloc.isOptionPhone.sink.add(false);

    registreBloc.enableButtonPhone.sink.add(false);

    registreBloc.enableButtonPhone.sink
        .add(registreBloc.controllerTelefone.text.length >= 15);
  }

  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer?.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<bool>(
            stream: registreBloc.isOptionPhone,
            initialData: false,
            builder: (context, snapshotOpt) {
              var isOption = snapshotOpt.data;
              return StreamBuilder<bool>(
                  stream: registreBloc.enableButtonPhone,
                  initialData: false,
                  builder: (context, snapshotEnable) {
                    var enableButton = snapshotEnable.data;

                    return StreamBuilder<bool>(
                        stream: registreBloc.isPhoneValid,
                        initialData: false,
                        builder: (context, snpashot) => snpashot.data
                            ? Column(
                                children: [
                                  TextField(
                                    controller: registreBloc.controllerTelefone,
                                    textInputAction: widget.textInputAction,
                                    onEditingComplete: widget.onEditingComplete,
                                    enabled: false,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(80),
                                    ],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[300]),
                                    keyboardType: TextInputType.number,
                                  ),
                                Row(children: [
                                 Expanded(child:  Text(
                                    StringFile.telefoneValidado,
                                    style: AppThemeUtils.normalSize(
                                        color: AppThemeUtils.colorPrimary,fontSize: 12),
                                  )),ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: AppThemeUtils.whiteColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        )),

                                    onPressed: () {
                                      registreBloc.isOptionPhone.sink
                                          .add(!isOption);
                                      registreBloc.isPhoneValid.sink.add(false);
                                    },
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                    child: Text(
                                      StringFile.cancelar,
                                      style: TextStyle(
                                          color: AppThemeUtils.colorError,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],)


                                ],
                              )
                            : isOption
                                ? Column(children: [
                                    FieldOpt(true, registreBloc.pinFocusPhone,
                                        registreBloc.pinControllerPhone),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary:
                                                      AppThemeUtils.colorError,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  )),

                                              onPressed: () {
                                                registreBloc.isOptionPhone.sink
                                                    .add(!isOption);
                                              },
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                              child: Text(
                                                StringFile.cancelar,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary:
                                                          _start == 0
                                                      ? AppThemeUtils
                                                          .colorPrimary
                                                      : AppThemeUtils.lightGray,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  )),

                                              onPressed:
                                                   _start == 0
                                                      ? () {
                                                          registreBloc
                                                              .sendVerificationCod(
                                                                  context, () {
                                                            setState(() {
                                                              _start = 60;
                                                            });

                                                            startTimer();
                                                          });
                                                        }
                                                      : () {},
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                              child: Text(
                                                _start == 0
                                                    ? StringFile.reenviar
                                                    : StringFile.enviado +
                                                        " ($_start)",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ))
                                  ])
                                : Flex(
                                    direction: widget.isVertical
                                        ? Axis.vertical
                                        : Axis.horizontal,
                                    children: [
                                      widget.isVertical
                                          ? _buildStreamBuilder(enableButton)
                                          : Expanded(
                                              child: _buildStreamBuilder(
                                                  enableButton)),
                                      Container(
                                          height: 50,margin: EdgeInsets.only(left: 8),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: enableButton
                                                    ? AppThemeUtils.colorPrimary
                                                    : AppThemeUtils.darkGrey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                )),

                                            onPressed: enableButton
                                                ? () {
                                                    registreBloc
                                                        .sendVerificationCod(
                                                            context, () async {
                                                              startTimer();
                                                      // await SmsAutoFill().listenForCode;
                                                      // registreBloc.isOptionPhone.sink.add(!isOption);

                                                              Flushbar(
                                                                flushbarStyle: FlushbarStyle.GROUNDED,
                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                backgroundColor: AppThemeUtils.colorPrimary,
                                                                message: "Código enviado com sucesso para seu telefone, Por favor aguarde!",
                                                                icon: Icon(
                                                                  Icons.info_outline,
                                                                  size: 28.0,
                                                                  color: AppThemeUtils.whiteColor,
                                                                ),
                                                                duration: Duration(seconds: 15),
                                                              )..show(context);
                                                    });
                                                  }
                                                : null,
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                            child: Text(
                                              StringFile.validar,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ))
                                    ],
                                  ));
                  });
            }));
  }

  StreamBuilder<String> _buildStreamBuilder(bool enableButton) {
    return StreamBuilder(
        stream: registreBloc.errorNumber,
        builder: (context, snpashotError) => TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(80),
              ],
              keyboardType: TextInputType.number,
              onChanged: (text) {
                if (snpashotError.error != null) {
                  registreBloc.errorNumber.sink.add(null);
                }
                Utils.getMaskPhone(
                  text,
                  //     updateController: (text) {
                  //   registreBloc.controllerTelefone.updateMask(text);
                  // }
                );
                if (text.length >= 16) {
                  if (!enableButton) {
                    registreBloc.enableButtonPhone.sink.add(true);
                  }
                } else {
                  if (enableButton) {
                    registreBloc.enableButtonPhone.sink.add(false);
                  }
                }

                //   registreBloc.tempRegisterUser.sink.add(registreUser);
              },
              controller: registreBloc.controllerTelefone,
              focusNode: registreBloc.phoneFocus,
              onSubmitted: (term) {
                FocusScope.of(context).requestFocus(FocusNode());
                Utils.fieldFocusChange(
                    context, registreBloc.phoneFocus, registreBloc.emailFocus);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  errorText: snpashotError.data,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.3),
                  ),
                  hintText: StringFile.telefone,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.3),
                  ),
                  fillColor: Colors.grey[300]),
              style: AppThemeUtils.normalSize(fontSize: 18),
            ));
  }
}
