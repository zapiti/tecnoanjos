import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/components/dialog/date/date_bottom_sheet.dart';

import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/calling_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/calling.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';

import 'package:tecnoanjosclient/app/utils/colors/hex_color_utils.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

class AwaitPopup extends StatefulWidget {
  @override
  _AwaitPopupState createState() => _AwaitPopupState();
}

class _AwaitPopupState extends State<AwaitPopup> {
  // Attendance attendance = Attendance(id: 15);
  var callingBloc = Modular.get<CallingBloc>();
  final appBloc = Modular.get<AppBloc>();
  var controlAwait = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentUser>(
        stream: appBloc.getCurrentUserFutureValue(),
        builder: (ctx, snapshot) {
          Modular.get<FirebaseClientTecnoanjo>()
              .getDataAwaitSnapshot(snapshot?.data?.id?.toString());

          return snapshot.data == null
              ? SizedBox()
              : StreamBuilder<Attendance>(
                  stream: Modular.get<FirebaseClientTecnoanjo>()
                      .getDataAwaitSnapshotSubject,
                  builder: (context, listSnapshot) {
                    Attendance attendance = listSnapshot?.data;

                    if (attendance != null) {
                      callingBloc.myCalling.sink
                          .add(Calling.fromMap(attendance));
                      if (attendance.hourAttendance != null) {
                        callingBloc.dateController.text =
                            MyDateUtils.parseDateTimeFormat(
                                attendance.hourAttendance,
                                attendance.hourAttendance,
                                format: "dd/MM/yyyy HH:mm");
                      }
                    }
                    if (attendance?.popupStatus == "A") {
                      if (controlAwait.text != "${attendance.id}") {
                        controlAwait.text = "${attendance.id}";
                        final assetsAudioPlayer = AssetsAudioPlayer();
                        assetsAudioPlayer.open(
                          Audio(ImagePath.soundSimple),
                        );
                        assetsAudioPlayer.playOrPause();
                      }
                    }

                    return attendance == null
                        ? SizedBox()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: HexColor("80808080"),
                            child: Center(
                              child: SingleChildScrollView(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width >
                                              450
                                          ? 450
                                          : MediaQuery.of(context).size.width *
                                              0.9,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: ListBody(
                                                  children: <Widget>[
                                                    Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20.0)),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 0),
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: AppThemeUtils
                                                                            .colorPrimary,
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              Colors.transparent,
                                                                        ),
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                            topLeft: Radius.circular(20))),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5,
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .assistant_photo_rounded,
                                                                        color: AppThemeUtils
                                                                            .whiteColor,
                                                                        size:
                                                                            30,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                        child: Container(
                                                                            margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                                                            child: AutoSizeText(
                                                                              Utils.getTitlePopup(attendance),
                                                                              minFontSize: 10,
                                                                              maxLines: 1,
                                                                              style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor, fontSize: 22),
                                                                            ))),
                                                                  ],
                                                                )),
                                                            lineViewWidget(),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20,
                                                                      bottom:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20.0)),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Flexible(
                                                                            child:
                                                                                Wrap(
                                                                              children: <Widget>[
                                                                                Column(
                                                                                  children: [
                                                                                    ReceiptCard2(
                                                                                      attendance,
                                                                                      false,
                                                                                      Modular.get<AppBloc>().dateNowWithSocket.stream.value,
                                                                                      showImage: attendance?.userTecno?.id != null,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        top: 20,
                                                                        bottom:
                                                                            10),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        attendance.popupStatus !=
                                                                                "CR"
                                                                            ? SizedBox()
                                                                            : Expanded(
                                                                                child: Center(
                                                                                child: Container(
                                                                                    height: 45,
                                                                                    width: 200,
                                                                                    margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(primary: AppThemeUtils.colorError, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: AppThemeUtils.colorError, width: 1))),
                                                                                      onPressed: () {
                                                                                        var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
                                                                                        currentBloc.deleteAwait(context, attendance);
                                                                                      },
                                                                                      child: AutoSizeText(
                                                                                        StringFile.cancelar,
                                                                                        maxLines: 1,
                                                                                        minFontSize: 12,
                                                                                        style: AppThemeUtils.normalBoldSize(
                                                                                          color: AppThemeUtils.whiteColor,
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                              )),
                                                                        Expanded(
                                                                            child:
                                                                                Center(
                                                                          child: Container(
                                                                              height: 45,
                                                                              width: 200,
                                                                              margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
                                                                              child: StreamBuilder<Calling>(
                                                                                  stream: callingBloc.myCalling.stream,
                                                                                  builder: (ctx, snapshotDate) => ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(primary: AppThemeUtils.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                                                                                        onPressed: () async {
                                                                                          var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
                                                                                          if (attendance.popupStatus == "CR") {
                                                                                            var datenow = await MyDateUtils.getTrueTime();
                                                                                            final mydate = (datenow ?? snapshotDate.data.hourAttendance ?? DateTime.now()).add(Duration(minutes: 45));
                                                                                            showDateBottomSheet(context, initialDate: mydate, onDate: (date) {
                                                                                              Navigator.pop(ctx);
                                                                                              if (date != null) {
                                                                                                callingBloc.selectedDate(date);
                                                                                                //
                                                                                                // setState(() {
                                                                                                //
                                                                                                // });

                                                                                                if (attendance?.userTecno?.id == null) {
                                                                                                  if (attendance.id == null) {
                                                                                                    callingBloc.soliciteAttendance(context, onSucess: () {
                                                                                                      currentBloc.deleteAwait(context, attendance);
                                                                                                    });
                                                                                                  } else {
                                                                                                    callingBloc.soliciteAttendanceResend(attendance, date, context, onSuccess: () {
                                                                                                      currentBloc.deleteAwait(context, attendance);
                                                                                                    });
                                                                                                  }
                                                                                                } else {
                                                                                                  currentBloc.deleteAwait(context, attendance);

                                                                                                  attendance.hourAttendance = callingBloc.myCalling?.stream?.value?.hourAttendance;
                                                                                                  currentBloc.patchReschedule(context, attendance);
                                                                                                }
                                                                                              }
                                                                                            });
                                                                                          } else {
                                                                                            currentBloc.deleteAwait(context, attendance);
                                                                                          }
                                                                                        },
                                                                                        child: Container(
                                                                                            margin: EdgeInsets.symmetric(
                                                                                              horizontal: 0,
                                                                                            ),
                                                                                            child: AutoSizeText(
                                                                                              attendance.popupStatus == "CR" ? StringFile.reagendar : StringFile.ok,
                                                                                              maxLines: 1,
                                                                                              minFontSize: 12,
                                                                                              style: AppThemeUtils.normalBoldSize(
                                                                                                color: AppThemeUtils.whiteColor,
                                                                                              ),
                                                                                            )),
                                                                                      ))),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ]))))),
                            ),
                          );
                  });
        });
  }
}
