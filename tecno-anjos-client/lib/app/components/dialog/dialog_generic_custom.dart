import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/components/dialog/type_popup.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

void showGenericDialogCustom({IconData iconData,
  String title,
  String subtitle, BuildContext context,
  VoidCallback positiveCallback,
  VoidCallback negativeCallback,
  String positiveText,
  String negativeText,
  Color color,
  bool hideSubTitle = true,
  bool isLight = false}) {
  TypePopup.show(
      child: _DialogGeneric(
          iconData: iconData,
          title: title,
          positiveCallback: positiveCallback,
          negativeCallback: negativeCallback,
          positiveText: positiveText,
          subtitle: subtitle,
          negativeText: negativeText,
          color: color,
          isLight: isLight,
          hideSubTitle: hideSubTitle)
  );
}

class _DialogGeneric extends StatelessWidget {
  final IconData iconData;
  final String title;

  final VoidCallback positiveCallback;
  final VoidCallback negativeCallback;
  final String positiveText;
  final String negativeText;
  final Color color;
  final String subtitle;
  final bool hideSubTitle;
  final bool isLight;

  _DialogGeneric({this.iconData,
    this.title,
    this.positiveCallback,
    this.negativeCallback,
    this.positiveText,
    this.negativeText,
    this.color,
    this.isLight = true,
    this.subtitle,
    this.hideSubTitle = true});

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
              child: Material(
                color: Colors.white,
                child: ListBody(
                  children: <Widget>[
                    Container(
                        color: AppThemeUtils.colorPrimary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 0),
                              child: Icon(
                                iconData,
                                color: color ?? AppThemeUtils.whiteColor,
                                size: 50,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 0, bottom: 10, right: 10, left: 10),
                                child: Text(
                                  title,
                                  style: AppThemeUtils.normalBoldSize(
                                      color: color ?? AppThemeUtils.whiteColor,
                                      fontSize: 16),
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
                          lineViewWidget(),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                positiveCallback == null
                                    ? SizedBox()
                                    : Container(
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
                                              Radius.circular(5))),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      positiveCallback();
                                    },
                                    child: Text(
                                      positiveText ?? StringFile.sim,
                                      style: AppThemeUtils.normalBoldSize(
                                        color: isLight
                                            ? AppThemeUtils.colorPrimary
                                            : AppThemeUtils.whiteColor,
                                      ),
                                    ),

                                  ),
                                ),
                                lineViewWidget(),
                                negativeCallback == null
                                    ? SizedBox()
                                    : Container(
                                  margin: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                      bottom: 10,
                                      top: 10),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: isLight
                                            ? Colors.transparent
                                            : AppThemeUtils.colorError,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            side: BorderSide(
                                                color: isLight
                                                    ? Colors.transparent
                                                    : AppThemeUtils
                                                    .colorError,
                                                width: 1)),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        negativeCallback();
                                      },
                                      child: Text(
                                        negativeText ?? StringFile.nao,
                                        style: AppThemeUtils.normalBoldSize(
                                          color: isLight
                                              ? AppThemeUtils.colorPrimary
                                              : AppThemeUtils.whiteColor,
                                        ),
                                      )
                                  ),
                                ),
                                lineViewWidget(),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 10, left: 10, bottom: 10, top: 10),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: AppThemeUtils.whiteColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              side: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        StringFile.cancelar,
                                        style: AppThemeUtils.normalBoldSize(
                                          color: AppThemeUtils.colorPrimary,
                                        ),
                                      )
                                  ),
                                ),
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
