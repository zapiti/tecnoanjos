import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Widget itemNewPaymentForm() {
  return Container(
      color: AppThemeUtils.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: InkWell(
          onTap: () {},
          child: Flex(direction: Axis.horizontal, children: <Widget>[
            Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(48.0),
                    child: Container(
                      color: AppThemeUtils.colorPrimary,
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.hourglass_empty,
                        color: AppThemeUtils.whiteColor,
                      ),
                    ))),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  "Outro cartão",
                  style: AppThemeUtils.normalBoldSize(
                      color: AppThemeUtils.colorPrimary, fontSize: 18),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppThemeUtils.colorPrimary,
              ),
            )
          ])));
}
