
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

class ResumeCard extends StatefulWidget {
  final Attendance calling;
  final Color color;
  ResumeCard(this.calling, {this.color = Colors.white});


  @override
  _ResumeCardState createState() => _ResumeCardState();
}

class _ResumeCardState extends State<ResumeCard> {
  bool showMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Card(
            color: AppThemeUtils.colorPrimary,
            child:  Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  children: [
                    widget.calling?.address == null ?SizedBox():  Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                            "Local: ${getValueAddress(widget.calling)}",
                            maxLines: 1,
                            style: AppThemeUtils.normalSize(
                                fontSize: 14,color: AppThemeUtils.whiteColor))),
                    widget.calling.hourAttendance == null ?SizedBox():    Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child:Text(
                            "Agendamento: ${MyDateUtils.parseDateTimeFormat(widget.calling.hourAttendance,null, format: "dd/MM/yyyy <> HH:mm")?.replaceAll("<>", "ás") ?? "--"}",
                            maxLines: 1,
                            style: AppThemeUtils.normalSize(
                                fontSize: 14,color: AppThemeUtils.whiteColor)))
                  ],
                ))));

  }
}
getValueAddress( Attendance data) {
  if (data?.address == null) {
    return "--";
  } else {
    return "${Utils?.addressFormatMyData(data?.address)}";
  }
}

