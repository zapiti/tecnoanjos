import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';


import 'widget/mobile/faq_mobile_widget.dart';

class FaqPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  DefaultPageWidget(
      childMobile: FaqMobileWidget(),
      childWeb: FaqMobileWidget(),
    );
  }
}
