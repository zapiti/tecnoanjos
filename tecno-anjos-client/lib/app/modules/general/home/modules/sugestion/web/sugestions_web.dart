import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/card_web_with_title.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';

import 'package:tecnoanjosclient/app/components/page/default_tab_page.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import '../sugestion_bloc.dart';
TabController tab;
class SugestionsWeb extends StatelessWidget {
  final sugestionsController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return CardWebWithTitle(
        child:  DefaultTabPage(tab,
                title: [StringFile.sugestoes, StringFile.critical],
                changeTab: (tab) {
                  tab.addListener(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    sugestionsController.clear();
                  });
                },
                page: [
                  CriticalSuggestion(sugestionsController, isSuggestion: true),
                  CriticalSuggestion(sugestionsController, isSuggestion: false)
                ]));
  }
}

class CriticalSuggestion extends StatefulWidget {
  final TextEditingController suggestionsController;
  final bool isSuggestion;

  CriticalSuggestion(this.suggestionsController, {this.isSuggestion});

  @override
  _CriticalSuggestionState createState() => _CriticalSuggestionState();
}

class _CriticalSuggestionState extends State<CriticalSuggestion> {
  var sugestionsBloc = Modular.get<SugestionBloc>();
  var formKey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Form(
                key: formKey,
          
                child: TextFormField(
                    inputFormatters: [
                    LengthLimitingTextInputFormatter(400),],
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  validator: (value) {
                    return value.length < 100 ? StringFile.validacao100 : null;
                  },
                  onFieldSubmitted: (value) {
                    sendAction(context);
                  },
                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      labelText: StringFile.digiteSuaMensagem,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0.3),
                      )),
                  maxLength: 400,
                  controller: widget.suggestionsController,
                ))),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
  primary:  Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),),
              onPressed: () {
                sendAction(context);
              },
              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
              child: Text(
                StringFile.enviar,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            )),
      ],
    ));
  }

  void sendAction(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (widget.suggestionsController.text.isNotEmpty) {
        sugestionsBloc.makeSugestion(
            context, widget.suggestionsController.text, widget.isSuggestion,
            () {
          widget.suggestionsController.clear();
          FocusScope.of(context).requestFocus(FocusNode());
        });
      } else {
        showGenericDialog(context:context,
            title: StringFile.ops,
            description: StringFile.adicionaeMsg,
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}
