
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';

import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class DetailAttendancePage extends StatelessWidget {
  final Attendance attendanceCaled;
  final attendanceBloc = Modular.get<AttendanceBloc>();

  DetailAttendancePage(this.attendanceCaled);

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
        childMobile: bodyAttendance(context),
        enableBar: false,
        childWeb: bodyAttendance(context));
  }

  Scaffold bodyAttendance(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringFile.detalheAtendimento,style: AppThemeUtils.normalSize(fontSize: 18,color: AppThemeUtils.colorPrimaryClient),),
          centerTitle: true,
        ),
        body: builderComponent<ResponsePaginated>(
            stream: attendanceBloc.detailAttendance,
            emptyMessage: StringFile.semRegistro,
            initCallData: () =>{
              attendanceBloc.detailAttendance.sink.add( ResponsePaginated(content:attendanceCaled)  )
            },
            buildBodyFunc: (context, response) {
              var attendance = response.content;
              return Container(
                height: MediaQuery.of(context).size.height,
                child: ReceiptCard( attendance, true, null),
              );
            }));
  }
}

