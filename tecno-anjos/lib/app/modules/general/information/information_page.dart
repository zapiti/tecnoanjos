import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';

import 'widget/mobile/information_mobile.dart';


class InformationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: DefaultPageWidget(
          childMobile: InformationMobile(),
          childWeb: InformationMobile(),
        ));
  }
}
