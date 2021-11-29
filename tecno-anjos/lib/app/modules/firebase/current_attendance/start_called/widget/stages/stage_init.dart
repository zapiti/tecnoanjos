import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:tecnoanjostec/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjostec/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjostec/app/components/not_init_now/not_init_now.dart';
import 'package:tecnoanjostec/app/modules/google_maps/scrolling_map.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/location/location_utils.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import '../../current_attendance_bloc.dart';
import '../../start_called_bloc.dart';

class StageInit extends StatelessWidget {
  final Attendance attendance;
  final Function actionInitAttendance;
  final startCalledBloc = Modular.get<StartCalledBloc>();
  final currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  StageInit(this.attendance, {this.actionInitAttendance});

  @override
  Widget build(BuildContext context) {
    try {
      return attendance.status == ActivityUtils.REMOTAMENTE
          ? Container(
              color: Theme.of(context).backgroundColor,
              height: MediaQuery.of(context).size.height,
              child: initAttendanceView(context, currentBloc))
          : Stack(
              children: [
                initAttendanceView(context, currentBloc),
                ScrollingMapPage(attendance),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            color: AppThemeUtils.colorPrimary,
                            padding: EdgeInsets.only(bottom: 0, top: 10),
                            child: Column(
                              children: [
                                // Container(
                                //     margin: EdgeInsets.only(
                                //         top: 10, right: 10, left: 10),
                                //     width: MediaQuery
                                //         .of(context)
                                //         .size
                                //         .width,
                                //     child: Center(
                                //         child:
                                //         ConfirmationSlider(
                                //           foregroundColor:
                                //           AppThemeUtils.colorPrimary,backgroundColorEnd: AppThemeUtils.colorPrimaryClient,
                                //           height: 60,
                                //           width: MediaQuery
                                //               .of(context)
                                //               .size
                                //               .width >
                                //               400
                                //               ? 400
                                //               : MediaQuery
                                //               .of(context)
                                //               .size
                                //               .width -
                                //               50,
                                //           onConfirmation: () {
                                //             currentBloc.patchStart(
                                //                 context, attendance);
                                //           },
                                //           text: StringFile.iniciarAtendimento,
                                //         )
                                //     )),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: SelectableText(
                                      Utils?.addressFormatMyData(
                                          attendance?.address),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: AppThemeUtils.normalSize(
                                          color: AppThemeUtils.whiteColor,
                                          fontSize: 20),
                                    )),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    margin: EdgeInsets.only(
                                        right: 30,
                                        left: 30,
                                        bottom: 10,
                                        top: 0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: AppThemeUtils.whiteColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              side: BorderSide(
                                                  color:
                                                      AppThemeUtils.whiteColor,
                                                  width: 1)),
                                        ),
                                        onPressed: () {

                                          currentBloc.inLocal(context,attendance);
                                        }
                                        //  AttendanceUtils.goToHome(context);
                                        ,
                                        child: AutoSizeText(
                                          StringFile.cheguei,
                                          minFontSize: 8,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: AppThemeUtils.normalBoldSize(
                                            color: AppThemeUtils.colorPrimary,
                                          ),
                                        ))),
                              ],
                            )),
                        Container(
                            color: AppThemeUtils.whiteColor,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              children: [
                                attendance.hourAttendance == null
                                    ? SizedBox()
                                    : Expanded(
                                        child: buildNotInitNow(
                                            context, attendance, currentBloc,
                                            height: 45),
                                      ),
                                kIsWeb
                                    ? SizedBox()
                                    : Expanded(
                                        child: Container(
                                            height: 45,
                                            margin: EdgeInsets.only(
                                                right: 10,
                                                left: 10,
                                                bottom: 10,
                                                top: 0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: AppThemeUtils
                                                      .colorPrimary,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      side: BorderSide(
                                                          color: AppThemeUtils
                                                              .whiteColor,
                                                          width: 1)),
                                                ),
                                                onPressed: () {
                                                  LocationUtils
                                                          .getCoordenateWithAttendance(
                                                              attendance)
                                                      .then((value) {
                                                    LocationUtils.navigateTo(
                                                        context,
                                                        ObjectUtils.parseToDouble(
                                                            (value?.latitude ??
                                                                    attendance
                                                                        ?.address
                                                                        ?.latitude)
                                                                .toString()),
                                                        ObjectUtils.parseToDouble(
                                                            (value?.longitude ??
                                                                    attendance
                                                                        ?.address
                                                                        ?.longitude)
                                                                .toString()));
                                                  });
                                                }
                                                //  AttendanceUtils.goToHome(context);
                                                ,
                                                child: AutoSizeText(
                                                  StringFile.abrirGps,
                                                  minFontSize: 8,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: AppThemeUtils
                                                      .normalBoldSize(
                                                    color: AppThemeUtils
                                                        .whiteColor,
                                                  ),
                                                ))),
                                      )
                              ],
                            ))
                      ],
                    )),
              ],
            );
    } catch (e) {
      print(e);
      return Container();
    }
  }

  Widget initAttendanceView(
      BuildContext context, MyCurrentAttendanceBloc currentBloc) {
    return ViewAttendanceWidget(
      childTop: null,
      childCenter: CenterViewAttendance(
          image: ImagePath.imagePlay,
          title: StringFile.arrasteObotao +
              "${ActivityUtils.getStatusName(this.attendance.status).toLowerCase()}",
          subtitle: Column(
            children: [
              buildNotInitNow(context, attendance, currentBloc),
            ],
          )),
      childBottom: Container(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Center(
            child: ConfirmationSlider(
              width: MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width - 50,
              height: 60,
              backgroundColorEnd: AppThemeUtils.colorPrimaryClient,
              foregroundColor: AppThemeUtils.colorPrimary,
              onConfirmation: () {
                currentBloc.patchStart(context, attendance);
              },
              text: StringFile.iniciarAtendimento,
            ),
          )),
    );
  }
}
