import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:tecnoanjosclient/app/components/load/load_elements.dart';

import 'package:tecnoanjosclient/app/components/select/select_button.dart';

import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/login/bloc/login_bloc.dart';

import 'package:tecnoanjosclient/app/utils/image/image_logo_widget.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

// ignore: must_be_immutable

class RecoveryPassPage extends StatefulWidget {
  @override
  _RecoveryPassPageState createState() => _RecoveryPassPageState();
}

class _RecoveryPassPageState extends State<RecoveryPassPage> {
  final bloc = Modular.get<LoginBloc>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController tab;
  var isPhone = true;

  var initialPoss = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          return true;
        },
        child: Scaffold(
            key: _scaffoldKey,
            body: Container(
                color: Colors.white,
                child: StreamBuilder(
                    stream: bloc.isLoad,
                    initialData: false,
                    builder: (context, snapshot) {
                      var _isLoadRequest = snapshot.data;
                      return Column(children: <Widget>[
                        Container(
                            color: AppThemeUtils.colorPrimary,
                            child: getLogoIcon(
                                width: MediaQuery.of(context).size.width,
                                height: 200)),
                        Expanded(
                            child: StreamBuilder(
                                stream: bloc.showFieldPass,
                                initialData: false,
                                builder: (context, snapshot2) {
                                  return snapshot2.data
                                      ? BuildAlterPass(context, _isLoadRequest,
                                          initialPoss == 0)
                                      : SingleChildScrollView(
                                          child: Column(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    right: 15,
                                                    left: 15,
                                                    top: 0,
                                                    bottom: 10),
                                                child: SelectButton(
                                                  // keys: [keyB5,keyB6],
                                                  initialItem: initialPoss,
                                                  everyEnable: true,
                                                  tapIndex: (i) {
                                                    setState(() {
                                                      initialPoss = i?.first;
                                                    });
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());

                                                    if (initialPoss == 0) {
                                                      bloc.emailController
                                                          .clear();
                                                    } else {
                                                      bloc.phoneController
                                                          .clear();
                                                    }
                                                  },
                                                  title: [
                                                    Pairs(0, "Telefone"),
                                                    Pairs(1, "E-mail"),
                                                  ],
                                                )),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                                child: Container(
                                                    color: AppThemeUtils
                                                        .whiteColor,
                                                    child: TextField(
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .deny(
                                                                RegExp('[ ]')),
                                                        LengthLimitingTextInputFormatter(
                                                            100),
                                                      ],
                                                      enabled: true,
                                                      autofocus: false,
                                                      focusNode: FocusNode(),
                                                      keyboardType:
                                                          initialPoss == 0
                                                              ? TextInputType
                                                                  .number
                                                              : TextInputType
                                                                  .text,
                                                      controller: initialPoss ==
                                                              0
                                                          ? bloc.phoneController
                                                          : bloc
                                                              .emailController,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      decoration:
                                                          InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          5),
                                                              labelText: initialPoss ==
                                                                      0
                                                                  ? "Digite seu telefone"
                                                                  : "Digite seu E-mail",
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .person_outline,
                                                                color: AppThemeUtils
                                                                    .colorPrimary,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.3),
                                                              )),
                                                    ))),
                                            Container(
                                              height: 45,
                                              width: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 15),
                                              child: _isLoadRequest
                                                  ? loadElements(context,
                                                      margin: EdgeInsets.only(
                                                          top: 10))
                                                  : ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: AppThemeUtils
                                                            .colorPrimary,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                        bloc.recoveryPass(
                                                          context,
                                                          isPhone:
                                                              initialPoss == 0,
                                                        );
                                                      },
                                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                                      child: Text(
                                                        StringFile
                                                            .recuperaSenha,
                                                        style: TextStyle(
                                                            color: AppThemeUtils
                                                                .whiteColor,
                                                            fontSize: 16),
                                                      )),
                                            ),
                                            SizedBox(height: 25),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    elevation: 0),
                                                onPressed: () {
                                                  Modular.to.pop();
                                                },
                                                child: Text(
                                                  StringFile.voltarParaLogin,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppThemeUtils
                                                          .colorPrimary),
                                                ))
                                          ],
                                        ));
                                }))
                      ]);
                    }))));
  }
}

