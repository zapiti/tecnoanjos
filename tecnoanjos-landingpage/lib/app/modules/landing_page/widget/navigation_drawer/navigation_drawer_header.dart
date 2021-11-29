import 'package:flutter/material.dart';
import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';


class NavigationDrawerHeader extends StatelessWidget {
  const NavigationDrawerHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: AppThemeUtils.colorPrimary,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            ImagePath.imageAureula,
            width: 60,
            height: 60,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '',
            style: AppThemeUtils.normalBoldSize(color: AppThemeUtils.whiteColor),
          ),

        ],
      ),
    );
  }
}
