import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Widget buildNotInitNow(
    BuildContext context, Attendance attendance, mycurrentAttendance,
    {double height}) {
  return attendance.hourAttendance == null
      ? SizedBox()
      : Container(
          height: height,
          margin: EdgeInsets.only(right: 10, left: 0, bottom: 10, top: 0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: AppThemeUtils.colorError,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      side: BorderSide(
                          color: AppThemeUtils.colorError, width: 1))),
              onPressed: () {
                mycurrentAttendance.patchNotInitNow(context, attendance);
              },
              //  AttendanceUtils.goToHome(context);,
              child: Text(
                StringFile.naoIniciarAgora,
                textAlign: TextAlign.center,
                style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.whiteColor,
                ),
              )),
        );
}
