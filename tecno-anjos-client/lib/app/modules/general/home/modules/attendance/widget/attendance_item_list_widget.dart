
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../attendance_bloc.dart';

Widget attendanceItemListWidget(
    BuildContext context, Attendance attendance, String status,
    {Function() detalhe, bool showline = true}) {
  var attendanceBloc = Modular.get<AttendanceBloc>();
  return attendance.isFavorite == true
      ? isFavorite(
          context, attendance, status, detalhe, attendanceBloc, showline)
      : isNotFavorite(
          context, attendance, status, detalhe, attendanceBloc, showline);
}

Center isFavorite(BuildContext context, Attendance attendance, String status,
    detalhe(), AttendanceBloc attendanceBloc, bool showline) {
  return Center(
      child: Slidable(
    actionPane: SlidableStrechActionPane(),
    closeOnScroll: true,
    enabled: true,
    actionExtentRatio: 0.25,
    child: Builder(builder: (contextNew) {
      return InkWell(
          onTap: () {

            Slidable.of(contextNew).open(actionType: SlideActionType.secondary);
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Icon(
                                MaterialCommunityIcons.crown,
                                color: AppThemeUtils.colorPrimary,
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 5, left: 5, right: 5, bottom: 5),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey[200],
                                        child: attendance
                                                    .userTecno?.pathImage ==
                                                null
                                            ? SizedBox()
                                            : Image.network(
                                                (attendance
                                                    .userTecno?.pathImage),
                                                fit: BoxFit.fill,
                                                // placeholder: (context, url) =>
                                                //     new CircularProgressIndicator(),
                                                // errorWidget: (context, url,
                                                //         error) =>
                                                //     new Icon(
                                                //         Icons.error_outline),
                                              ),
                                      )))
                            ],
                          ),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        attendance?.userTecno?.name ?? "--",
                                        style: AppThemeUtils.normalBoldSize(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                "Criado em ${MyDateUtils.parseDateTimeFormat(attendance.createdAt, null, format: "dd/MM <> HH:mm").replaceAll("<>", "ás")}",
                                                style: AppThemeUtils.normalSize(
                                                    fontSize: 12),
                                              )),
                                              Container(
                                                margin: EdgeInsets.only(top: 9),
                                                child: Transform(
                                                    transform:
                                                        new Matrix4.identity()
                                                          ..scale(0.6),
                                                    child: Chip(
                                                      backgroundColor: attendance.address ==
                                                          null
                                                          ? AppThemeUtils.darkGrey:
                                                      AppThemeUtils
                                                          .colorPrimary,
                                                      label: Text(
                                                        attendance.address ==
                                                                null
                                                            ? StringFile.remoto
                                                            : StringFile
                                                                .presencial,
                                                        style: AppThemeUtils
                                                            .normalSize(
                                                                color: AppThemeUtils
                                                                    .whiteColor),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          StringFile.agendadoPara + ( (attendance.hourAttendance == null)
                                              ? status ==
                                                      ActivityUtils.FINALIZADO
                                                  ? MyDateUtils.parseDateTimeFormat(
                                                          attendance.dateEnd, null,
                                                          format:
                                                              "dd/MM <> HH:mm",
                                                          defaultValue: "\"" +
                                                              StringFile
                                                                  .maisbreve +
                                                              "\"")
                                                      .replaceAll("<>", "ás")
                                                  : MyDateUtils.parseDateTimeFormat(
                                                          attendance.dateInit,
                                                          null,
                                                          format:
                                                              "dd/MM <> HH:mm",
                                                          defaultValue: "\"" +
                                                              StringFile
                                                                  .maisbreve +
                                                              "\"")
                                                      .replaceAll("<>", "ás")
                                              : MyDateUtils.parseDateTimeFormat(
                                                      attendance.hourAttendance,
                                                      null,
                                                      format: "dd/MM <> HH:mm",
                                                      defaultValue: "\"" +
                                                          StringFile.maisbreve +
                                                          "\"")
                                                  .replaceAll("<>", "ás")),
                                          overflow: TextOverflow.ellipsis,
                                          style: AppThemeUtils.normalBoldSize(
                                              fontSize: 14),
                                        ),
                                      )
                                    ],
                                  )))
                        ],
                      ),
                      showline ? lineViewWidget() : SizedBox()
                    ],
                  ))));
    }),
    secondaryActions: detalhe != null
        ? []
        : attendance.status == ActivityUtils.PENDENTE
            ? <Widget>[
                Builder(builder: (contextNew) {
                  return IconSlideAction(
                    caption: StringFile.Cancelar,
                    color: AppThemeUtils.colorError,
                    icon: Icons.cancel,
                    onTap: () {
                      attendanceBloc.cancelAttendance(context, attendance, () {
                        attendanceBloc.getListSchedule();
                      });
                    },
                  );
                }),
                IconSlideAction(
                  caption: StringFile.detalhe,
                  color: AppThemeUtils.whiteColor,
                  icon: Icons.assessment,
                  onTap: () {
                    AttendanceUtils.pushNamed(
                        context, ConstantsRoutes.CALL_DETAILS_ATTENDANCE,
                        arguments: attendance);
                  },
                ),
              ]
            : <Widget>[
                attendance.status == ActivityUtils.FINALIZADO ||
                        attendance.status == ActivityUtils.CANCELADO ||
                        status == ActivityUtils.CANCELADO ||
                        status == ActivityUtils.FINALIZADO
                    ? SizedBox()
                    : Builder(builder: (contextNew) {
                        return IconSlideAction(
                          caption: StringFile.Cancelar,
                          color: AppThemeUtils.colorError,
                          icon: Icons.cancel,
                          onTap: () {
                            attendanceBloc.cancelAttendance(context, attendance,
                                () {
                              attendanceBloc.getListSchedule();
                            });
                          },
                        );
                      }),
                detalhe != null
                    ? SizedBox()
                    : Builder(builder: (contextNew) {
                        return IconSlideAction(
                          caption: StringFile.detalhe,
                          color: AppThemeUtils.colorPrimary,
                          icon: Icons.assessment,
                          onTap: () {
                            if (detalhe == null) {
                              AttendanceUtils.pushNamed(context,
                                  ConstantsRoutes.CALL_DETAILS_ATTENDANCE,
                                  arguments: attendance);
                            } else {
                              detalhe();
                            }
                          },
                        );
                      }),
              ],
  ));
}

