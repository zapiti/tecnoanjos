import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/security_code/security_code_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/chat_tecno_client/chat/chat_perspective.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/widget/item/item_await_attendance.dart';

import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/alert/alert_utils.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'current_attendance.dart';

class CurrentAttendanceLogic extends StatefulWidget {
  @override
  _CurrentAttendanceLogicState createState() => _CurrentAttendanceLogicState();
}

class _CurrentAttendanceLogicState extends State<CurrentAttendanceLogic> {
  final appBloc = Modular.get<AppBloc>();
  var profileBloc = Modular.get<ProfileBloc>();
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
  bool showDetails = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Modular.get<FirebaseClientTecnoanjo>().getCurrentAttendance(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentUser>(
        stream: appBloc.getCurrentUserFutureValue(),
        builder: (context, snapshot) => snapshot.data == null
            ? SizedBox()
            : FutureBuilder<String>(
                future: currentBloc.collectionDocUser(),
                initialData: "-1",
                builder: (ctx, futureShot) => StreamBuilder(
                    stream: appBloc.getCurrentUserFutureValue().stream,
                    initialData:
                        appBloc.getCurrentUserFutureValue().stream.value,
                    builder: (context, AsyncSnapshot snapshotUser) {
                      if (snapshotUser.data != null) {
                        return StreamBuilder<DocumentSnapshot>(
                            stream: currentBloc
                                ?.streamToCurrentService(futureShot.data),
                            builder: (context, snapshotService) {
                              if (snapshotService.data == null ||
                                  futureShot.data == null) {
                                return SizedBox();
                              } else {
                                currentBloc.streamToCurrent(currentBloc
                                    .myCurrentService(snapshotService.data));
                                return StreamBuilder<Attendance>(
                                    stream: currentBloc.myCurrentAttendance,
                                    builder: (context, snapshotCurrent) {
                                      if (snapshotCurrent.data == null) {
                                        return currentAccept(
                                            null, futureShot.data);
                                      } else {
                                        var attendance = snapshotCurrent.data;
                                        var existAttendance = Modular.get<
                                                FirebaseClientTecnoanjo>()
                                            .notExistsAttendance(attendance);
                                        if (attendance != null) {
                                          appBloc.getMsgAttendance(attendance);
                                          Modular.get<ChatAttendanceBloc>()
                                              .getChatschedule(
                                                  context, attendance,
                                                  notRemove: true);
                                          AlertUtils.msgRigtone(attendance);
                                        }
                                        return existAttendance
                                                ? currentAccept(
                                                    attendance, futureShot.data)
                                                : GestureDetector(
                                                    onTap: () {
                                                      if (showDetails) {
                                                        setState(() {
                                                          showDetails = false;
                                                        });
                                                      }
                                                    },
                                                    child: Scaffold(
                                                        appBar: _headerSized(
                                                            attendance, context,
                                                            tapDetails: () {
                                                          setState(() {
                                                            showDetails =
                                                                !showDetails;
                                                          });
                                                        },
                                                            elevation:
                                                                showDetails),
                                                        body: Stack(
                                                          children: [
                                                            CurrentAttendance(
                                                                attendance),
                                                            showDetails
                                                                ? _detailAttendance(
                                                                    attendance,
                                                                    context)
                                                                : SizedBox(),
                                                            SecurityCodeWidget(attendance),
                                                          ],
                                                        )));
                                      }
                                    });
                              }
                            });
                      } else {
                        return currentAccept(null, futureShot.data);
                      }
                    })));
  }

