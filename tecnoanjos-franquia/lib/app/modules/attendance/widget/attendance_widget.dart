import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/components/card/card_web_widget.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/widget/table/attendance_table.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/widget/table/tecno_table.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

class AttendanceWidget extends StatefulWidget {
  @override
  _AttendanceWidgetState createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  @override
  Widget build(BuildContext context) {
    return CardWebWidget(title: "Atendimentos",
      child: AttendanceTable(),
    );
  }
}
