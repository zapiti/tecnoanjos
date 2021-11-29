import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/gradient_container.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import 'builder_attendance_list_header.dart';

Widget buildContentMobileAttendance(AttendanceBloc attendanceBloc, String empty,
    {String status}) {
  return Column(children: [
    StreamBuilder<int>(
        stream: attendanceBloc.totalSchedule.stream,
        builder: (context, content) => (content?.data ?? 0) == 0
            ? SizedBox()
            : gradientContainer(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Text(
                              StringFile.vocePossui+' ${content?.data ?? 0} '+StringFile.agendamentosMaiusculo,
                              style: AppThemeUtils.normalSize(
                                  color: AppThemeUtils.whiteColor),
                            )),
                      ],
                    )))),
    lineViewWidget(),
    Expanded(
        child: builderComponent<ResponsePaginated>(
            stream: attendanceBloc.listScheduleInfo.stream,
            emptyMessage: empty,
            initCallData: () => { },
            buildBodyFunc: (context, response) => BuilderAttendanceListHeader(
                ObjectUtils.parseToObjectList<Attendance>(response.content))
            ))
  ]);
}
