import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';

import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/gradient_container.dart';

import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import '../profile_bloc.dart';

class CpfPage extends StatefulWidget {
  @override
  _CpfPageState createState() => _CpfPageState();
}

class _CpfPageState extends State<CpfPage> {
  var controller = MaskedTextController(mask: Utils.cpfCnpj(""));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringFile.cadastreSeuCpf,
              style:
                  AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary)),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width > 450
                      ? 400
                      : MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Material(
                    color: Colors.white,
                    child: ListBody(
                      children: <Widget>[
                        gradientContainer(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 0),
                              child: Icon(
                                Icons.edit,
                                color: AppThemeUtils.whiteColor,
                                size: 40,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 0, bottom: 10, right: 10, left: 10),
                                child: Text(
                                  StringFile.adicioneParaContinuar,
                                  textAlign: TextAlign.center,
                                  style: AppThemeUtils.normalBoldSize(
                                      color: AppThemeUtils.whiteColor,
                                      fontSize: 20),
                                )),
                          ],
                        )),
                        Container(
                          padding: EdgeInsets.only(top: 20, bottom: 0),
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Colors.white, width: 1),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: TextField(
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(80),
                                        ],
                                        keyboardType: TextInputType.number,
                                        controller: controller,
                                        decoration: InputDecoration(
                                            hintText: "Adicione um cpf",
                                            border: const OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.3),
                                            )),
                                      )),
                                ),
                              ),
                              Container(
                                width: 200,
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Wrap(
                                          children: <Widget>[
                                            Text(
                                              StringFile.oqdeseja,
                                              textAlign: TextAlign.center,
                                              style: AppThemeUtils
                                                  .normalBoldSize(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              lineViewWidget(),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppThemeUtils.colorError,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                side: BorderSide(
                                                    color: AppThemeUtils
                                                        .colorError,
                                                    width: 1))),
                                        onPressed: () {
                                          if (controller.text.length < 11) {
                                            showGenericDialog(
                                                context: context,
                                                title: StringFile.Erro,
                                                description: StringFile
                                                    .cpfFormatoInvalido,
                                                iconData: Icons.error_outline,
                                                positiveCallback: () {},
                                                positiveText: StringFile.OK);
                                          } else if (!CPF
                                              .isValid(controller.text)) {
                                            showGenericDialog(
                                                context: context,
                                                title: StringFile.Erro,
                                                description:
                                                    StringFile.cpfInvalido,
                                                iconData: Icons.error_outline,
                                                positiveCallback: () {},
                                                positiveText: StringFile.OK);
                                          } else {
                                            var profileBloc =
                                                Modular.get<ProfileBloc>();
                                            profileBloc.updateCpf(
                                                context, controller, () {
                                              Navigator.pop(context, true);
                                            });
                                          }
                                        },
                                        child: Text(
                                          StringFile.Cancelar,
                                          style: AppThemeUtils.normalBoldSize(
                                            color: AppThemeUtils.whiteColor,
                                          ),
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                          bottom: 10,
                                          top: 5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppThemeUtils.colorPrimary,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)))),
                                        onPressed: () {},
                                        child: Text(
                                          StringFile.confirmar,
                                          style: AppThemeUtils.normalBoldSize(
                                            color: AppThemeUtils.whiteColor,
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))),
        ));
  }
}
