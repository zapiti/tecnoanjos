import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/components/divider/line_view_widget.dart';
import 'package:flutter/rendering.dart';

import '../../utils/theme/app_theme_utils.dart';

Widget titleDescriptionMobileWidget(BuildContext context,
    {String title,
    String description,
    GestureTapCallback action,
    Widget customDescription,
    EdgeInsets customPadding,double secundaryFontSyze =14.0,double primaryFontSyze =14.0,Color secundaryColor,Color primaryColor,
    Widget customIcon}) {
  return InkWell(
    onTap: action,
    child: Container(
        padding: customPadding ?? EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
                margin:  EdgeInsets.symmetric(horizontal: 10),
                child: Text(title ?? "",
                    style: AppThemeUtils.normalBoldSize(fontSize: primaryFontSyze,color: primaryColor))),
            customDescription ??
                Container(
                    margin:  EdgeInsets.symmetric(horizontal: 10),
                    child: SelectableText(
                      description,
                      style: AppThemeUtils.normalSize(fontSize: secundaryFontSyze,color: secundaryColor),
                    )),
          ],
        )),
  );
}
Widget titleDescriptionSimpleMobileWidget(BuildContext context,
    {String title,
      String description,
      VoidCallback action,
      Color color,
      Color descrColor,
      int maxLine = 3,
      bool hideNotDescription = false,
      Widget customTitle,
      iconData,
      EdgeInsets customPadding,
      double padding = 20,
      Widget customIcon,
      double height,double fontSize:14,
      Color backgroundColor, bool hideLine = false}) {
  return  Container(
      margin:  EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                hideNotDescription && description == null
                    ? SizedBox()
                    : customTitle ??
                    AutoSizeText(title ?? "",
                        maxLines: 1,maxFontSize: 16,
                        minFontSize: 10,
                        style: AppThemeUtils.normalSize(
                            color: color ??
                                AppThemeUtils.colorText,fontSize: fontSize)),
                SizedBox(
                  height: 5,
                ),
                description == null
                    ? SizedBox()
                    : AutoSizeText(
                  description,maxLines: 1,maxFontSize: 16,     minFontSize: 10,
                  style: AppThemeUtils.normalBoldSize(
                      color: descrColor ??
                          Theme.of(context).textTheme.bodyText1.color),
                ),]));




}

Widget titleDescriptionBigMobileWidget(BuildContext context,
    {String title,
    String description,
    VoidCallback action,
    Color color,
    Color descrColor,
    int maxLine = 3,
    bool hideNotDescription = false,
    Widget customTitle,
    iconData,
    EdgeInsets customPadding,
    double padding = 20,
    Widget customIcon,
    double height,double fontSize:14,
    Color backgroundColor, bool hideLine}) {
  return InkWell(
    onTap: action,
    child: Container(
        padding: customPadding ?? EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
                margin:  EdgeInsets.only(left: 20),
                child: Text(title ?? "",
                    style: AppThemeUtils.normalSize())),

                Container(
                    margin:  EdgeInsets.symmetric(horizontal: 5),
                    child: SelectableText(
                      description,
                      style: AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
                    )),
          ],
        )),
  );
}
