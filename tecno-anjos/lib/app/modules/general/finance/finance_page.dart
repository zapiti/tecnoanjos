import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/finance/widget/mobile/finance_mobile.dart';

class FinancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultPageWidget(
      childMobile: FinanceMobile(),
      childWeb: FinanceMobile(),
    ));
  }
}
