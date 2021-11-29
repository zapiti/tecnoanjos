

import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class TitleHoursWidget extends StatelessWidget {
  final String hours;
  TitleHoursWidget(this.hours);
  @override
  Widget build(BuildContext context) {
    return Container(


      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
            color:  AppThemeUtils.colorPrimary,
            width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
      child: Row(
      children: [
       Expanded(child:Text("Você possuí",style: AppThemeUtils.bigBoldSize(fontSize: 14),)),
        Text(hours,style: AppThemeUtils.normalBoldSize(color: AppThemeUtils.colorPrimary),)
      ],
    ),);
  }
}
