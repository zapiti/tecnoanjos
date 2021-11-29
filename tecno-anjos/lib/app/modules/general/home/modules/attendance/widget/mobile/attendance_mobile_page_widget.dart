import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/widget/attendance_builder.dart';

Widget attendanceMobilePageWidget(AttendanceBloc attendanceBloc) {
  return  AttendanceBuilder().buildBodyAttendance();
}
