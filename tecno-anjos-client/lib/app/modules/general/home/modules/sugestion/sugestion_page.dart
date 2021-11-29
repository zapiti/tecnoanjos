import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';

import 'mobile/sugestions_mobile.dart';

class SugestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: SugestionsMobile(),
      childWeb: SugestionsMobile(),
    );
  }
}