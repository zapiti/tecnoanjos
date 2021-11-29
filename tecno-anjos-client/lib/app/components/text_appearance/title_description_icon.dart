import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Widget titleDescriptionIcon(
    BuildContext context, IconData icon, String subtitle,
    {Color colorIcon, Color colorText, Color colorTitle, String title}) {
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
                  child: Text(
              title,
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
              child: Text(
        subtitle ?? "-",
        textAlign: TextAlign.center,
        style: AppThemeUtils.normalSize(
            color: colorText ?? colorIcon, fontSize: 14),
      )))
    ],
  );
}
