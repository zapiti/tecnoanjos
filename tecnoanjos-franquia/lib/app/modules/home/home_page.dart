import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/components/page/default_tab_page.dart';
import 'package:tecnoanjos_franquia/app/modules/default_page/default_page_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: Container(),
      childWeb: Container(),
    );
  }
}
