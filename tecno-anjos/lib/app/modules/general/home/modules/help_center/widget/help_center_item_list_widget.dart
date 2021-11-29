import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/models/help_center.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class HelpCenterItemListWidget extends StatefulWidget {
  final HelpCenter helpCenter;

  HelpCenterItemListWidget(this.helpCenter);

  @override
  _HelpCenterItemListWidgetState createState() =>
      _HelpCenterItemListWidgetState();
}

class _HelpCenterItemListWidgetState extends State<HelpCenterItemListWidget> {
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        titleDescriptionBigMobileWidget(context,
            title: widget.helpCenter.title, padding: 20, action: () {
          setState(() {
            isOpen = !isOpen;
          });
        },
            customIcon: Icon(
              isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppThemeUtils.colorPrimary,
            )),
        !isOpen
            ? SizedBox()
            : Container(
                padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: Text(
                  widget.helpCenter.description,
                  style: AppThemeUtils.normalSize(),
                ),
              ),
        lineViewWidget()
      ],
    ));
  }
}
