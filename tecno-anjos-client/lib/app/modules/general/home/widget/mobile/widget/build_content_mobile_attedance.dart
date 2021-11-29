import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/gradient_container.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'builder_attendance_list_header.dart';

Widget buildContentMobileAttendance(AttendanceBloc attendanceBloc, String empty,
    {String status}) {
  return Column(children: [
    StreamBuilder(
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
                              'VOCÊ POSSUI ${content?.data ?? 0} AGENDAMENTOS',
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
            // tryAgain: () {
            //   attendanceBloc.getListSchedule();
            // },
            initCallData: () => {},
            buildBodyFunc: (context, response) => BuilderAttendanceListHeader(
                ObjectUtils.parseToObjectList<Attendance>(response.content))
//                builderInfinityListViewComponent(response,
//                    callMoreElements: (page) {
//                      actionReload(page);
//                    },
//                    buildBody: (content) =>
//                        attendanceItemInitWidget(context, content, status))
            ))
  ]);
}
