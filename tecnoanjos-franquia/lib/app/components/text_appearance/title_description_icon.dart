
import 'package:flutter/material.dart';
import '../../utils/theme/app_theme_utils.dart';

Widget titleDescriptionIcon(
    BuildContext context, String icon, String subtitle,
    {Color colorIcon, Color colorText, Color colorTitle, String title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset(
        icon,
        color: Theme.of(context).primaryColor,width: 100,height: 100,scale: 0.5,

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
        margin: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: AppThemeUtils.normalSize(
            color: colorText ?? colorIcon, fontSize: 16),
      )))
    ],
  );
}