Widget widgetLinePass(int data, String text) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
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
                child: Row(
              children: [
                !Utils.isMinLetter(text, 6)
                    ? SizedBox()
                    : Icon(
                        Icons.check_circle,
                        color: AppThemeUtils.colorPrimary,
                        size: 14,
                      ),
                Expanded(
                    child: Text(
                  StringFile.minimo6Digitos,
                  style: new TextStyle(
                      color: Utils.isMinLetter(text, 6)
                          ? AppThemeUtils.colorPrimary
                          : Colors.grey,
                      // decoration: Utils.isMinLetter(text, 6)
                      //     ? TextDecoration.lineThrough
                      //     : TextDecoration.none,
                      fontSize: 10),
                ))
              ],
            )),
            Expanded(
                child: Row(children: [
              !Utils.hasDigits(text)
                  ? SizedBox()
                  : Icon(
                      Icons.check_circle,
                      color: AppThemeUtils.colorPrimary,
                      size: 14,
                    ),
              Expanded(
                  child: Text(
                StringFile.numero,
                style: new TextStyle(
                    color: Utils.hasDigits(text)
                        ? AppThemeUtils.colorPrimary
                        : Colors.grey,
                    // decoration: Utils.hasDigits(text)
                    //     ? TextDecoration.lineThrough
                    //     : TextDecoration.none,
                    fontSize: 10),
              ))
            ]))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Row(children: [
              !Utils.isUppercase(text)
                  ? SizedBox()
                  : Icon(
                      Icons.check_circle,
                      color: AppThemeUtils.colorPrimary,
                      size: 14,
                    ),
              Expanded(
                  child: Text(
                StringFile.letrasMaiusculas,
                style: new TextStyle(
                    color: Utils.isUppercase(text)
                        ? AppThemeUtils.colorPrimary
                        : Colors.grey,
                    // decoration: Utils.isUppercase(text)
                    //     ? TextDecoration.lineThrough
                    //     : TextDecoration.none,
                    fontSize: 10),
              ))
            ])),
            Expanded(
                child: Row(children: [
              !Utils.isCharacter(text)
                  ? SizedBox()
                  : Icon(
                      Icons.check_circle,
                      color: AppThemeUtils.colorPrimary,
                      size: 14,
                    ),
              Expanded(
                  child: Text(
                StringFile.caracterEspecial,
                style: new TextStyle(
                    color: Utils.isCharacter(text)
                        ? AppThemeUtils.colorPrimary
                        : Colors.grey,
                    // decoration: Utils.isCharacter(text)
                    //     ? TextDecoration.lineThrough
                    //     : TextDecoration.none,
                    fontSize: 10),
              ))
            ]))
          ],
        ),
      ],
    ),
  );
}

class BuildAlterPass extends StatefulWidget {
  final BuildContext context;
  final bool isLoadRequest;
  final bool isPhone;

  BuildAlterPass(this.context, this.isLoadRequest, this.isPhone);

  @override
  _BuildAlterPassState createState() => _BuildAlterPassState();
}

