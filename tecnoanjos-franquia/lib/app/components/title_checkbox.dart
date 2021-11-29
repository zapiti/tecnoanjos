import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';


Widget titleCheckBox(BuildContext context,
    {bool intialstate = false,
    ValueChanged<bool> handleChecked,
    String title}) {
  return InkWell(
      onTap: () {
        handleChecked(!intialstate);
      },
      child: Container(
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.only(right: 5),
                  child: Checkbox(
                    value: intialstate,
                    activeColor: Colors.grey[300],
                    checkColor: Theme.of(context).primaryColor,
                    onChanged: handleChecked,
                  )),
              Text(
                title,
                textAlign: TextAlign.start,
                style: AppThemeUtils.normalSize(
                    color: AppThemeUtils.colorText),
              ),
            ],
          )
        ]),
      ));
}
