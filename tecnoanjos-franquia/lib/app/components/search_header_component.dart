import 'package:tecnoanjos_franquia/app/components/tectfields/custom_textfield.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'card/card_web_widget.dart';

Widget searchHeaderComponent(BuildContext context,
    {String hint,
    VoidCallback clickView,
    ValueChanged<String> onChange,
    TextEditingController controller}) {
  return CardWebWidget(
      child: Container(
        height: 45,
        child: Flex(direction: Axis.horizontal, children: [
          Expanded(
              child: CustomTextField(
            autofocus: false,
            controller: controller,

              hintText: hint,

            textCapitalization: TextCapitalization.none,
            onChanged: onChange,
          )),
          Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppThemeUtils.colorPrimary),
            child: InkWell(
                onTap: clickView,
                child: Icon(
                  Icons.search,
                  color: AppThemeUtils.colorPrimaryDark,
                )),
          )
        ]),
      ));
}
