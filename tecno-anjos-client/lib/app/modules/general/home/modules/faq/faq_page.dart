import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/faq/widget/mobile/faq_mobile_widget%202.dart';


class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: FaqMobileWidget(),
      childWeb: FaqMobileWidget(),
    );
  }
}
