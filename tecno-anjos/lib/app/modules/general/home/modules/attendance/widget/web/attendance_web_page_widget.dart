import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/card_web_with_title.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import '../attendance_builder.dart';

Widget attendanceWebPageWidget(BuildContext context,AttendanceBloc attendanceBloc) {
  return CardWebWithTitle(child:  Container(
      height: MediaQuery.of(context).size.height,
  child:    AttendanceBuilder().buildBodyAttendance(),));

}
