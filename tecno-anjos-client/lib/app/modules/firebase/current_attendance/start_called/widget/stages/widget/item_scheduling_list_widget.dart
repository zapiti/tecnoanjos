
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/components/ntp_time/ntp_time_component.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

Widget itemSchedulingListWidget(BuildContext context, Attendance attendance) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 5),
    child: NtpTimeComponent(
        buildTime: (_context,_dateTime) {
  if(_dateTime == null){
  return loadElements(context);
  }else {
  return Card(
        child: InkWell(
            onTap: () {},
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              width: 50,
                              height: 45,
                              color: Colors.grey[200],
                              child: attendance.userTecno.pathImage == null
                                  ? SizedBox()
                                  : Image.network((attendance.userTecno.pathImage),fit: BoxFit.fill,

                                      // placeholder: (context, url) =>
                                      //     new CircularProgressIndicator(),
                                      // errorWidget: (context, url, error) =>
                                      //     new Icon(Icons.error_outline),
                                    ),
                            ))),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  attendance.userTecno.name ?? "--",
                                  style: AppThemeUtils.normalBoldSize(),
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      (attendance.description ??
                                          "-sem descrição-"),
                                      style: AppThemeUtils.normalSize(
                                          fontSize: 12),
                                    )),
                                Text(
                                  Utils.addressFormatMyData(
                                          attendance.address) ??
                                      "--",
                                  overflow: TextOverflow.ellipsis,
                                  style: AppThemeUtils.normalSize(),
                                ),
                              ],
                            )))
                  ],
                ),
                lineViewWidget(),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      attendance?.dateInit == null
                          ? "Não iniciado"
                          : "Iniciado em ${MyDateUtils.parseDateTimeFormat(attendance?.dateInit == null ? MyDateUtils.convertDateToDate(_dateTime,_dateTime) : attendance?.dateInit,null, format: "dd/MM HH:mm")}",
                      overflow: TextOverflow.ellipsis,
                      style: AppThemeUtils.normalSize(
                          color: Theme.of(context).primaryColor),
                    )),
                attendance?.dateEnd == null
                    ? SizedBox()
                    : Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                            "Finalizado em ${MyDateUtils.parseDateTimeFormat(attendance?.dateEnd, null,format: "dd/MM HH:mm")}",
                            overflow: TextOverflow.ellipsis,
                            style: AppThemeUtils.normalSize(
                                color: AppThemeUtils.colorError, fontSize: 14)))
              ],
            ))));}}),
  );
}
