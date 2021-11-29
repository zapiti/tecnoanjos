import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjostec/app/utils/image/image_logo_widget.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class TransitionPage extends StatefulWidget {
  final String title;
  const TransitionPage({Key key, this.title = "Transition"}) : super(key: key);

  @override
  _TransitionPageState createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      AttendanceUtils.pushReplacementNamed(context,ConstantsRoutes.SPLASHPAGE);
    });
  }

  @override
  void didUpdateWidget(TransitionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      AttendanceUtils.pushReplacementNamed(context,ConstantsRoutes.SPLASHPAGE);
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Container(
            color: AppThemeUtils.colorPrimary,
            child: Center(
              child: getLogoIcon(),)
        ))
    ;
  }
}
