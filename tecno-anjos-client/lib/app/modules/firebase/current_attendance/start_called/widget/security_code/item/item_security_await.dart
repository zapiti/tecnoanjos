import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/chat_tecno_client/chat/chat_perspective.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ItemSecurityAwait extends StatelessWidget {
  final Attendance attendance;

  ItemSecurityAwait(this.attendance);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemeUtils.whiteColor,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            child: Icon(
              Icons.confirmation_num,
              size: 80,
              color: AppThemeUtils.colorPrimary,
            ),
            margin: EdgeInsets.all(10),
          ),
          Container(
            child: Text(
              "Seu Tecnoanjo chegou ao local do atendimento diga a ele o código de atendimento!",textAlign: TextAlign.center,
              style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.colorPrimary),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
          Container(
            child: Text(
              attendance.attendanceCode ?? "",
              style: AppThemeUtils.normalBoldSize(fontSize: 22,color: AppThemeUtils.colorPrimary),
            ),
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: AppThemeUtils.colorPrimary, width: 1),
              shape: BoxShape.rectangle,
            ),
          ),

        Container(margin: EdgeInsets.all(20),
          child: chatField(attendance,context,hint: "Envie o código pelo chat"))
        ],
      )),
    );
  }
}
