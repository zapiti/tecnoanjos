import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:tecnoanjosclient/app/components/dialog/type_popup.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../gradient_container.dart';

void showNewAttendanceDialog({VoidCallback positiveCallback,
  VoidCallback negativeCallback,
  String positiveText,
  BuildContext context,
  MoneyMaskedTextController valueController,
  TextEditingController nameController,
  TextEditingController quantityController}) {
  nameController?.text = "";
  valueController?.updateValue(0);
  TypePopup.show(
      context: context,
      child: _DialogGeneric(
          positiveCallback: positiveCallback,
          negativeCallback: negativeCallback,
          nameController: nameController,
          valueController: valueController,
          quantityController: quantityController));
}

class _DialogGeneric extends StatelessWidget {
  final VoidCallback positiveCallback;
  final VoidCallback negativeCallback;
  final TextEditingController nameController;
  final MoneyMaskedTextController valueController;
  final TextEditingController quantityController;

  _DialogGeneric({this.positiveCallback,
    this.nameController,
    this.negativeCallback,
    this.valueController,
    this.quantityController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width > 450
                  ? 400
                  : MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
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
                                  StringFile.atendimentoCustom,
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                      horizontal: 20, vertical: 5),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    controller: nameController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                        hintText: StringFile.nomeServico,
                                        labelText: StringFile.nomeServico,
                                        border: const OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.3),
                                        )),
                                  )),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                    StringFile.valorParaServico,
                                    style: AppThemeUtils.normalBoldSize(
                                        color: AppThemeUtils.colorPrimary),
                                  ))),
                          lineViewWidget(),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: negativeCallback == null
                                        ? SizedBox()
                                        : Container(
                                      margin: EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppThemeUtils.colorError,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(5)),
                                                side: BorderSide(
                                                    color: AppThemeUtils
                                                        .colorError,
                                                    width: 1))),

                                        onPressed: () {
                                          negativeCallback();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          StringFile.cancelar,
                                          style: AppThemeUtils
                                              .normalBoldSize(
                                            color:
                                            AppThemeUtils.whiteColor,
                                          ),
                                        ),

                                      ),
                                    )),
                                Expanded(
                                    child: positiveCallback == null
                                        ? SizedBox()
                                        : Container(
                                      margin: EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppThemeUtils.colorPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(5)))),
                                        onPressed: () {
                                          if (quantityController.text ==
                                              "0" ||
                                              quantityController.text ==
                                                  "") {
                                            quantityController.text = "1";
                                          }
                                          if (nameController
                                              .text.isNotEmpty) {
                                            positiveCallback();
                                          }
                                        },
                                        child: AutoSizeText(
                                          StringFile.confirmar,
                                          maxLines: 1,
                                          minFontSize: 8,
                                          style: AppThemeUtils
                                              .normalBoldSize(
                                            color:
                                            AppThemeUtils.whiteColor,
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
    );
  }
}
