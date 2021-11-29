import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/widget/mobile/schedules_called_page.dart';


class CurrentPage extends StatelessWidget {


  CurrentPage();

  final attendanceBloc = Modular.get<AttendanceBloc>();

  @override
  Widget build(BuildContext context) {
    return SchedulesCalledPage(attendanceBloc);
  }
}
