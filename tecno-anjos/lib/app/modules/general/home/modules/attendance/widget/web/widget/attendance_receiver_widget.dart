import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/card/card_web_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/widget/attendance_builder.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../attendance_bloc.dart';

class AttendanceReceiverWidget extends StatelessWidget {
  final AttendanceBloc blocAttendance;

  AttendanceReceiverWidget(this.blocAttendance);

  @override
  Widget build(BuildContext context) {
    return cardWebWidget(
      context,
      height: 600,
      child: Flex(
        direction: Axis.vertical,
        children: [
          AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'ATENDIMENTOS AGENDADOS',
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
            child: AttendanceBuilder().buildContentPageAttendance(
              blocAttendance.totalSchedule,
              blocAttendance.listScheduleInfo,
              (page) => blocAttendance.getListSchedule(page: page),
              "Sem atendimento agendado",
            ),
            height: 450,
          )
        ],
      ),
    );
  }
}
