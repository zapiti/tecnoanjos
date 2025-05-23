import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_icons/flutter_icons.dart';

import 'package:tecnoanjosclient/app/components/dialog/type_popup.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

var _isOpen = false;

void showTextFieldGenericDialog({VoidCallback positiveCallback,
  VoidCallback negativeCallback,
  String title,
  BuildContext context,
  String positiveText,
  TextEditingController controller,
  TextInputType keyboardType,
  String hintText,
  String maxTitle,
  int lines,
  List<TextInputFormatter> inputFormatters,
  IconData icon,
  String erroText,
  int minSize}) {
  controller.text = "";
  if (!_isOpen) {
    TypePopup.show(
        context: context,
        child: _DialogGeneric(
          positiveCallback: positiveCallback,
          negativeCallback: negativeCallback,
          icon: icon,
          controller: controller,
          masterTitle: maxTitle,
          inputFormatters: inputFormatters,
          lines: lines,
          hintText: hintText,
          minSize: minSize,
          erroText: erroText,
          keyboardType: keyboardType,
          title: title,
          positiveText: positiveText,
        ));
  } else {
    _isOpen = true;
  }
}

class _DialogGeneric extends StatefulWidget {
  final VoidCallback positiveCallback;
  final VoidCallback negativeCallback;
  final TextEditingController controller;
  final String title;
  final String positiveText;
  final int lines;
  final int minSize;
  final String hintText;
  final String masterTitle;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final erroText;

  _DialogGeneric({this.positiveCallback,
    this.icon,
    this.negativeCallback,
    this.title,
    this.controller,
    this.keyboardType,
    this.positiveText,
    this.lines,
    this.masterTitle,
    this.hintText,
    this.inputFormatters,
    this.minSize,
    this.erroText});

  @override
  __DialogGenericState createState() => __DialogGenericState();
}

class __DialogGenericState extends State<_DialogGeneric> {
  String error;

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
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: ListBody(children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(color: Colors.white, width: 0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                        color: AppThemeUtils.colorPrimary,
                                        border: Border.all(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20))),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5, left: 0),
                                          child: Icon(
                                            MaterialCommunityIcons
                                                .file_document_edit,
                                            color: AppThemeUtils.whiteColor,
                                            size: 30,
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                top: 20, bottom: 20, left: 3),
                                            child: Text(
                                              widget.masterTitle ??
                                                  StringFile.dadosCadastrais,
                                              style:
                                              AppThemeUtils.normalBoldSize(
                                                  color: AppThemeUtils
                                                      .whiteColor,
                                                  fontSize: 18),
                                            )),
                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.only(top: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Text(
                                          widget.title,
                                          style: AppThemeUtils.normalSize(),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                              bottom: 10,
                                              top: 5),
                                          child: TextField(
                                            keyboardType: widget.keyboardType,
                                            controller: widget.controller,
                                            maxLines: widget.lines,
                                            inputFormatters:
                                            widget.inputFormatters,
                                            onChanged: (text) {
                                              if (error != null) {
                                                setState(() {
                                                  error = null;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                hintText: widget.hintText,
                                                errorText: error,
                                                border:
                                                const OutlineInputBorder(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.3),
                                                )),
                                          )),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: Center(
                                                    child: Container(
                                                        height: 45,
                                                        width: 200,
                                                        margin: EdgeInsets.only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 10,
                                                            top: 5),
                                                        child: Container(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                              primary: AppThemeUtils
                                                                  .colorError,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .all(
                                                                      Radius
                                                                          .circular(
                                                                          8)),
                                                                  side: BorderSide(
                                                                      color: AppThemeUtils
                                                                          .colorError,
                                                                      width: 1)),),

                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              StringFile
                                                                  .cancelar,
                                                              style: AppThemeUtils
                                                                  .normalBoldSize(
                                                                color: AppThemeUtils
                                                                    .whiteColor,
                                                              ),
                                                            ),

                                                          ),
                                                        )))),
                                            Expanded(
                                                child: Center(
                                                    child: Container(
                                                        height: 45,
                                                        width: 200,
                                                        margin: EdgeInsets.only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 10,
                                                            top: 5),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                              primary: AppThemeUtils
                                                                  .colorPrimary,
                                                              elevation: 0,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .all(
                                                                      Radius
                                                                          .circular(
                                                                          8)))),
                                                          onPressed: () {
                                                            if (widget
                                                                .minSize ==
                                                                null) {
                                                              widget
                                                                  .positiveCallback();
                                                            } else {
                                                              if (widget
                                                                  .minSize <
                                                                  widget
                                                                      .controller
                                                                      .text
                                                                      .length) {
                                                                widget
                                                                    .positiveCallback();
                                                              } else {
                                                                setState(() {
                                                                  error = widget
                                                                      .erroText;
                                                                });
                                                              }
                                                            }
                                                          },
                                                          child: AutoSizeText(
                                                            StringFile
                                                                .confirmar,
                                                            maxLines: 1,
                                                            style: AppThemeUtils
                                                                .normalBoldSize(
                                                              color: AppThemeUtils
                                                                  .whiteColor,
                                                            ),
                                                          ),

                                                        )))),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]))))));
  }
}
