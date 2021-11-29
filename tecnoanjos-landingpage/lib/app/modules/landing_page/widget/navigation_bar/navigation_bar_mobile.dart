import 'package:flutter/material.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';

import 'navbar_logo.dart';


class NavigationBarMobile extends StatelessWidget {
  final bool inverseColor;
  const NavigationBarMobile(this.inverseColor,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu,color: AppThemeUtils.colorPrimary,),
            onPressed: () {
            Scaffold.of(context).openDrawer();
            },
          ),
          NavBarLogo(inverseColor)
        ],
      ),
    );
  }
}
