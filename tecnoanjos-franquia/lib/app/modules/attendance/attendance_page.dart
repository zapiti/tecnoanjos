import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/widget/attendance_widget.dart';
import 'package:tecnoanjos_franquia/app/modules/default_page/default_page_widget.dart';

class AttendancePage extends StatefulWidget {
  final String title;
  const AttendancePage({Key key, this.title = "Attendance"}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: AttendanceWidget(),
      childWeb: AttendanceWidget(),
    );
  }
}