class _BuildAlterPassState extends State<BuildAlterPass> {
  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: AppThemeUtils.colorPrimary,
    borderRadius: BorderRadius.circular(20.0),
  );

  var _passFocus = FocusNode();

  final bloc = Modular.get<LoginBloc>();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kIsWeb) {
      SmsAutoFill().getAppSignature.then((value) {
        print("Codigo $value");
      });
      SmsAutoFill().code.listen((value) {
        bloc.tokenController.text = value;
        print("=========Codigo $value");
      });
      SmsAutoFill().listenForCode.then((_) {
        print("Codigo ");
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: 0, bottom: 10, right: 10, left: 10),
                    child: Text(
                      widget.isPhone
                          ? StringFile.adicionecodigoSMS
                          : StringFile.adicionecodigoEmail,
                      textAlign: TextAlign.center,
                      style: AppThemeUtils.normalBoldSize(
                          color: AppThemeUtils.colorPrimary, fontSize: 20),
                    )),

                // Padding(
                //     padding:
                //     const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                //     child:   PinFieldAutoFill(controller: bloc.tokenController,focusNode: _pinPutFocusNode,
                //   decoration: UnderlineDecoration(
                //     textStyle: TextStyle(fontSize: 20, color: Colors.black),
                //     colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                //   ),
                //
                //   onCodeSubmitted: (code) {},
                //   onCodeChanged: (code) {
                //     if (code.length == 6) {
                //       FocusScope.of(context).requestFocus(FocusNode());
                //     }
                //   },
                // )),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: PinPut(
                    fieldsCount: 6,
                    textStyle:
                        const TextStyle(fontSize: 20.0, color: Colors.white),
                    eachFieldWidth: 30.0,
                    eachFieldHeight: 40.0,
                    onSubmit: (String pin) {
                      _passFocus.requestFocus();
                    },
                    focusNode: _pinPutFocusNode,
                    controller: bloc.tokenController,
                    submittedFieldDecoration: BoxDecoration(
                      color: AppThemeUtils.colorPrimary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    selectedFieldDecoration: BoxDecoration(
                      color: AppThemeUtils.darkGrey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    followingFieldDecoration: BoxDecoration(
                      color: AppThemeUtils.lightGray,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
                StreamBuilder<int>(
                    stream: bloc.strongPassPass.stream,
                    initialData: 0,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return Column(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              margin: EdgeInsets.only(bottom: 0),
                              child: StreamBuilder<bool>(
                                  stream: bloc.showPass.stream,
                                  initialData: true,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshotHide) {
                                    return TextField(
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(24),
                                        ],
                                        obscureText: snapshotHide.data,
                                        controller: bloc.controllerPass,
                                        textAlign: TextAlign.start,
                                        focusNode: _passFocus,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        onChanged: (text) {
                                          bloc.updatePass(text, context);
                                        },
                                        onSubmitted: (term) {
                                          bloc.recoveryPassMyPass(
                                            context,
                                          );
                                        },
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                            labelText: StringFile.novaSenha,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                snapshotHide.data
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color:
                                                    AppThemeUtils.colorPrimary,
                                              ),
                                              onPressed: () {
                                                bloc.showPass.sink
                                                    .add(!snapshotHide.data);
                                              },
                                            ),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.3),
                                            )));
                                  })),
                          SizedBox(
                            height: 5,
                          ),
                          widgetLinePass(
                              snapshot.data, bloc.controllerPass.text),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }),

                SizedBox(
                  height: 20,
                ),
                widget.isLoadRequest
                    ? loadElements(context, size: 50)
                    : Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                )),
                            onPressed: () {
                              bloc.recoveryPassMyPass(context);
                            },
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                            child: Text(
                              StringFile.trocarSenha,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ))),
                widget.isLoadRequest
                    ? SizedBox()
                    : Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: AppThemeUtils.colorError,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                    )),
                                onPressed: () {
                                  bloc.showFieldPass.sink.add(false);
                                },
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                child: Text(
                                  StringFile.cancelar,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _start == 0
                                      ? AppThemeUtils.colorPrimary
                                      : AppThemeUtils.lightGray,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  )),

                              onPressed: _start == 0
                                  ? () {
                                      bloc.recoveryPass(
                                        context,
                                        isPhone: widget.isPhone,
                                      );

                                      setState(() {
                                        _start = 60;
                                      });

                                      startTimer();
                                    }
                                  : () {},
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                              child: Text(
                                _start == 0
                                    ? StringFile.reenviar
                                    : StringFile.enviado + " ($_start)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            )
                          ],
                        ))
              ],
            )));
  }
}
