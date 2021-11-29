

import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/page/default_tab_page.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'widget/plans/plans_widget.dart';
import 'widget/services/services_widget.dart';

class PlainsMobilePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabPage(
      null,
      title: [
        StringFile.planos,
        StringFile.pacotes,
      ],
      changeTab: (tabController) {

      },
      page: [
        PlansWidget(),
        ServicesWidget()

      ],
    );
  }
}
