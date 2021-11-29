import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/receiver_called_bloc.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../app_bloc.dart';



class AcceptAttendanceLogic extends StatefulWidget {
  @override
  _AcceptAttendanceLogicState createState() => _AcceptAttendanceLogicState();
}

class _AcceptAttendanceLogicState extends State<AcceptAttendanceLogic> {
  var appBloc = Modular.get<AppBloc>();
  var profileBloc = Modular.get<ProfileBloc>();

  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Modular.get<FirebaseClientTecnoanjo>().getCurrentAttendance(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentUser>(
        stream: appBloc.getCurrentUserFutureValue(),
        builder: (context, snapshotUser) => snapshotUser.data == null
            ? SizedBox()
            : StreamBuilder<ResponsePaginated>(
                stream: profileBloc.userProfile.stream,
                builder: (context, snapshotUser) => (snapshotUser
                            .data?.content?.isFirstLogin ??
                        false)
                    ? SizedBox()
                    : FutureBuilder(
                        future: Firebase.initializeApp(),
                        builder: (context, snapshotFirebase) {

                          return snapshotFirebase.data == null
                              ? SizedBox()
                              : StreamBuilder<QuerySnapshot>(
                                  stream: Modular.get<FirebaseClientTecnoanjo>()
                                      .getDataAcceptSnapshot(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var existAttendance = true;
                                      Attendance attendance;
                                      if (snapshot.data.docs.isNotEmpty) {
                                        var attend =
                                            snapshot.data.docs.first.data();
                                        attendance = Attendance.fromMap(attend);
                                        existAttendance = Modular.get<
                                                FirebaseClientTecnoanjo>()
                                            .notExistsAttendance(attendance);
                                        if (!existAttendance) {
                                          // ActivityUtils.playRemoteFile(
                                          //     attendance);
                                        }
                                      }

                                      return (existAttendance ?? false)
                                          ? SizedBox()
                                          : attendance.status !=
                                                  ActivityUtils.PENDENTE
                                              ? SizedBox()
                                              : Scaffold(
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.55),
                                                  body: attendanceLogicWidget(
                                                      context,
                                                      attendance,
                                                      currentBloc));
                                    } else if (snapshot.hasError) {
                                      return Container(
                                        color: AppThemeUtils.colorError,
                                        margin: EdgeInsets.only(top: 90),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 86,
                                        child: Center(
                                            child: Text(
                                          "Erro ao conectar-se com atendimento,\nContate nosso administrativo",
                                          textAlign: TextAlign.center,
                                          style: AppThemeUtils.normalBoldSize(
                                              color: Colors.white),
                                        )),
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  });
                        })));
  }
}

Widget attendanceLogicWidget(BuildContext context, Attendance attendance,
    MyCurrentAttendanceBloc currentBloc) {
  Modular.get<FirebaseClientTecnoanjo>()
      .getDataAttedanceFuture()
      .then((value) {});
  return attendance?.isFavorite == true
      ? favorite(context, attendance, currentBloc)
      : notFavorite(context, attendance, currentBloc);
}

Center favorite(BuildContext context, Attendance attendance, currentBloc) {
  return Center(
    child: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width > 500
                ? 400
                : MediaQuery.of(context).size.width * 0.8,
            child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(color: Colors.white, width: 0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    color: AppThemeUtils.colorPrimary,
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10, bottom: 10, left: 20),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40)),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white,
                                                  style: BorderStyle.solid)),
                                          child: Icon(
                                            attendance?.address != null
                                                ? MaterialCommunityIcons.map
                                                : MaterialCommunityIcons
                                                    .exclamation,
                                            color: AppThemeUtils.whiteColor,

                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: AutoSizeText(
                                              StringFile.voceTemChamado,
                                              maxLines: 1,
                                              minFontSize: 12,
                                              style: AppThemeUtils.normalSize(
                                                  color:
                                                      AppThemeUtils.whiteColor,
                                                  fontSize: 20),
                                            ))),
                                  ],
                                )),
                            ReceiptCard2(attendance, true, null,
                                showImage: true),
                            Container(
                              padding: EdgeInsets.only(top: 5, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        height: 45,
                                        margin: EdgeInsets.only(
                                            left: 10, top: 0, right: 3),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: AppThemeUtils.darkGrey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  side: BorderSide(
                                                      color: AppThemeUtils
                                                          .darkGrey,
                                                      width: 1))),
                                          onPressed: () {
                                            var receiverCalledBloc = Modular
                                                .get<ReceiverCalledBloc>();
                                            receiverCalledBloc.refuseCalled(
                                                context,
                                                attendance?.id,
                                                attendance.hourAttendance, () {
                                              var receiverCalledBloc = Modular
                                                  .get<ReceiverCalledBloc>();
                                              receiverCalledBloc
                                                  .getListReceivers();

                                              Modular.get<
                                                      FirebaseClientTecnoanjo>()
                                                  .removeCollectionAccept();
                                              //    Navigator.of(context).pop();
                                            });
                                          },
                                          child: Text(
                                            StringFile.rejeitar,
                                            style: AppThemeUtils.normalBoldSize(
                                              color: AppThemeUtils.whiteColor,
                                            ),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          margin: EdgeInsets.only(
                                              right: 10, top: 0, left: 3),
                                          child: TapDebouncer(
                                              cooldown:
                                                  Duration(milliseconds: 2000),
                                              onTap: () async {
                                                currentBloc.patchAccept(
                                                    context, attendance);
                                              },
                                              // your tap handler moved here
                                              builder: (BuildContext context,
                                                  TapDebouncerFunc onTap) {
                                                return ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: AppThemeUtils
                                                          .colorPrimary,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)))),
                                                  onPressed: onTap,
                                                  child: AutoSizeText(
                                                    StringFile
                                                        .aceitarEsteAtendimento,
                                                    textAlign: TextAlign.center,
                                                    minFontSize: 12,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppThemeUtils
                                                        .normalBoldSize(
                                                      color: AppThemeUtils
                                                          .whiteColor,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )))),
  );
}

