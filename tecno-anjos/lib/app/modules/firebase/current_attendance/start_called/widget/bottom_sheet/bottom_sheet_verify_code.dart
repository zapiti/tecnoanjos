import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tecnoanjostec/app/components/bublle.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Future<void> showBottomSheetServices(BuildContext context,
    {Function(String) selected}) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) => _ServicesBottomSheet(selected: selected),
  );
}

class _ServicesBottomSheet extends StatefulWidget {
  final Function(String) selected;

  _ServicesBottomSheet({this.selected});

  @override
  _ServicesBottomSheetState createState() => _ServicesBottomSheetState();
}

class _ServicesBottomSheetState extends State<_ServicesBottomSheet> {
  final _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
            children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10, right: 0, left: 20),
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppThemeUtils.colorPrimary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Text(
                    "VERIFICAR ATENDIMENTO",
                    textAlign: TextAlign.start,
                    style: AppThemeUtils.normalSize(
                        color: AppThemeUtils.colorPrimary),
                  ),
                  padding: EdgeInsets.all(10),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 15, right: 20, left: 20),
            child: Text(
              "Para verificar e iniciar o atendimento, insira abaixo a palavra-chave que está localizada na aba de “Detalhes do atendimento” do cliente.",
              textAlign: TextAlign.center,
              style: AppThemeUtils.normalBoldSize(),
            ),
            padding: EdgeInsets.all(10),
          ),
          // Container(
          //   margin: EdgeInsets.all(10),
          //   child: Text(
          //     "Subtitulo",
          //     style: AppThemeUtils.normalSize(),
          //   ),
          //   padding: EdgeInsets.all(10),
          // ),

          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(24),
                  ],
                  controller: _textController,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (text) {},
                  onSubmitted: (term) {},
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      labelText: "",
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.3),
                      )))),

          Container(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  widget.selected(_textController.text);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    primary: AppThemeUtils.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: AppThemeUtils.colorError))),
                child: Container(
                    height: 45,
                    child: Center(
                        child: Text(
                      "Verificar atendimento",
                      style: AppThemeUtils.normalSize(
                          color: AppThemeUtils.whiteColor),
                    ))),
              ))
        ]));
  }
}
