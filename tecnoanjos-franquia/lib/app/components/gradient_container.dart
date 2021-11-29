import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/cupertino.dart';

Widget gradientContainer({Widget child}) {
  return new Container(
    decoration: new BoxDecoration(
      gradient: new LinearGradient(
          colors: [
            AppThemeUtils.whiteColor,
            Colors.white30
          ],
          begin: const FractionalOffset(0.8, 0.6),
          end: const FractionalOffset(-1, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    ),
    child: child,
  );
}
