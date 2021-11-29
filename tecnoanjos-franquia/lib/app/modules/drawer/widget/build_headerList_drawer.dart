import 'package:tecnoanjos_franquia/app/app_bloc.dart';
import 'package:tecnoanjos_franquia/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjos_franquia/app/components/gradient_container.dart';
import 'package:tecnoanjos_franquia/app/models/current_user.dart';

import 'package:tecnoanjos_franquia/app/utils/image/image_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

Container buildHeaderListDrawer(
    BuildContext context, double width, EdgeInsets padding, AppBloc appBloc) {
  return gradientContainer(
    child: Container(
        padding: padding,
        child: Center(
            child: Column(
          children: [
            getLogoIcon(height: 80),
            lineViewWidget(top: 10, bottom: 10),
        Text(
                      "Franquia",
                      style: AppThemeUtils.normalBoldSize(
                          color: AppThemeUtils.colorPrimary),maxLines: 1,
                    ),
            lineViewWidget(top: 10, bottom: 10)
          ],
        ))),
  );
}
