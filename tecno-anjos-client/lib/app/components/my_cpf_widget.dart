import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';



class MyCpfWidget extends StatefulWidget {
  final controller;
  final String msgError;
  final  Function actionNext;

  MyCpfWidget({this.controller, this.msgError, this.actionNext});

  @override
  _MyCpfWidgetState createState() => _MyCpfWidgetState();
}

class _MyCpfWidgetState extends State<MyCpfWidget> {
  var userMyCard = false;
  var focusCpf = FocusNode();
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(onInit: (){
      checkCpf(context);
    }, child:  Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                StringFile.useCpfCadastrado,
                textAlign: TextAlign.end,
                style: AppThemeUtils.normalSize(fontSize: 12),
              ),
            ),
            Switch(
                value: userMyCard,
                onChanged: (value) {
                  if (!value) {

                    FocusScope.of(context).requestFocus(FocusNode());
                    checkCpf(context);
                  } else {
                    widget.controller.text = "";

                    setState(() {
                      FocusScope.of(context).requestFocus(focusCpf);
                      userMyCard = true;
                    });
                  }
                }),
            SizedBox(
              width: 12,
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          margin: const EdgeInsets.only(left: 16, top: 0, right: 16),
          child: TextField(focusNode: focusCpf,
            inputFormatters: [
              LengthLimitingTextInputFormatter(80),
            ],
            enabled: userMyCard,
            controller: widget.controller,
            onSubmitted: (x){
              widget.actionNext();
            },
            decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              border: const OutlineInputBorder(),
              errorText: widget.msgError,
              labelText: StringFile.cpfTitular,
              hintText: '',
            ),
            keyboardType: TextInputType.number,
             textInputAction: TextInputAction.done,
          ),
        ),

      ],
    ));
  }

  void checkCpf(BuildContext context) {
      var profileBloc = Modular.get<ProfileBloc>();
    profileBloc.verifyNeedCpf(context, (containsCpf) async {
      if (containsCpf != null) {
        setState(() {
          userMyCard = false;
          widget.controller.text = containsCpf;
        });
      } else {
        // showGenericDialog(
        //     context: context,
        //     title: StringFile.opps,
        //     description:StringFile.vocenaoCadastrou,
        //     iconData: Icons.error_outline,
        //     positiveCallback: () {
        //       setState(() {
        //         userMyCard = true;
        //       });
        //     },
        //     positiveText: StringFile.ok);
      }
    });
  }
}
