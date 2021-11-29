import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/card_web_with_title.dart';
import '../../attendance_bloc.dart';
import '../attendance_builder.dart';

Widget attendanceWebPageWidget(BuildContext context,AttendanceBloc attendanceBloc) {
  return CardWebWithTitle(child:  Container(
    height: MediaQuery.of(context).size.height,
    child:    AttendanceBuilder().buildBodyAttendance(),));
}
