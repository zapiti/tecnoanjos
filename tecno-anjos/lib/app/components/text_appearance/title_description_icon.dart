import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Widget titleDescriptionIcon(
    BuildContext context, IconData icon, String subtitle,
    {Color colorIcon, Color colorText, Color colorTitle, String title, double fontSize = 14,int maxline = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        icon,
        color: colorIcon,
      ),
      SizedBox(
        height: title != null ? 5 : 10,
      ),
      title != null
          ? Container(
              child: Center(
                  child: AutoSizeText(
              title,maxLines: 1,
                    minFontSize: 6,
              textAlign: TextAlign.center,
              style: AppThemeUtils.normalSize(
                  color: colorTitle ?? colorIcon, fontSize: 16),
            )))
          : SizedBox(),
      SizedBox(
        height: title != null ? 5 : 0,
      ),
      Container(
          child: Center(
              child: AutoSizeText(
        subtitle,maxLines: maxline,
        minFontSize: 6,
        textAlign: TextAlign.center,
        style: AppThemeUtils.normalSize(
            color: colorText ?? colorIcon, fontSize: fontSize),
      )))
    ],
  );
}