Center isNotFavorite(BuildContext context, Attendance attendance, String status,
    detalhe(), AttendanceBloc attendanceBloc, bool showline) {
  return Center(
      child: Slidable(
    actionPane: SlidableStrechActionPane(),
    closeOnScroll: true,
    enabled: true,
    actionExtentRatio: 0.25,
    child: Builder(builder: (contextNew) {
      return InkWell(
          onTap: () {
            Slidable.of(contextNew).open(actionType: SlideActionType.secondary);
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      lineViewWidget(),
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
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey[200],
                                    child: attendance.userTecno?.pathImage ==
                                            null
                                        ? SizedBox()
                                        : Image.network(
                                           (attendance
                                                .userTecno?.pathImage),
                                            fit: BoxFit.fill,
                                            // placeholder: (context, url) =>
                                            //     new CircularProgressIndicator(),
                                            // errorWidget: (context, url,
                                            //         error) =>
                                            //     new Icon(Icons.error_outline),
                                          ),
                                  ))),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      right: 10, left: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                "Criado em ${MyDateUtils.parseDateTimeFormat(attendance.createdAt, null, format: "dd/MM <> HH:mm").replaceAll("<>", "ás")}",
                                                style: AppThemeUtils.normalSize(
                                                    fontSize: 12),
                                              )),
                                              Container(
                                                margin: EdgeInsets.only(top: 9),
                                                child: Transform(
                                                    transform:
                                                        new Matrix4.identity()
                                                          ..scale(0.6),
                                                    child: Chip(
                                                      backgroundColor: attendance.address ==
                                                          null
                                                          ? AppThemeUtils.colorError:
                                                          AppThemeUtils
                                                              .colorPrimary,
                                                      label: Text(
                                                        attendance.address ==
                                                                null
                                                            ? StringFile.remoto
                                                            : StringFile
                                                                .presencial,
                                                        style: AppThemeUtils
                                                            .normalSize(
                                                                color: AppThemeUtils
                                                                    .whiteColor),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          )),
                                      Text(
                                        attendance?.userTecno?.name ?? "--",
                                        style: AppThemeUtils.normalBoldSize(),
                                      ),
                                      Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            (attendance.description ?? "")
                                                    .isEmpty
                                                ? "--"
                                                : attendance.description,
                                            style: AppThemeUtils.normalSize(
                                                fontSize: 12),
                                          )),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          StringFile.agendadoPara +  ((attendance.hourAttendance == null)
                                              ? status ==
                                                      ActivityUtils.FINALIZADO
                                                  ? MyDateUtils.parseDateTimeFormat(
                                                          attendance.dateEnd, null,
                                                          format:
                                                              "dd/MM <> HH:mm",
                                                          defaultValue: "\"" +
                                                              StringFile
                                                                  .maisbreve +
                                                              "\"")
                                                      .replaceAll("<>", "ás")
                                                  : MyDateUtils.parseDateTimeFormat(
                                                          attendance.dateInit,
                                                          null,
                                                          format:
                                                              "dd/MM <> HH:mm",
                                                          defaultValue: "\"" +
                                                              StringFile
                                                                  .maisbreve +
                                                              "\"")
                                                      .replaceAll("<>", "ás")
                                              : MyDateUtils.parseDateTimeFormat(
                                                      attendance.hourAttendance,
                                                      null,
                                                      format: "dd/MM <> HH:mm",
                                                      defaultValue: "\"" +
                                                          StringFile.maisbreve +
                                                          "\"")
                                                  .replaceAll("<>", "ás")),
                                          overflow: TextOverflow.ellipsis,
                                          style: AppThemeUtils.normalSize(),
                                        ),
                                      )
                                    ],
                                  )))
                        ],
                      ),
                      showline ? lineViewWidget() : SizedBox()
                    ],
                  ))));
    }),
    secondaryActions: detalhe != null
        ? []
        : attendance.status == ActivityUtils.PENDENTE
            ? <Widget>[
                Builder(builder: (contextNew) {
                  return IconSlideAction(
                    caption: StringFile.Cancelar,
                    color: AppThemeUtils.colorError,
                    icon: Icons.cancel,
                    onTap: () {
                      attendanceBloc.cancelAttendance(context, attendance, () {
                        attendanceBloc.getListSchedule();
                      });
                    },
                  );
                }),
                IconSlideAction(
                  caption: StringFile.detalhe,
                  color: AppThemeUtils.whiteColor,
                  icon: Icons.assessment,
                  onTap: () {
                    AttendanceUtils.pushNamed(
                        context, ConstantsRoutes.CALL_DETAILS_ATTENDANCE,
                        arguments: attendance);
                  },
                ),
              ]
            : <Widget>[
                attendance.status == ActivityUtils.FINALIZADO ||
                        attendance.status == ActivityUtils.CANCELADO ||
                        status == ActivityUtils.CANCELADO ||
                        status == ActivityUtils.FINALIZADO
                    ? SizedBox()
                    : Builder(builder: (contextNew) {
                        return IconSlideAction(
                          caption: StringFile.Cancelar,
                          color: AppThemeUtils.colorError,
                          icon: Icons.cancel,
                          onTap: () {
                            attendanceBloc.cancelAttendance(context, attendance,
                                () {
                              attendanceBloc.getListSchedule();
                            });
                          },
                        );
                      }),
                detalhe != null
                    ? SizedBox()
                    : Builder(builder: (contextNew) {
                        return IconSlideAction(
                          caption: StringFile.detalhe,
                          color: AppThemeUtils.colorPrimary,
                          icon: Icons.assessment,
                          onTap: () {
                            if (detalhe == null) {
                              AttendanceUtils.pushNamed(context,
                                  ConstantsRoutes.CALL_DETAILS_ATTENDANCE,
                                  arguments: attendance);
                            } else {
                              detalhe();
                            }
                          },
                        );
                      }),
              ],
  ));
}
