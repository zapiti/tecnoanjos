import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/widget/mobile/widget/build_content_mobile_attedance.dart';

class SchedulesCalledPage extends StatelessWidget {
  final AttendanceBloc attendanceBloc;
  SchedulesCalledPage(this.attendanceBloc);

  @override
  Widget build(BuildContext context) {
    return buildContentMobileAttendance(
        attendanceBloc, "Não possui agendamentos");
  }
}
