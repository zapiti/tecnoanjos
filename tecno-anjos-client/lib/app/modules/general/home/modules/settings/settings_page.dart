import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/settings/widget/mobile/settings_mobile_page_widget.dart';


// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile:
          SettingsMobilePageWidget(),
      childWeb: SettingsMobilePageWidget(),
    );
  }
}
