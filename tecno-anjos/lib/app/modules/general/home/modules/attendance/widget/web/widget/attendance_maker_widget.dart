import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/card/card_web_widget.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../attendance_bloc.dart';
import '../../attendance_builder.dart';

class AttendanceMakerWidget extends StatelessWidget {
  final AttendanceBloc blocAttendance;

  AttendanceMakerWidget(this.blocAttendance);

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
                'ATENDIMENTOS FEITOS',
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
            child: AttendanceBuilder().buildContentPageAttendance(
              blocAttendance.totalAttendance,
              blocAttendance.listAttendanceInfo,
              (page) => blocAttendance.getListAttendance(page: page),
              "Sem atendimento realizados",
            ),
            height: 450,
          )
        ],
      ),
    );
  }
}
