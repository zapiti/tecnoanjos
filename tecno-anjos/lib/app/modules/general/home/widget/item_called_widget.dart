
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Widget itemCalledWidget(BuildContext context, Attendance attendance) {
  return Container(
    height: 82,
    color: attendance?.dateInit == null ? Colors.white : Colors.yellow[400],
    child: InkWell(
        onTap: () {
          AttendanceUtils.pushNamed(context, ConstantsRoutes.INICIARCHAMADO);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin:
                        EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          width: 50,
                          height: 45,
                          color: Colors.grey[200],
                          child: Image.network( (attendance?.userClient?.pathImage ?? ""),fit: BoxFit.fill,
                            // imageUrl:,
                            // placeholder: (context, url) =>
                            //     new CircularProgressIndicator(),
                            // errorWidget: (context, url, error) =>
                            //     new Icon(Icons.error_outline),
                          ),
                        ))),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          attendance?.userClient?.name   ?? "--",
                          maxLines: 1,
                          style: AppThemeUtils.normalBoldSize(),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              (attendance?.description ?? "--"),
                              maxLines: 1,
                              style: AppThemeUtils.normalSize(fontSize: 12),
                            )),
                        Text(
                          attendance?.dateInit == null
                              ? StringFile.agendadoPara +
                                  "${MyDateUtils.parseDateTimeFormat(attendance?.hourAttendance,null, format: "dd/MM <> HH:mm", defaultValue: StringFile.maisbreve).replaceAll("<>", "às")}"
                              : StringFile.emAndamento,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppThemeUtils.normalSize(fontSize: 14),
                        ),
                      ],
                    ))
              ],
            )),
            attendance?.dateInit != null
                ? LinearProgressIndicator()
                : SizedBox()
          ],
        )),
  );
}
