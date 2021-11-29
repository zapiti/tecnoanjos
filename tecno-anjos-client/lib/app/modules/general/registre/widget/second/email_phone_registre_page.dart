

import 'package:flutter/material.dart';


import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/field/field_email_cod_confirm.dart';
import 'package:tecnoanjosclient/app/components/field/field_phone_cod_confirm.dart';
import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';

import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';


import '../../registre_bloc.dart';

class EmailPhoneRegistrePage extends StatefulWidget {

  final Function onNext;

  EmailPhoneRegistrePage(this.onNext);
  @override
  _EmailPhoneRegistrePageState createState() => _EmailPhoneRegistrePageState();
}

class _EmailPhoneRegistrePageState extends State<EmailPhoneRegistrePage> {

  var registreBloc = Modular.get<RegistreBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmplitudeUtil.createEvent(AmplitudeUtil.eventoCadastroDeUsuario(2));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Row(
        children: [
          Expanded(child: imageWithBgWidget(context, ImagePath.imagePhoneChat)),
          Expanded(child: imageWithBgWidget(context, ImagePath.imageEmailChat))
        ],
      ),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "",
                style: AppThemeUtils.normalSize(
                    color: AppThemeUtils.black, fontSize: 26),
                children: <TextSpan>[
                  TextSpan(
                      text: StringFile.qualSeuEmailPrincipal,
                      style: AppThemeUtils.normalSize(fontSize: 20)),
                ],
              ))),
      FieldPhoneCodConfirm(),FieldEmailCodConfirm(onNext:widget.onNext, hideValidate : true)

      // Container(
      //     margin: EdgeInsets.all(20),
      //     child: TextField(
      //       keyboardType: TextInputType.text,
      //       focusNode: registreBloc.emailFocus,
      //       inputFormatters: [
      //
      //       ],
      //       onChanged: (text) {
      //         //  registreBloc.tempRegisterUser.sink.add(registreUser);
      //       },
      //       onSubmitted: (term) {
      //         onNext();
      //       },
      //       controller: registreBloc.controllerEmail,
      //       decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      //           enabledBorder: const OutlineInputBorder(
      //             borderSide: BorderSide(color: Colors.grey, width: 0.3),
      //           ),
      //           hintText: " E-mail",
      //           border: RoundedRectangleBorder(
      //             borderSide: BorderSide(color: Colors.grey, width: 0.3),
      //           ),
      //           fillColor: Colors.grey[300]),
      //       style: AppThemeUtils.normalSize(fontSize: 18),
      //     ))
    ]));
  }
}

