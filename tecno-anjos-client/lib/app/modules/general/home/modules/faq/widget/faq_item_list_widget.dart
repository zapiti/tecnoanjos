import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/faq/models/faq.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class FaqItemListWidget extends StatefulWidget {
  final Faq faq;

  FaqItemListWidget(this.faq);

  @override
  _FaqItemListWidgetState createState() => _FaqItemListWidgetState();
}

class _FaqItemListWidgetState extends State<FaqItemListWidget> {
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        titleDescriptionBigMobileWidget(context,
            title: widget.faq.title, padding: 20, action: () {
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
                  widget.faq.description,
                  style: AppThemeUtils.normalSize(),
                ),
              ),
        lineViewWidget()
      ],
    ));
  }
}
