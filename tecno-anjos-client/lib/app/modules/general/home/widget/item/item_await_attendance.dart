import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';

import 'package:tecnoanjosclient/app/components/ntp_time/ntp_time_component.dart';
import 'package:tecnoanjosclient/app/components/timers/time_view.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/page/await_page.dart';


import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../../../../app_bloc.dart';


Widget itemAwaitAttendance(Attendance response) {
  var attendanceBloc = Modular.get<AttendanceBloc>();

  return attendanceWidget(response, attendanceBloc);
}

Widget itemAttendanceAccept(Attendance response) {
  return Material(
      child: Container(
          color: Colors.black,
          child: Center(
            child: Container(
                width: 700,
                child: Material(
                    color: Colors.transparent,
                    child: WidgetDialogGeneric(
                        color: AppThemeUtils.whiteColor,
                        iconData: Icons.notifications_active,
                        title: StringFile.atendimentoAceito,
                        containsPop: false,
                        positiveCallback: () {
                          Modular.get<FirebaseClientTecnoanjo>()
                              .removeAcceptCollection();
                        },
                        positiveText: StringFile.ok,
                        description: ReceiptCard2(
                          response,
                          true,
                          null,
                          showImage: true,
                        )))),
          )));
}

Widget attendanceWidget(Attendance response, AttendanceBloc attendanceBloc) {
  if (response?.userTecno?.id != null) {
    Modular.get<FirebaseClientTecnoanjo>().deleteMyAttendanceOnAwait();
  }
  return SingleChildScrollView(
      child: NtpTimeComponent(buildTime: (context, _dateTime) {
    // if (_dateTime == null) {
    //   return loadElements(context);
    // } else {
    if (response == null) {
      return Container();
    } else {
      Attendance attendance = response;
      if (attendance == null) {
        return Container();
      } else {
        final appBloc = Modular.get<AppBloc>();
        appBloc.openAwaitPopup.sink.add(true);
        try {
          return Container(
              color: Colors.white,
              child: Column(children: [
                Container(
                    color: AppThemeUtils.colorPrimary,
                    child: InkWell(
                        onTap: () {
//                          if (attendance.userTecno?.id != null) {
//                            Modular.to
//                                .pushNamed(ConstantsRoutes.ATENDIMENTO_ATUAL);
//                          } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AwaitPage(attendance)));
                          //   }
                        },
                        child: Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Stack(
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      height: 90,
                                      child: Center(
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 5),
                                              width: 80,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(90)),
                                                  border: Border.all(
                                                      width: 3,
                                                      color: AppThemeUtils
                                                          .whiteColor,
                                                      style:
                                                          BorderStyle.solid)),
                                              child: NtpTimeComponent(
                                                  periodic: true,
                                                  buildTime:
                                                      (_context, _dateTime) {
                                                    if (_dateTime == null) {
                                                      return loadElements(
                                                          context);
                                                    } else {
                                                      return Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 15),
                                                          child: StreamBuilder<
                                                                  int>(
                                                              stream: attendanceBloc
                                                                  .qtdTimeCancellInSeconds,
                                                              builder: (context,
                                                                      snapshot) =>
                                                                  Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              15),
                                                                      child: (snapshot.data ?? -1) <
                                                                              0
                                                                          ? SizedBox()
                                                                          : TimerView(
                                                                              dateInit: MyDateUtils.compareDateNowDatime(attendance?.createdAt, _dateTime, dateEnd: _dateTime, isSegunds: true),
                                                                              reverse: true,
                                                                              maxSizeSeconds: snapshot.data ?? 0,
                                                                              actionPlay: () {},
                                                                              actionPause: () {},
                                                                              actionStop: () {
                                                                                var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
                                                                                currentBloc.patchCancelCurrentAttendance(context, attendance);
                                                                              },
                                                                              color: AppThemeUtils.colorPrimary,
                                                                              observableTime: (time) {
                                                                                //widget.attendance.dateInit = time;
                                                                              },
                                                                            ))));
                                                    }
                                                  }))))
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 15, top: 15, right: 15),
                                      child: AutoSizeText(
                                        attendance.userTecno?.id != null
                                            ? attendance.dateInit != null
                                                ? StringFile.chamadoEmAndamento
                                                : StringFile
                                                    .chamadoEmAtendimento
                                            : StringFile.aguardandoSeuTecnoAnjo,
                                        minFontSize: 10,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: AppThemeUtils.normalBoldSize(
                                            color: AppThemeUtils.whiteColor,
                                            fontSize: 18),
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //       left: 15, top: 15, bottom: 20),
                                    //   child: AutoSizeText(
                                    //     StringFile.cliqueParaVer,
                                    //     maxLines: 1,
                                    //     minFontSize: 10,
                                    //     maxFontSize: 14,
                                    //     style: AppThemeUtils.normalBoldSize(
                                    //         color: AppThemeUtils.whiteColor),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ]))),
                attendance.dateInit == null
                    ? LinearProgressIndicator()
                    : SizedBox(),
                Container(
                    color: AppThemeUtils.whiteColor,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          SizedBox(
                            height: 15,
                          ),
                          imageWithBgWidget(context, ImagePath.icSearch),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: 300,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                StringFile.estamosProcurando,
                                style: AppThemeUtils.normalSize(fontSize: 26),
                                textAlign: TextAlign.center,
                              )),
                          Container(
                              width: 200,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Text(
                                StringFile.embreveAtendimentoSeraAceito,
                                style: AppThemeUtils.normalSize(fontSize: 14),
                                textAlign: TextAlign.center,
                              )),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      padding: EdgeInsets.all(15),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          var currentBloc = GetIt.I
                                              .get<MyCurrentAttendanceBloc>();
                                          currentBloc
                                              .patchCancelCurrentAttendance(
                                                  context, attendance);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: AppThemeUtils.colorError,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0))),
                                        child: Container(
                                            height: 45,
                                            child: Center(
                                                child: Text(
                                              StringFile.cancelar,
                                              textAlign: TextAlign.center,
                                              style: AppThemeUtils.normalSize(
                                                  color:
                                                      AppThemeUtils.whiteColor),
                                            ))),
                                      ))),
                              Expanded(
                                  child: Container(
                                      padding: EdgeInsets.all(15),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AwaitPage(attendance)));

                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: AppThemeUtils.colorPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0))),
                                        child: Container(
                                            height: 45,
                                            child: Center(
                                                child: Text(
                                              StringFile.detalhe,
                                              style: AppThemeUtils.normalSize(
                                                  color:
                                                      AppThemeUtils.whiteColor),
                                            ))),
                                      )))
                            ],
                          ),
                          StreamBuilder<int>(
                              stream: attendanceBloc.qtdTimeCancellInMin,
                              builder: (context, snapshot) => Container(
                                  width: 300,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: "",
                                        style: AppThemeUtils.normalSize(
                                            fontSize: 26),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: StringFile
                                                  .agendamentoSeraCancelado,
                                              style: AppThemeUtils.normalSize(
                                                  fontSize: 14,
                                                  color: AppThemeUtils.black)),
                                          TextSpan(
                                              text: " ${snapshot.data ?? 0} ",
                                              style:
                                                  AppThemeUtils.normalBoldSize(
                                                      fontSize: 14,
                                                      color:
                                                          AppThemeUtils.black)),
                                          TextSpan(
                                              text: StringFile.minutosEmEspera,
                                              style: AppThemeUtils.normalSize(
                                                  fontSize: 14,
                                                  color: AppThemeUtils.black)),
                                        ],
                                      )))),
                        ]))),
              ]));
        } catch (e) {
          print(e);
          return Container();
        }
      }
      // }
    }
  }));
}
