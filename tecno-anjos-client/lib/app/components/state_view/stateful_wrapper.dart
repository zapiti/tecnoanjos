import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Function onDidUpdate;
  final Widget child;
  const StatefulWrapper(
      {@required this.onInit, @required this.child, this.onDidUpdate});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.onInit != null) {
        widget.onInit();
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(StatefulWrapper oldWidget) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.onDidUpdate != null) {
        widget.onDidUpdate();
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
