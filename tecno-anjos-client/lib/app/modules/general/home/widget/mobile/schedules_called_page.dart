import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/widget/mobile/widget/build_content_mobile_attedance.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

class SchedulesCalledPage extends StatelessWidget {
  final AttendanceBloc attendanceBloc;
  SchedulesCalledPage(this.attendanceBloc);

  @override
  Widget build(BuildContext context) {

    return StatefulWrapper(onInit: (){
      attendanceBloc.getListSchedule();
    }, child:  buildContentMobileAttendance(
        attendanceBloc,StringFile.naoPossuiAgendamento));
  }
}
