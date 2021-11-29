import 'package:flutter/material.dart';
import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';

import 'registre_franquise/widget/body_registre_fraquise.dart';

class RegistreFranquise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(color: AppThemeUtils.colorPrimary,child: LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          (constraints.maxWidth > 1100) ?  Expanded(child: Container(child:  Column(
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
          ),)):SizedBox(),
          Expanded(
              child: Center(
                  child: Container(
                      width: 500,
                      height: 1100,
                      child: Card(
                        child: bodyRegistreFranquise(context),
                      )))),
        ],
      );
    })));
  }
}
