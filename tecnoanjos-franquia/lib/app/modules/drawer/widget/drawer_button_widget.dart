import 'package:tecnoanjos_franquia/app/modules/drawer/widget/semi_circle.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
    @required this.active,
    @required this.context,
    @required this.title,
    @required this.iconData,
    @required this.onPressed,
  }) : super(key: key);

  final bool active;
  final BuildContext context;
  final VoidCallback onPressed;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {

    return semiCircleWidget(
        48, active ? Theme.of(context).primaryColor : Colors.transparent,
        child: FlatButton(
          onPressed: onPressed,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 12, bottom: 12, right: 22),
              child: Row(children: [
                Icon(
                  iconData,
                  size: 24,
                  color: active
                      ? AppThemeUtils.whiteColor
                      : AppThemeUtils.iconColor,
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  title,
                  style: AppThemeUtils.normalSize(
                      color: active
                          ? AppThemeUtils.whiteColor
                          : Theme.of(context).textTheme.bodyText1.color),
                ),
              ]),
            ),
          ),
        ));
  }
}
