
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';

import 'widget/mobile/plains_mobile_page_widget.dart';
import 'widget/web/plains_web_page_widget.dart';

class PlainsServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: PlainsMobilePageWidget(),
      childWeb: PlainsWebPageWidget(),
    );
  }
}
