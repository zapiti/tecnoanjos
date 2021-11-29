import 'dart:async';

import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/utils/date_utils.dart';

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
      Timer.periodic(Duration(seconds: 5), (Timer t) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime>(
        future: MyDateUtils.getTrueTime(),
        builder: (context, snapshotTime) {
          var _myTime = snapshotTime.data;
          // Future.delayed(Duration(seconds: 2), () {
          //   SchedulerBinding.instance.addPostFrameCallback((_) {
          //     if (mounted) {
          //       if (_myTime == null) {
          //         setState(() {});
          //       }
          //     }
          //   });
          // });
          return  widget.buildTime(context, _myTime );
        });
  }
}
