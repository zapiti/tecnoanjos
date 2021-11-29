import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/widget/tecno_widget.dart';

class TecnoPage extends StatefulWidget {
  final String title;
  const TecnoPage({Key key, this.title = "Tecno"}) : super(key: key);

  @override
  _TecnoPageState createState() => _TecnoPageState();
}

class _TecnoPageState extends State<TecnoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: TecnoWidget(),
      childWeb: TecnoWidget(),
    );
  }
}
