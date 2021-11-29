import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/components/card_web_with_title.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/widget/attendance_builder.dart';

Widget homeWebPageWidget(DrawerBloc drawerBloc, AppBloc appBloc) {
  var blocAttendance = Modular.get<AttendanceBloc>();

  return CardWebWithTitle(onInit:(){blocAttendance.getListAttendance(page: 1);} , child:  Container(
    child: AttendanceBuilder().buildContentPageAttendance(
      blocAttendance.totalAttendance,
      blocAttendance.listAttendanceInfo,
      (page) => blocAttendance.getListAttendance(page: page),
      "Sem atendimento agendados",
    ),
    height: 450,
  ));
}
