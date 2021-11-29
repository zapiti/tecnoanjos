
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class FieldOpt extends StatefulWidget {
 final bool isTypePhone;
 final Function onSucess;
 final FocusNode focusNode;
 final  TextEditingController controller;


  FieldOpt(this.isTypePhone, this.focusNode,this.controller, {this.onSucess});

  @override
  _FieldOptState createState() => _FieldOptState();
}

class _FieldOptState extends State<FieldOpt> {
  var registreBloc = Modular.get<RegistreBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.focusNode.requestFocus();
    });
    if(!kIsWeb) {
      SmsAutoFill().getAppSignature.then((value) {
        print("Codigo $value");
      });
      SmsAutoFill().code.listen((value) {
        registreBloc.optController.text = value;
        print("=========Codigo $value");
      });
      SmsAutoFill().listenForCode.then((_) {
        print("Codigo ");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      // Padding(
      //     padding:
      //     const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      //     child:   PinFieldAutoFill(controller:  registreBloc.optController,
      //       decoration: UnderlineDecoration(
      //         textStyle: TextStyle(fontSize: 20, color: Colors.black),
      //         colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
      //       ),
      //
      //       onCodeSubmitted: (code) {},
      //       onCodeChanged: (code) {
      //         if (code.length == 6) {
      //           FocusScope.of(context).requestFocus(FocusNode());
      //         }
      //       },
      //     ));

      Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: PinPut(
        fieldsCount: 6,
        controller: registreBloc.optController,
        autofocus: true,
        focusNode: widget.focusNode,
        textStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
        eachFieldWidth: 30.0,
        eachFieldHeight: 40.0,
        onSubmit: (String pin) {
          if (pin.length == 6) {
            if (mounted) {
              registreBloc.sendVerifyCodExists(context, widget.controller, () {
                if (widget.onSucess != null) {
                  widget.onSucess();
                }
                if (mounted) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              }, isTypePhone: widget.isTypePhone);
            }
          }
        },
        submittedFieldDecoration: BoxDecoration(
          color: AppThemeUtils.colorPrimary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        selectedFieldDecoration: BoxDecoration(
          color: AppThemeUtils.darkGrey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        followingFieldDecoration: BoxDecoration(
          color: AppThemeUtils.lightGray,
          borderRadius: BorderRadius.circular(8.0),
        ),
        pinAnimationType: PinAnimationType.fade,
      ),
    );
  }
}
