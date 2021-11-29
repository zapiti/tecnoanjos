import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/call_heaven_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat/chat_perspective.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';

import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/alert/alert_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import '../../../app_bloc.dart';
import 'current_attendance.dart';



class CurrentAttendanceLogic extends StatefulWidget {
  @override
  _CurrentAttendanceLogicState createState() => _CurrentAttendanceLogicState();
}

class _CurrentAttendanceLogicState extends State<CurrentAttendanceLogic> {
  var appBloc = Modular.get<AppBloc>();
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
  bool showDetails = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentUser>(
        stream: appBloc.getCurrentUserFutureValue(),
        builder: (context, snapshotUser) => snapshotUser.data == null
            ? SizedBox()
            : FutureBuilder(
                future: Firebase.initializeApp(),
                builder: (context, snapshotFirebase) {
                  return snapshotFirebase.data == null
                      ? SizedBox()
                      : StreamBuilder<DocumentSnapshot>(
                          stream: currentBloc.streamToCurrentService(
                              snapshotUser.data?.id?.toString()),
                          builder: (context, snapshotService) {
                            if (snapshotService.data == null) {
                              return SizedBox();
                            } else {
                              currentBloc.streamToCurrent(currentBloc
                                  .myCurrentService(snapshotService.data));
                              return StreamBuilder<Attendance>(
                                  stream: currentBloc.myCurrentAttendance,
                                  builder: (context, snapshotCurrent) {
                                    if (snapshotCurrent.data == null) {
                                      return SizedBox();
                                    } else {
                                      var attendance = snapshotCurrent.data;
                                      // var attendance =
                                      //     Attendance.fromMap(attend);
                                      var existAttendance =
                                          Modular.get<FirebaseClientTecnoanjo>()
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
                                          ? SizedBox()
                                          : GestureDetector(onTap: () {
                                        if(showDetails){
                                          setState(() {

                                            showDetails = false;
                                          });
                                        }

                                      },
                                    child:Scaffold(
                                              appBar: _headerSized(
                                                  attendance, context,
                                                  tapDetails: () {
                                                setState(() {
                                                  showDetails = !showDetails;
                                                });
                                              }, elevation: showDetails),
                                              body: Stack(
                                                children: [
                                                  CurrentAttendance(attendance),
                                                  showDetails
                                                      ? _detailAttendance(
                                                          attendance, context)
                                                      : SizedBox(),
                                                ],
                                              )));
                                    }
                                  });
                            }
                          });
                }));
  }

  PreferredSize _headerSized(Attendance attendance, BuildContext context,
      {Function() tapDetails, bool elevation}) {
    return PreferredSize(
        preferredSize:  attendance.status == ActivityUtils.FINALIZADO ||
            attendance.status == ActivityUtils.CANCELADO
            ? Size.fromHeight(70)
            : Size.fromHeight(200),
        child: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              preferredSize:  attendance.status == ActivityUtils.FINALIZADO ||
                  attendance.status == ActivityUtils.CANCELADO
                  ? Size.fromHeight(70)
                  : Size.fromHeight(200),
              child: Column(children: [
                Stack(children: [
                  (attendance.clientNF == true)
                      ? SizedBox()
                      : Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                              width: 50,
                              height: 45,
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10),
                              decoration: new BoxDecoration(
                                color: AppThemeUtils.colorPrimaryClient,
                                shape: BoxShape.circle,
                              ),
                              child: Builder(builder: (contextNew) {
                                return GestureDetector(onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CallHeavenPage(
                                                attendance)),
                                  );
                                },child:  Stack(
                                  children: [
                                    Builder(builder: (contextNew) {
                                      return Container(
                                          height: 20,
                                          margin: EdgeInsets.only(bottom: 30),
                                          child: IconButton(
                                              tooltip: "Chamar ceu",
                                              onPressed: () {

                                              },
                                              icon: Icon(
                                                Icons.cloud,
                                                color: AppThemeUtils.whiteColor,
                                                size: 20,
                                              )));
                                    }),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            height: 18,
                                            margin: EdgeInsets.all(6),
                                            child: AutoSizeText(
                                              "CÉU",
                                              style: AppThemeUtils.normalSize(
                                                  color:
                                                      AppThemeUtils.whiteColor,
                                                  fontSize: 16),
                                              minFontSize: 14,
                                            )))
                                  ],
                                ));
                              }))),
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
                                    color: AppThemeUtils.colorPrimaryClient,
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
                                color: AppThemeUtils.colorPrimaryClient,
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
                                                  color:
                                                      AppThemeUtils.whiteColor,
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
                                                                  Icons.circle,
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
                                                                          color: AppThemeUtils
                                                                              .whiteColor,
                                                                          fontSize:
                                                                              12),
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
                                        Modular.get<FirebaseClientTecnoanjo>()
                                            .removeMessageView(attendance);
                                        appBloc.notificationsMSGCount.sink
                                            .add(null);
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
                                                  color:
                                                      AppThemeUtils.whiteColor,
                                                  fontSize: 12),
                                              minFontSize: 10,
                                            )))
                                  ],
                                );
                              })))
                ]),
                attendance.status == ActivityUtils.FINALIZADO ||
                        attendance.status == ActivityUtils.CANCELADO
                    ? SizedBox()
                    : Column(children: [
                        _clientCardInfomation(
                            attendance.userClient, attendance),
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
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.touch_app_outlined,
                                        color: AppThemeUtils.whiteColor,
                                      ),
                                      Center(
                                          child: Text(
                                        "Detalhes do atendimento",
                                        style: AppThemeUtils.normalSize(
                                            color: AppThemeUtils.whiteColor,
                                            fontSize: 18),
                                      ))
                                    ],
                                  )),
                              style: ElevatedButton.styleFrom(
                                  primary: AppThemeUtils.colorPrimary,
                                  elevation: elevation ? 0 : 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(0.0),
                                      side: BorderSide(
                                          color: AppThemeUtils.colorPrimary)))),
                        )
                      ])
              ])),
          elevation: elevation ? 0 : 2,
          centerTitle: true,
        ));
  }

  Widget _detailAttendance(Attendance attendance, BuildContext contex) {
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

  bool _showChat(Attendance attendance) {
    return (attendance.status == ActivityUtils.REMOTAMENTE ||
        attendance.status == ActivityUtils.PENDENTE ||
        attendance.status == ActivityUtils.PRESENCIAL ||
        attendance.status == ActivityUtils.AGUARDO_QR ||
        attendance.status == ActivityUtils.NAO_AGUARDO_QR ||  attendance.status == ActivityUtils.ENCERRADO ||
        attendance.status == ActivityUtils.FINALIZADO ||  attendance.status == ActivityUtils.CANCELADO);
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
                  "Seu Protegido(a)",
                  style: AppThemeUtils.normalBoldSize(
                      color: AppThemeUtils.colorPrimary, fontSize: 12),
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
                                    child: attendance.userClient?.pathImage ==
                                            null
                                        ? SizedBox()
                                        : Image.network(
                                            (attendance.userClient.pathImage),
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
                            child: Text(
                              profile.name,
                              maxLines: 1,
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.colorPrimary,
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            child: Text(
                              Utils.getYearOld(profile),
                              style: AppThemeUtils.normalSize(
                                  color: AppThemeUtils.colorPrimary,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ))
            ],
          )),
          ((profile.avaliations ?? "0.0") == "0.0") ? SizedBox() :    Text(
            ((profile.avaliations ?? "0") == "0"
                    ? "5.0"
                    : (profile.avaliations ?? "0"))
                .replaceAll(".", ","),
            style: AppThemeUtils.normalSize(
                color: AppThemeUtils.colorPrimary, fontSize: 20),
          ),
          ((profile.avaliations ?? "0.0") == "0.0") ? SizedBox() :   Icon(
            Icons.star,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        border: Border.all(color: AppThemeUtils.colorPrimary, width: 2),
        shape: BoxShape.rectangle,
      ),
    );
  }
}
