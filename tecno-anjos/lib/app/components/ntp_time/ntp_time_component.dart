import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';

class NtpTimeComponent extends StatefulWidget {
  final Function(BuildContext, DateTime) buildTime;
  final bool periodic;

  NtpTimeComponent({this.buildTime, this.periodic = false});

  @override
  _NtpTimeComponentState createState() => _NtpTimeComponentState();
}

class _NtpTimeComponentState extends State<NtpTimeComponent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.periodic) {
      Timer.periodic(Duration(seconds: 3), (Timer t) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
          return  widget.buildTime(context, MyDateUtils.getTrueTime() );

  }
}