Center notFavorite(BuildContext context, Attendance attendance, currentBloc) {
  return Center(
    child: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width > 450
                ? 400
                : MediaQuery.of(context).size.width * 0.8,
            child: Material(
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListBody(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(color: Colors.white, width: 0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppThemeUtils.colorPrimary,
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 5, bottom: 5, left: 20),
                                        child: Icon(
                                          attendance?.address != null
                                              ? MaterialCommunityIcons.map
                                              : MaterialCommunityIcons.voice,
                                          color: AppThemeUtils.whiteColor,
                                          size: 40,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Container(
                                              color: AppThemeUtils.colorPrimary,
                                              margin: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: AutoSizeText(
                                                StringFile.voceTemChamado,
                                                maxLines: 1,
                                                minFontSize: 10,
                                                style: AppThemeUtils.normalSize(
                                                    color: AppThemeUtils
                                                        .whiteColor,
                                                    fontSize: 22),
                                              ))),
                                    ],
                                  )),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  child: ReceiptCard2(attendance, true, null,showImage: true,)),
                              Container(
                                padding: EdgeInsets.only(top: 0, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Center(
                                            child: Container(
                                                height: 45,
                                                width: 200,
                                                margin: EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 10,
                                                    top: 5),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: AppThemeUtils
                                                          .darkGrey,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          side: BorderSide(
                                                              color:
                                                                  AppThemeUtils
                                                                      .darkGrey,
                                                              width: 1))),
                                                  onPressed: () {
                                                    var receiverCalledBloc =
                                                        Modular.get<
                                                            ReceiverCalledBloc>();
                                                    receiverCalledBloc
                                                        .refuseCalled(
                                                            context,
                                                            attendance?.id,
                                                            attendance
                                                                .hourAttendance,
                                                            () {
                                                      var receiverCalledBloc =
                                                          Modular.get<
                                                              ReceiverCalledBloc>();
                                                      receiverCalledBloc
                                                          .getListReceivers();

                                                      Modular.get<
                                                              FirebaseClientTecnoanjo>()
                                                          .removeCollectionAccept();
                                                      //    Navigator.of(context).pop();
                                                    });
                                                  },
                                                  child: Text(
                                                    StringFile.recusar,
                                                    style: AppThemeUtils
                                                        .normalBoldSize(
                                                      color: AppThemeUtils
                                                          .whiteColor,
                                                    ),
                                                  ),
                                                )),
                                          )),
                                          Expanded(
                                            child: Center(
                                              child: Container(
                                                  height: 45,
                                                  width: 200,
                                                  margin: EdgeInsets.only(
                                                      right: 10,
                                                      left: 10,
                                                      bottom: 10,
                                                      top: 5),
                                                  child: TapDebouncer(
                                                      cooldown: Duration(
                                                          milliseconds: 2000),
                                                      onTap: () async {
                                                        currentBloc.patchAccept(
                                                            context,
                                                            attendance);
                                                      },
                                                      // your tap handler moved here
                                                      builder:
                                                          (BuildContext context,
                                                              TapDebouncerFunc
                                                                  onTap) {
                                                        return ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: AppThemeUtils
                                                                  .colorPrimary,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)))),
                                                          onPressed: onTap,
                                                          child: AutoSizeText(
                                                            StringFile
                                                                .aceitarEsteAtendimento,
                                                            minFontSize: 12,
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: AppThemeUtils
                                                                .normalBoldSize(
                                                              color: AppThemeUtils
                                                                  .whiteColor,
                                                            ),
                                                          ),
                                                        );
                                                      })),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            ))),
  );
}