  Widget _detailAttendance(Attendance attendance, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3)],
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: ReceiptCard2(
        attendance,
        true,
        null,
        showImage: false,
      ),
    );
  }

  PreferredSize _headerSized(Attendance attendance, BuildContext context,
      {Function() tapDetails, bool elevation}) {
    return PreferredSize(
        preferredSize: attendance.status == ActivityUtils.FINALIZADO ||
                attendance.status == ActivityUtils.CANCELADO ||
                attendance.status == ActivityUtils.ENCERRADO
            ? Size.fromHeight(70)
            : Size.fromHeight(200),
        child: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              preferredSize: attendance.status == ActivityUtils.FINALIZADO ||
                      attendance.status == ActivityUtils.CANCELADO ||
                      attendance.status == ActivityUtils.ENCERRADO
                  ? Size.fromHeight(70)
                  : Size.fromHeight(200),
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                        height: 70,
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                margin: EdgeInsets.only(top: 0, bottom: 0),
                                child: Text(
                                  StringFile.atendimento,
                                  textAlign: TextAlign.center,
                                  style: AppThemeUtils.normalSize(
                                      color: AppThemeUtils.whiteColor,
                                      fontSize: 22),
                                )))),
                    _showChat(attendance)
                        ? SizedBox()
                        : Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                width: 50,
                                height: 45,
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, right: 10),
                                decoration: new BoxDecoration(
                                  color: AppThemeUtils.whiteColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Builder(builder: (contextNew) {
                                  return Stack(
                                    children: [
                                      IconButton(
                                        icon: StreamBuilder<int>(
                                          stream:
                                              Modular.get<ChatAttendanceBloc>()
                                                  .countQtdNotRead,
                                          builder: (context, snapshot) => Stack(
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    snapshot.data == 0
                                                        ? Icons.chat
                                                        : Icons
                                                            .mark_chat_read_outlined,
                                                    color: AppThemeUtils
                                                        .colorPrimary,
                                                    size: snapshot.data == 0
                                                        ? 24
                                                        : 30,
                                                  )),
                                              snapshot.data == 0
                                                  ? Align()
                                                  : Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                          height: 20,
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 20,
                                                                  )),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  child: Container(
                                                                      width: 12,
                                                                      margin: EdgeInsets.only(right: 0, top: 0),
                                                                      child: Center(
                                                                          child: AutoSizeText(
                                                                        snapshot
                                                                            .data
                                                                            .toString(),
                                                                        maxLines:
                                                                            1,
                                                                        style: AppThemeUtils.normalSize(
                                                                            color:
                                                                                AppThemeUtils.whiteColor,
                                                                            fontSize: 12),
                                                                        maxFontSize:
                                                                            12,
                                                                        minFontSize:
                                                                            2,
                                                                      ))))
                                                            ],
                                                          ))),
                                            ],
                                          ),
                                        ),
                                        color: AppThemeUtils.whiteColor,
                                        onPressed: () {
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPerspective(
                                                          attendance)),
                                            );
                                          });
                                        },
                                      ),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              height: 10,
                                              margin: EdgeInsets.all(6),
                                              child: AutoSizeText(
                                                "CHAT",
                                                style: AppThemeUtils.normalSize(
                                                    color: AppThemeUtils
                                                        .colorPrimary,
                                                    fontSize: 12),
                                                minFontSize: 10,
                                              )))
                                    ],
                                  );
                                })))
                  ]),
                  attendance.status == ActivityUtils.FINALIZADO ||
                          attendance.status == ActivityUtils.CANCELADO ||
                          attendance.status == ActivityUtils.ENCERRADO
                      ? SizedBox()
                      : Column(children: [
                          _clientCardInfomation(
                              attendance.userTecno, attendance),
                          Container(
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (tapDetails != null) {
                                    tapDetails();
                                  }
                                },
                                child: Container(
                                    height: 45,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.touch_app_outlined,
                                          color: AppThemeUtils.colorPrimary,
                                        ),
                                        Center(
                                            child: Text(
                                          "Detalhes do atendimento",
                                          style: AppThemeUtils.normalSize(
                                              color: AppThemeUtils.colorPrimary,
                                              fontSize: 18),
                                        ))
                                      ],
                                    )),
                                style: ElevatedButton.styleFrom(
                                    primary: AppThemeUtils.whiteColor,
                                    elevation: elevation ? 0 : 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.0),
                                        side: BorderSide(
                                            color: AppThemeUtils.whiteColor)))),
                          )
                        ])
                ],
              )),
          elevation: elevation ? 0 : 2,
          centerTitle: true,
        ));
  }

  Widget currentAccept(atendimento2, String user) {
    var attendanceBloc = Modular.get<AttendanceBloc>();
    Modular.get<FirebaseClientTecnoanjo>().getDataAcceptSnapshot(user);
    return StatefulWrapper(
        onInit: () {},
        child: StreamBuilder<Attendance>(
            stream: Modular.get<FirebaseClientTecnoanjo>()
                .getDataAcceptSnapshotSubject,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var attendance = snapshot.data;

                if (attendance != null) {
                  if (attendance?.status == ActivityUtils.PRESENCIAL ||
                      attendance?.status == ActivityUtils.REMOTAMENTE ||
                      (attendance?.status == ActivityUtils.FINALIZADO) ||
                      attendance?.status == ActivityUtils.PENDENTE) {}
                  if (attendance != null) {
                    if (attendance?.status == ActivityUtils.PENDENTE) {
                      attendanceBloc.getTimeMaxHoursCancell(attendance);
                    }
                  }
                }
                if (attendance == null) {
                  if (appBloc.openAwaitPopup.stream.value == true) {
                    showLoading(true);
                  }

                  showLoading(false);
                }

                return attendance == null
                    ? SizedBox()
                    : attendance.hourAttendance == null &&
                            attendance.userTecno?.id != null
                        ? SizedBox()
                        : Scaffold(
                            backgroundColor: Colors.white,
                            appBar: attendance.userTecno?.id != null
                                ? null
                                : AppBar(
                                    automaticallyImplyLeading: false,
                                    backgroundColor: AppThemeUtils.colorPrimary,
                                    title: Text(StringFile.aguardeAtendimento,
                                        style: AppThemeUtils.normalSize(
                                            color: AppThemeUtils.whiteColor)),
                                    centerTitle: true,
                                  ),
                            body: attendance.userTecno?.id != null
                                ? itemAttendanceAccept(attendance)
                                : itemAwaitAttendance(attendance));
              } else {
                // if (attendanceBloc.temporary.stream.value ) {
                //   showLoading(true);
                //
                //   Future.delayed(Duration(seconds: 1), () {
                //     showLoading(false);
                //   });
                // }
                //   attendanceBloc.temporary.sink.add(false);
                return SizedBox();
              }
            }));
  }

  bool _showChat(Attendance attendance) {
    return (attendance.status == ActivityUtils.REMOTAMENTE ||
        attendance.status == ActivityUtils.PENDENTE ||
        attendance.status == ActivityUtils.PRESENCIAL ||
        attendance.status == ActivityUtils.AGUARDO_QR ||
        attendance.status == ActivityUtils.NAO_AGUARDO_QR ||
        attendance.status == ActivityUtils.ENCERRADO ||
        attendance.status == ActivityUtils.FINALIZADO ||
        attendance.status == ActivityUtils.CANCELADO);
  }

  _clientCardInfomation(Profile profile, Attendance attendance) {
    return Container(
      height: 90,
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, top: 2),
                child: Text(
                  "Seu Tecnoanjo",
                  style: AppThemeUtils.normalBoldSize(
                      color: AppThemeUtils.whiteColor, fontSize: 12),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          !(attendance?.isFavorite ?? false)
                              ? SizedBox()
                              : Icon(
                                  MaterialCommunityIcons.crown,
                                  color: AppThemeUtils.colorPrimary,
                                  size: 12,
                                ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: 0, left: 15, right: 15, bottom: 5),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.grey[200],
                                    child: attendance.userTecno?.pathImage ==
                                            null
                                        ? SizedBox()
                                        : Image.network(
                                            (attendance.userTecno?.pathImage),
                                            fit: BoxFit.fill,
                                          ),
                                  )))
                        ],
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              profile?.name ?? "sem nome",
                              maxLines: 2,
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.whiteColor,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          profile?.totalAttendances == "0" ||
                                  profile?.totalAttendances == "0.0"
                              ? SizedBox()
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[200],
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: AutoSizeText(
                                    "${profile?.totalAttendances ?? "0"} atendimento${profile?.totalAttendances == "1" ? "" : "s"}",
                                    maxLines: 1,
                                    minFontSize: 8,
                                    style:
                                        AppThemeUtils.normalSize(fontSize: 10),
                                  ))
                        ],
                      ))
                    ],
                  ))
            ],
          )),
          profile?.avaliations == "0" || profile?.avaliations == "0.0"
              ? SizedBox()
              : Text(
                  ((profile?.avaliations ?? "0") == "0"
                          ? "5.0"
                          : (profile.avaliations ?? "0"))
                      .replaceAll(".", ","),
                  style: AppThemeUtils.normalSize(
                      color: AppThemeUtils.whiteColor, fontSize: 20),
                ),
          Icon(
            Icons.star,
            size: 20,
            color: AppThemeUtils.whiteColor,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      decoration: BoxDecoration(
        color: AppThemeUtils.colorPrimary,
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        border: Border.all(color: AppThemeUtils.whiteColor, width: 2),
        shape: BoxShape.rectangle,
      ),
    );
  }
}
