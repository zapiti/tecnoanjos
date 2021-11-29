import 'package:flutter/cupertino.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Widget gradientContainer({Widget child}) {
  return new Container(
    decoration: new BoxDecoration(
      gradient: new LinearGradient(
          colors: [
            AppThemeUtils.colorPrimary,
            AppThemeUtils.colorPrimaryDark,
          ],
          begin: const FractionalOffset(0.5, 0.0),
          end: const FractionalOffset(0.0, 0.5),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    ),
    child: child,
  );
}
