import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import '../../../../../../app_bloc.dart';


Widget attendanceItemListWidget(BuildContext context, Attendance attendance,
    String status, MyCurrentAttendanceBloc currentAttendanceBloc,
    {Function() detalhe, bool showline = true, bool isDependet = false}) {
  var attendanceBloc = Modular.get<AttendanceBloc>();
  return attendance?.isFavorite == true
      ? isFavorite(context, attendance, status, detalhe, attendanceBloc,
          showline, currentAttendanceBloc, isDependet: isDependet)
      : isNotFavorite(context, attendance, status, detalhe, attendanceBloc,
          showline, currentAttendanceBloc,
          isDependet: isDependet);
}

Center isFavorite(
    BuildContext context,
    Attendance attendance,
    String status,
    Function detalhe,
    AttendanceBloc attendanceBloc,
    bool showline,
    MyCurrentAttendanceBloc currentAttendanceBloc,
    {bool isDependet: false}) {
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
                                        child:
                                            attendance.userClient?.pathImage ==
                                                    null
                                                ? SizedBox()
                                                : Image.network(
                                                    (attendance
                                                        .userClient.pathImage),
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
                                        attendance?.userClient?.name ?? "--",
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
                                                      backgroundColor:
                                                          attendance?.address ==
                                                                  null
                                                              ? AppThemeUtils
                                                                  .darkGrey
                                                              : AppThemeUtils
                                                                  .colorPrimary,
                                                      label: Text(
                                                        attendance?.address ==
                                                                null
                                                            ? "REMOTO"
                                                            : "PRESENCIAL",
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
                                          StringFile.agendadoPara +
                                              ((attendance.hourAttendance !=
                                                      null)
                                                  ? MyDateUtils.parseDateTimeFormat(
                                                          attendance
                                                              .hourAttendance,
                                                          null,
                                                          format:
                                                              "dd/MM <> HH:mm",
                                                          defaultValue: "\"" +
                                                              StringFile
                                                                  .maisbreve +
                                                              "\"")
                                                      .replaceAll("<>", "ás")
                                                  : StringFile.maisbreve),
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
                    caption:
                        isDependet ? StringFile.recusar : StringFile.Cancelar,
                    color: AppThemeUtils.colorError,
                    icon: isDependet ? Icons.unarchive_outlined : Icons.cancel,
                    onTap: () {
                      if (isDependet) {
                        currentAttendanceBloc.patchRefusedAccept(
                            context, attendance);
                      } else {
                        currentAttendanceBloc.patchCancel(context, attendance);
                      }
                    },
                  );
                }),
                IconSlideAction(
                  caption: isDependet
                      ? StringFile.aceitarEsteAtendimento
                      : StringFile.iniciar,
                  color: AppThemeUtils.colorPrimary,
                  icon: isDependet
                      ? Icons.check_circle_outline
                      : Icons.play_arrow,
                  onTap: () {
                    if (isDependet) {
                      currentAttendanceBloc.patchAccept(context, attendance);
                    } else {
                      currentAttendanceBloc.patchInit(context, attendance);
                    }
                  },
                ),
                IconSlideAction(
                  caption: StringFile.detalhe,
                  color: AppThemeUtils.whiteColor,
                  icon:
                      isDependet ? Icons.assessment_outlined : Icons.assessment,
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
                            var currentBloc =
                                GetIt.I.get<MyCurrentAttendanceBloc>();
                            currentBloc.patchCancelCurrentAttendance(
                                context, attendance);
                          },
                        );
                      }),
                detalhe != null
                    ? SizedBox()
                    : Builder(builder: (contextNew) {
                        return IconSlideAction(
                          caption: "Detalhe",
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

Attendance requestAttendance(
    DateTime _dateTime, Attendance attendance, BuildContext context) {
  var dateInit = (MyDateUtils.convertDateToDate(_dateTime, _dateTime) ??
          _dateTime ??
          Modular.get<AppBloc>().dateNowWithSocket.stream.value)
      .add(Duration(minutes: 30));

  if (MyDateUtils.compareTwoDates(
      dateInit, attendance.hourAttendance, _dateTime)) {
    showGenericDialog(
        context: context,
        title: StringFile.atencao,
        description: StringFile.atendimentoumahora,
        iconData: Icons.error_outline,
        positiveCallback: () {},
        positiveText: StringFile.OK);
  } else {
    var startCalledBloc = Modular.get<StartCalledBloc>();
    showLoading(true);
    startCalledBloc.getDetailAttendance(attendance?.id).then((value) {
      showLoading(false);
      if (value.content != null) {
        attendance = value.content;
        attendance.status = ActivityUtils.REMOTAMENTE;
        Modular.get<FirebaseClientTecnoanjo>().setCollection(attendance);
      }

      if ((attendance.fullAddress ?? "") == "" && attendance?.address == null) {
        attendance.status = ActivityUtils.REMOTAMENTE;
        Modular.get<FirebaseClientTecnoanjo>().setCollection(attendance);
        var _dateTime  = MyDateUtils.getTrueTime();
          startCalledBloc.alterStatus(context,
              ActivityUtils.generateBody(attendance, _dateTime, _dateTime), () {
            startCalledBloc.currentAttendance.sink
                .add(ResponsePaginated(content: attendance));
        });
      } else {
        attendance.status = ActivityUtils.PRESENCIAL;
        Modular.get<FirebaseClientTecnoanjo>().setCollection(attendance);

        startCalledBloc.alterStatus(context,
            ActivityUtils.generateBody(attendance, _dateTime, _dateTime), () {
          startCalledBloc.currentAttendance.sink
              .add(ResponsePaginated(content: attendance));

          // AttendanceUtils.pushReplacementNamed(
          //     context, ConstantsRoutes.CURRRENT_ATTENDANCE,
          //     arguments: attendance);
          //
          // startCalledBloc.startAttendance(context);
        });
      }
    });
  }
  return attendance;
}

Center isNotFavorite(
    BuildContext context,
    Attendance attendance,
    String status,
    detalhe(),
    AttendanceBloc attendanceBloc,
    bool showline,
    MyCurrentAttendanceBloc currentAttendanceBloc,
    {bool isDependet = false}) {
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
                                    child: attendance.userClient?.pathImage ==
                                            null
                                        ? SizedBox()
                                        : Image.network(
                                            (attendance.userClient.pathImage),
                                            fit: BoxFit.fill,
                                          ),
                                  ))),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(10),
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
                                                      backgroundColor:
                                                          attendance?.address ==
                                                                  null
                                                              ? AppThemeUtils
                                                                  .darkGrey
                                                              : AppThemeUtils
                                                                  .colorPrimary,
                                                      label: Text(
                                                        attendance?.address ==
                                                                null
                                                            ? "REMOTO"
                                                            : "PRESENCIAL",
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
                                        attendance?.userClient?.name ?? "--",
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
                                          StringFile.agendadoPara +
                                              ((attendance.hourAttendance !=
                                                      null)
                                                  ? MyDateUtils.parseDateTimeFormat(
                                                          attendance
                                                              .hourAttendance,
                                                          null,
                                                          format:
                                                              "dd/MM <> HH:mm",
                                                          defaultValue: "\"" +
                                                              StringFile
                                                                  .maisbreve +
                                                              "\"")
                                                      .replaceAll("<>", "ás")
                                                  : StringFile.maisbreve),
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
                    caption:
                        isDependet ? StringFile.recusar : StringFile.Cancelar,
                    color: AppThemeUtils.colorError,
                    icon: isDependet ? Icons.unarchive_outlined : Icons.cancel,
                    onTap: () {
                      if (isDependet) {
                        currentAttendanceBloc.patchRefusedAccept(
                            context, attendance);
                      } else {
                        currentAttendanceBloc.patchCancel(context, attendance);
                      }
                    },
                  );
                }),
                IconSlideAction(
                  caption: isDependet
                      ? StringFile.aceitarEsteAtendimento
                      : StringFile.iniciar,
                  color: AppThemeUtils.colorPrimary,
                  icon: isDependet
                      ? Icons.check_circle_outline
                      : Icons.play_arrow,
                  onTap: () {
                    if (isDependet) {
                      currentAttendanceBloc.patchAccept(
                        context,
                        attendance,
                      );
                    } else {
                      currentAttendanceBloc.patchInit(context, attendance);
                    }
                  },
                ),
                IconSlideAction(
                  caption: StringFile.detalhe,
                  color: AppThemeUtils.whiteColor,
                  icon:
                      isDependet ? Icons.assessment_outlined : Icons.assessment,
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
                            var currentBloc =
                                GetIt.I.get<MyCurrentAttendanceBloc>();
                            currentBloc.patchCancelCurrentAttendance(
                                context, attendance);
                          },
                        );
                      }),
                detalhe != null
                    ? SizedBox()
                    : Builder(builder: (contextNew) {
                        return IconSlideAction(
                          caption: "Detalhe",
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
