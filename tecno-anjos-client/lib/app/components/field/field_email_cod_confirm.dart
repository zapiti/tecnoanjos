import 'dart:async';


import 'package:another_flushbar/flushbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';


import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'field_opt.dart';

class FieldEmailCodConfirm extends StatefulWidget {
  final Function onNext;
  final bool isVertical;
  final bool hideValidate;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final bool enable;
  FieldEmailCodConfirm(
      {this.onNext, this.isVertical = false, this.hideValidate = false, this. textInputAction, this. onEditingComplete, this.enable =  true});

  @override
  _FieldEmailCodConfirmState createState() => _FieldEmailCodConfirmState();
}

class _FieldEmailCodConfirmState extends State<FieldEmailCodConfirm> {
  var registreBloc = Modular.get<RegistreBloc>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    registreBloc.enableButtonEmail.sink.add(
        !Validator.email(registreBloc.controllerEmail.text));
  }

  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) =>
          setState(
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
            stream: registreBloc.isOptionEmail,
            initialData: false,
            builder: (context, snapshotOpt) {
              final isOption = snapshotOpt.data;
              return StreamBuilder<bool>(
                  stream: registreBloc.enableButtonEmail,
                  initialData: false,
                  builder: (context, snapshotEnable) {
                    final enableButton = snapshotEnable.data;


                    return StreamBuilder<bool>(
                        stream: registreBloc.isEmailValid,
                        initialData: false,
                        builder: (context, snpashot) {
                          final isValid = snpashot.data;

                          return isValid
                              ? Column(
                            children: [
                              TextField(
                                controller: registreBloc.controllerEmail,
                                enabled: false,textInputAction:widget.textInputAction,onEditingComplete:(){
                                  widget.onEditingComplete();
                              },
                                onChanged: (text) {},
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(80),
                                ],
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                    border: const OutlineInputBorder(),
                                    fillColor: Colors.grey[300]),
                                keyboardType: TextInputType.number,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: AppThemeUtils.whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),)),

                                  onPressed: () {
                                    registreBloc.isOptionEmail.sink.add(
                                        !isOption);


                                    registreBloc.isEmailValid.sink.add(false);
                                  },
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                  child: Text(
                                    StringFile.cancelar,
                                    style: TextStyle(
                                        color: AppThemeUtils.colorError,
                                        fontSize: 16),
                                  )
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                StringFile.emailValidadoComSucesso,
                                style: AppThemeUtils.normalSize(
                                    color: AppThemeUtils.colorPrimary),
                              )
                            ],
                          )
                              : isOption
                              ? Column(children: [
                            FieldOpt(false, registreBloc.pinFocusEmail,
                                registreBloc.pinControllerEmail, onSucess: () {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    widget.onNext();
                                  });
                                }),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: AppThemeUtils.colorError,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.all(
                                                    Radius.circular(4)),
                                          )),

                                      onPressed: () {
                                        registreBloc.isOptionEmail.sink.add(
                                            !isOption);
                                      },
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                      child: Text(
                                        StringFile.cancelar,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),

                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary:  _start == 0
                                              ? AppThemeUtils.colorPrimary
                                              : AppThemeUtils.lightGray,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.all(
                                                    Radius.circular(4)),)),

                                      onPressed:  _start == 0
                                          ? () {
                                        registreBloc
                                            .sendVerificationCod(context, () {
                                          setState(() {
                                            _start = 60;
                                          });

                                          startTimer();
                                        }, isTypePhone: false);
                                      }
                                          : () {},
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                      child: Text(
                                        _start == 0
                                            ? StringFile.reenviar
                                            : StringFile.enviado + " ($_start)",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),

                                    )
                                  ],
                                ))
                          ])
                              : Flex(
                            direction:
                            widget.isVertical ? Axis.vertical : Axis.horizontal,
                            children: [
                              widget.isVertical
                                  ? _buildTextField(context, enableButton)
                                  : Expanded(child: _buildTextField(
                                  context, enableButton)),
                              widget.hideValidate ? SizedBox() : Container(
                                  height: 45,

                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: enableButton
                                            ? AppThemeUtils.colorPrimary
                                            : AppThemeUtils.darkGrey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                        )),

                                    onPressed: enableButton
                                        ? () {
                                      registreBloc.sendVerificationCod(
                                          context, () async {

                                        startTimer();
                                        // await SmsAutoFill().listenForCode;
                                        //
                                        // setState(() {
                                        //   isOption = !isOption;
                                        // });
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
                                      }, isTypePhone: false);
                                    }
                                        : null,
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                    child: Text(
                                      StringFile.validar,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),

                                  ))
                            ],
                          );
                        });
                  });
            })
    );
  }

  Widget _buildTextField(BuildContext context, enableButton) {
    return StreamBuilder(
        stream: registreBloc.errorEmail,
        builder: (context, snpashotError) =>
            TextField(textInputAction:widget.textInputAction,enabled: widget.enable,onEditingComplete:(){
              widget.onEditingComplete();
            },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[ ]')),
                LengthLimitingTextInputFormatter(80),
              ],
              onChanged: (text) {
                if (snpashotError.data != null) {
                  registreBloc.errorEmail.sink.add(null);
                }
                if (!EmailValidator.validate(text)) {
                  if (!enableButton) {
                    registreBloc.enableButtonEmail.sink.add(true);
                  }
                } else {
                  if (enableButton) {
                    registreBloc.enableButtonEmail.sink.add(false);
                  }
                }

                //   registreBloc.tempRegisterUser.sink.add(registreUser);
              },
              controller: registreBloc.controllerEmail,
              focusNode: registreBloc.emailFocus,
              // onSubmitted: (term) {
              //   FocusScope.of(context).requestFocus(FocusNode());
              //   Utils.fieldFocusChange(
              //       context, registreBloc.emailFocus, registreBloc.emailFocus);
              // },

              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  errorText: snpashotError.data,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.3),
                  ),
                  hintText: StringFile.email ,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.3),
                  ),
                  fillColor: Colors.grey[300]),
              style: AppThemeUtils.normalSize(fontSize: 18),
            ));
  }
}
