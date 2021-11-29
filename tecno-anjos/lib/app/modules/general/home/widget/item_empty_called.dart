import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Widget itemEmptyCalled() {
  return Container(
      color: AppThemeUtils.lightGray,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: InkWell(
          onTap: () {

          },
          child: Flex(direction: Axis.horizontal, children: <Widget>[
            Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(48.0),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.hourglass_empty,
                        color: AppThemeUtils.lightGray,
                      ),
                    ))),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                StringFile.voceNaoPossuiAtendimento,
                maxLines: 2,
                style: AppThemeUtils.normalBoldSize(
                    color: AppThemeUtils.whiteColor, fontSize: 18),
              ),
            )),
          ])));
}
