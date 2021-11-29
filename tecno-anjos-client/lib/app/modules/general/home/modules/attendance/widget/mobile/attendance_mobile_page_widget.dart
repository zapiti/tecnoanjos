import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../attendance_bloc.dart';
import '../attendance_builder.dart';




Widget attendanceMobilePageWidget(AttendanceBloc attendanceBloc) {
  return  AttendanceBuilder().buildBodyAttendance();
}
