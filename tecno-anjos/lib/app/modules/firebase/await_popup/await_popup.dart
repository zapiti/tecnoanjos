import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/colors/hex_color_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import '../../../app_bloc.dart';

class AwaitPopup extends StatefulWidget {
  @override
  _AwaitPopupState createState() => _AwaitPopupState();
}

class _AwaitPopupState extends State<AwaitPopup> {
  var appBloc = Modular.get<AppBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentUser>(
        stream: appBloc.getCurrentUserFutureValue(),
        builder: (context, snapshot) => snapshot.data == null
            ? SizedBox()
            : StreamBuilder<bool>(
                stream: appBloc.enablePopUp,
                initialData: false,
                builder: (context, snapshot) => !snapshot.data
                    ? SizedBox()
                    : StreamBuilder<QuerySnapshot>(
                        stream: appBloc
                            .firebaseReference()
                            .collection(
                                FirebaseClientTecnoanjo.REQUEST_ATTENDANCE)
                            .doc(FirebaseClientTecnoanjo().collectionDocUser())
                            .collection(FirebaseClientTecnoanjo.AWAIT)
                            .snapshots(),
                        builder: (context, listSnapshot) {
                          var listAttendance = listSnapshot?.data?.docs;
                          Attendance attendance;
                          if ((listAttendance ?? []).length != 0) {
                            var listAtt = listAttendance
                                .map((e) => Attendance.fromMap(e.data()));
                            attendance = listAtt.firstWhere(
                                (element) =>
                                    element.status == ActivityUtils.PENDENTE,
                                orElse: () => null);
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
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    450
                                                ? 450
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                            child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: ListBody(
                                                        children: <Widget>[
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
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
                                                                    width: 0),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                              ),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: AppThemeUtils.colorPrimary,
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.transparent,
                                                                          ),
                                                                          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                                                      child: Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 5,
                                                                                bottom: 5,
                                                                                left: 20),
                                                                            child:
                                                                                Icon(
                                                                              Icons.assistant_photo_rounded,
                                                                              color: AppThemeUtils.whiteColor,
                                                                              size: 30,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                              child: Container(
                                                                                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                                                                  child: AutoSizeText(
                                                                                    Utils.getTitlePopup(attendance.popupStatus),
                                                                                    minFontSize: 10,
                                                                                    maxLines: 1,
                                                                                    style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor, fontSize: 22),
                                                                                  ))),
                                                                        ],
                                                                      )),
                                                                  lineViewWidget(),
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        top: 20,
                                                                        bottom:
                                                                            10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20.0)),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              1),
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 20),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Flexible(
                                                                                  child: Wrap(
                                                                                    children: <Widget>[
                                                                                      Column(
                                                                                        children: [
                                                                                          ReceiptCard2(
                                                                                            attendance,
                                                                                            false,
                                                                                            Modular.get<AppBloc>().dateNowWithSocket.stream.value,
                                                                                            showImage: true,
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
                                                                              bottom: 10),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Expanded(
                                                                                  child: Center(
                                                                                child: Container(
                                                                                    height: 45,
                                                                                    width: 200,
                                                                                    margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
                                                                                    child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(primary: AppThemeUtils.colorPrimary, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                                                                                      onPressed: () {
                                                                                        showLoading(true);
                                                                                        var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
                                                                                        currentBloc.deleteAwait(context, attendance);
                                                                                        appBloc.openAwaitPopup.sink.add(false);
                                                                                        showLoading(false);
                                                                                      },
                                                                                      child: Container(
                                                                                          margin: EdgeInsets.symmetric(
                                                                                            horizontal: 0,
                                                                                          ),
                                                                                          child: AutoSizeText(
                                                                                            StringFile.ok,
                                                                                            maxLines: 1,
                                                                                            minFontSize: 12,
                                                                                            style: AppThemeUtils.normalBoldSize(
                                                                                              color: AppThemeUtils.whiteColor,
                                                                                            ),
                                                                                          )),
                                                                                    )),
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
                        })));
  }
}
