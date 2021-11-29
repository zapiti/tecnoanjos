import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjostec/app/components/load/load_elements.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/image/image_logo_widget.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import 'bloc/login_bloc.dart';

var _passFocus = FocusNode();
var _userFocus = FocusNode();

class LoginPage extends StatelessWidget {
  final bloc = Modular.get<LoginBloc>();

  final error = false;

  final controllerPass = TextEditingController(text: "");
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: AppThemeUtils.colorPrimary,
    borderRadius: BorderRadius.circular(20.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<bool>(
              stream: bloc.isLoad,
              initialData: false,
              builder: (context, snapshot) {
                var _isLoadRequest = snapshot.data;
                return Column(children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  getLogoIcon(height: 150),
                  FieldPass(_isLoadRequest),
                  _isLoadRequest
                      ? SizedBox()
                      : ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.white,elevation: 0),
                          onPressed: () {
                            Modular.to
                                .pushNamed(ConstantsRoutes.CALL_RECOVERYPASS);
                          },
                          child: Container(
                              height: 45,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(StringFile.esqueciSenha,
                                    textAlign: TextAlign.end,
                                    style: AppThemeUtils.normalSize(
                                        decoration: TextDecoration.underline,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color)),
                              )))
                ]);
              },
            )),
      ),
    );
  }
}

class FieldPass extends StatefulWidget {
  final bool _isLoadRequest;

  FieldPass(this._isLoadRequest);

  @override
  _FieldPassState createState() => _FieldPassState();
}

class _FieldPassState extends State<FieldPass> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final bloc = Modular.get<LoginBloc>();

  Timer _timer;
  int _start = 30;

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
    if(!kIsWeb) {
      SmsAutoFill().getAppSignature.then((value) {
        print("Codigo $value");
      });
      SmsAutoFill().code.listen((value) {
        _pinPutController.text = value;
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
    return StreamBuilder<bool>(
        stream: bloc.isPassCode,
        initialData: false,
        builder: (context, snapshot) {
          var _viewPassCode = snapshot.data;
          if(_viewPassCode){
            if(_start == 60){
              startTimer();
            }
          }

          return _viewPassCode
              ? Container(

                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(

                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: 350,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Material(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 0),
                                  child: Icon(
                                    Icons.offline_pin_sharp,
                                    color: AppThemeUtils.colorPrimary,
                                    size: 40,
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 0,
                                        bottom: 10,
                                        right: 10,
                                        left: 10),
                                    child: Text(
                                      StringFile.codigoVerificacao,
                                      textAlign: TextAlign.center,
                                      style: AppThemeUtils.normalBoldSize(
                                          color: AppThemeUtils.colorPrimary,
                                          fontSize: 20),
                                    )),
                                lineViewWidget(),
                                widget._isLoadRequest
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: loadElements(context, size: 80))
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 0),
                                        child: PinPut(
                                          fieldsCount: 6,
                                          textStyle: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                          eachFieldWidth: 30.0,
                                          eachFieldHeight: 40.0,
                                          onSubmit: (String pin) {
                                            bloc
                                                .getLoginWithToken(context, pin)
                                                .then((value) {
                                              if (!value) {
                                                _pinPutController.clear();
                                              }
                                            });
                                          },
                                          focusNode: _pinPutFocusNode,
                                          controller: _pinPutController,
                                          validator: (value) {
                                            return null;
                                          },
                                          submittedFieldDecoration:
                                              BoxDecoration(
                                            color: AppThemeUtils.colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          selectedFieldDecoration:
                                              BoxDecoration(
                                            color: AppThemeUtils.darkGrey,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          followingFieldDecoration:
                                              BoxDecoration(
                                            color: AppThemeUtils.lightGray,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          pinAnimationType:
                                              PinAnimationType.fade,
                                        ),
                                      ),
                                lineViewWidget(),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            bloc.isPassCode.sink.add(false);
                                          },
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                          child: Text(
                                            "Cancelar",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: AppThemeUtils.colorError,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: _start == 30 ||
                                                        _start == 0
                                                    ? AppThemeUtils.colorPrimary
                                                    : AppThemeUtils.lightGray,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                )),
                                            onPressed:
                                                _start == 30 || _start == 0
                                                    ? () {
                                                        bloc.getLogin(context);

                                                        setState(() {
                                                          _start = 30;
                                                        });

                                                        startTimer();
                                                      }
                                                    : () {},
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                            child: Text(
                                              _start == 30 || _start == 0
                                                  ? StringFile.reenviado
                                                  : "Enviado ($_start)",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ))
                                      ],
                                    )),
                              ],
                            ),
                          ))))
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),

                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        width: 600,
                        padding: EdgeInsets.only(
                            bottom: 10, right: 15, left: 15, top: 15),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 45,
                                  margin: EdgeInsets.only(bottom: 5, top: 5),
                                  child: imageWithBgWidget(
                                      context, ImagePath.imageExit)),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RichText(
                                      text: TextSpan(
                                    text: StringFile.bemvindo,
                                    style: AppThemeUtils.normalSize(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .color,
                                        fontSize:
                                            MediaQuery.of(context).size.height <
                                                    600
                                                ? 16
                                                : 18),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ""
                                          // " digite o número que te enviaremos um código de confirmação",
                                          ,
                                          style: AppThemeUtils.normalSize(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
                                              fontSize: 18)),
                                    ],
                                  ))),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                margin: EdgeInsets.symmetric(vertical: 12),
                                child: TextField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(80),
                                  ],
                                  enabled: !widget._isLoadRequest,
                                  controller: bloc.controllerUser,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _userFocus,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (term) {
                                    Utils.fieldFocusChange(
                                        context, _userFocus, _passFocus);
                                  },
                                  decoration: InputDecoration(
                                      labelText: StringFile.celular,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.3),
                                      )),
                                  onChanged: (text) {
                                    Utils.getMaskPhone(
                                      text,
                                      //     updateController: (text) {
                                      //   bloc.controllerUser
                                      //       .updateMask(text);
                                      // }
                                    );
                                  },
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  margin: EdgeInsets.only(bottom: 0),
                                  child: StreamBuilder<bool>(
                                      stream: bloc.showPass.stream,
                                      initialData: true,
                                      builder:
                                          (BuildContext context, snapshotHide) {
                                        return TextField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  80),
                                            ],
                                            enabled: !widget._isLoadRequest,
                                            textInputAction: TextInputAction.go,
                                            obscureText: snapshotHide.data,
                                            focusNode: _passFocus,
                                            controller: bloc.controllerPass,
                                            textAlign: TextAlign.start,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            onSubmitted: (term) {
                                              _passFocus.unfocus();
                                              bloc.getLogin(context);
                                            },
                                            decoration: InputDecoration(
                                                labelText: StringFile.senha,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    snapshotHide.data
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: AppThemeUtils
                                                        .colorPrimary,
                                                  ),
                                                  onPressed: () {
                                                    bloc.showPass.sink.add(
                                                        !snapshotHide.data);
                                                  },
                                                ),
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.3),
                                                )));
                                      })),
                              SizedBox(height: 25),
                              Container(
                                height: 45,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: widget._isLoadRequest
                                    ? loadElements(context,
                                        margin: EdgeInsets.only(top: 10))
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          bloc.getLogin(context);
                                        },
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                        child: Text(
                                          StringFile.entrar,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                              ),
                              SizedBox(height:20,)
                            ],
                          ),
                        ),
                      )),
                );
        });
  }
}
