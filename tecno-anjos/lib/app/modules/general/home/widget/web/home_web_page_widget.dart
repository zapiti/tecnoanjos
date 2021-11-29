import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/widget/attendance_builder.dart';

Widget homeWebPageWidget(DrawerBloc drawerBloc, AppBloc appBloc) {
  var _attendanceBloc = Modular.get<AttendanceBloc>();
  return AttendanceBuilder().buildContentPageAttendance(
    _attendanceBloc.totalSchedule,
    _attendanceBloc.listScheduleInfo,

    (page) => _attendanceBloc.getListSchedule(page: page),
    "Sem atendimento agendado",
  );
}
