import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/widget/mobile/attendance_mobile_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/widget/web/attendance_web_page_widget.dart';
import '../../../../../app_bloc.dart';


class AttendancePage extends StatelessWidget {
  final _attendanceBloc = Modular.get<AttendanceBloc>();
  final appBloc = Modular.get<AppBloc>();
  @override
  Widget build(BuildContext context) {

    return DefaultPageWidget(
      childMobile: attendanceMobilePageWidget(_attendanceBloc),
      childWeb: attendanceWebPageWidget(context,_attendanceBloc),
    );
  }
}
