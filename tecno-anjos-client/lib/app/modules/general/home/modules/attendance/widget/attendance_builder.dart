import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjosclient/app/components/gradient_container.dart';

import 'package:tecnoanjosclient/app/components/page/default_tab_page.dart';
import 'package:tecnoanjosclient/app/components/text_appearance/title_description_icon.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../attendance_bloc.dart';
import 'attendance_item_list_widget.dart';

class AttendanceBuilder {
  final _attendanceBloc = Modular.get<AttendanceBloc>();
  TabController _tab;

  Widget buildBodyAttendance() {
    return DefaultTabPage(
      _tab,
      title: [
        StringFile.recebidos,
        StringFile.agendados,
        StringFile.cancelados,
      ],
      page: [
        buildContentPageAttendance(
          _attendanceBloc.totalAttendance,
          _attendanceBloc.listAttendanceInfo.stream,
          (page) => _attendanceBloc.getListAttendance(page: page),
          StringFile.semAtendimentoRealizado,
          status: ActivityUtils.FINALIZADO,
        ),
        buildContentPageAttendance(
            _attendanceBloc.totalSchedule,
            _attendanceBloc.listScheduleInfo.stream,
            (page) => _attendanceBloc.getListSchedule(page: page),
            StringFile.semAtendimentoAgendado,
            status: ActivityUtils.PENDENTE),
        buildContentPageAttendance(
            _attendanceBloc.totalCancel,
            _attendanceBloc.listCancelInfo.stream,
            (page) => _attendanceBloc.getListCancel(page: page),
            StringFile.semAtendimentoCancelado,
            status: ActivityUtils.CANCELADO),
      ],
    );
  }

  Widget buildContentPageAttendance(Stream streamTotoal, Stream streamData,
      Function actionReload, String empty,
      {String status}) {
    return Column(children: [
      gradientContainer(
          child: Row(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: streamTotoal,
                  builder: (context, content) => Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: titleDescriptionIcon(
                          context,
                          Icons.assignment,
                          ActivityUtils.CANCELADO == status
                              ? StringFile.agendamentosCancelados
                              : ActivityUtils.FINALIZADO == status
                                  ? StringFile.agendamentosRealizados
                                  : StringFile.agendamentosAgendamentos,
                          colorText: AppThemeUtils.whiteColor,
                          colorIcon: AppThemeUtils.whiteColor,
                          title: "${content?.data ?? 0} ")))),
        ],
      )),
      Expanded(
          child: builderComponent<ResponsePaginated>(
              stream: streamData,
              emptyMessage: empty,
              initCallData: () => actionReload(0),
              // tryAgain: () {
              //   actionReload(0);
              // },
              buildBodyFunc: (context, response) =>
                  builderInfinityListViewComponent(response,
                      callMoreElements: (page) {
                        actionReload(page);
                      },
                      buildBody: (content) => attendanceItemListWidget(
                          context, content, status,
                          showline: true))))
    ]);
  }
}
