import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  final String title;
  const HelpCenterPage({Key key, this.title = "HelpCenter"}) : super(key: key);

  @override
  _HelpCenterPageState createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
