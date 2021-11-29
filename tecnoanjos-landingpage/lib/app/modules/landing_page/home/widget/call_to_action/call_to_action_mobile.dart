import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecno_anjos_landing/app/routes/constants_routes.dart';

import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';


class CallToActionMobile extends StatelessWidget {
  final String title;
  const CallToActionMobile(this.title);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
        child:  Container(
      height: 60,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: AppThemeUtils.colorPrimary,
        borderRadius: BorderRadius.circular(5),
      ),
    ));
  }
}
