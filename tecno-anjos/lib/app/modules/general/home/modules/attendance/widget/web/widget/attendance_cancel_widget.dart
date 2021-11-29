import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/card/card_web_widget.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import '../../../attendance_bloc.dart';
import '../../attendance_builder.dart';

class AttendanceCancelWidget extends StatelessWidget {
  final AttendanceBloc blocAttendance;

  AttendanceCancelWidget(this.blocAttendance);

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
                'ATENDIMENTOS CANCELADOS',
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
            child: AttendanceBuilder().buildContentPageAttendance(
              blocAttendance.totalCancel,
              blocAttendance.listCancelInfo,
              (page) => blocAttendance.getListCancel(page: page),
              "Sem atendimento cancelado",
            ),
            height: 450,
          )
        ],
      ),
    );
  }
}
