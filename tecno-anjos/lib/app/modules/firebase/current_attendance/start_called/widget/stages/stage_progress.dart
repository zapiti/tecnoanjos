import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:tecnoanjostec/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjostec/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjostec/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/meet/jitsi_meet_call_widget.dart';

import '../../current_attendance_bloc.dart';
import '../../start_called_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import 'package:tecnoanjostec/app/components/card_call_teamview.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/load/load_elements.dart';
import 'package:tecnoanjostec/app/components/ntp_time/ntp_time_component.dart';
import 'package:tecnoanjostec/app/components/timers/time_view.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class StageProgress extends StatelessWidget {
  final startCalledBloc = Modular.get<StartCalledBloc>();
  final Attendance attendance;

  StageProgress(this.attendance);

  @override
  Widget build(BuildContext context) {
    return PageProgressAttendance(attendance);
  }
}

class PageProgressAttendance extends StatefulWidget {
  final Attendance attendance;

  PageProgressAttendance(this.attendance);

  @override
  _PageProgressAttendanceState createState() => _PageProgressAttendanceState();
}

class _PageProgressAttendanceState extends State<PageProgressAttendance> {
  final currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
  final qrdataFeed = TextEditingController();
  Timer _timer;
  int _start = 180;

  void startTimer() {
    if (!ActivityUtils.isCancelTecno(widget.attendance)) {
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => mounted
            ? setState(
                () {
                  if (_start < 1) {
                    var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
                    currentBloc.patchConcludeClient(context, widget.attendance);
                    timer?.cancel();
                  } else {
                    _start = _start - 1;
                  }
                },
              )
            : () {},
      );
    }
  }

  @override
  void didUpdateWidget(covariant PageProgressAttendance oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.attendance.status == ActivityUtils.ENCERRADO) {
      startTimer();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.attendance.status == ActivityUtils.ENCERRADO) {
      startTimer();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.attendance.status == ActivityUtils.EM_ATENDIMENTO
        ? _AttendanceBodyCircle(currentBloc, widget.attendance, _start)
        : _AttendanceBody(currentBloc, widget.attendance, _start);
  }
}

class _AttendanceBody extends StatelessWidget {
  final MyCurrentAttendanceBloc currentAttendanceBloc;

  final Attendance attendance;
  final int start;

  _AttendanceBody(this.currentAttendanceBloc, this.attendance, this.start);

  @override
  Widget build(BuildContext context) {
    var hideView = (attendance.dateEnd == null ||
        attendance.status == ActivityUtils.EM_ATENDIMENTO);
    return ViewAttendanceWidget(
      childTop: null,
      childCenter: CenterViewAttendance(
          image: ImagePath.inAttendance,
          title: hideView ? StringFile.voceEstaEmAtendimento : "",
          subtitle: Column(children: [
            hideView ? cardCallTeamView(attendance) : SizedBox(),
            hideView
                ? Container(
                    child: Text(StringFile.voceEstaEmAtendimento,
                        textAlign: TextAlign.center,
                        style: AppThemeUtils.normalSize(fontSize: 18)))
                : SizedBox(),
            hideView
                ? _componenteCircle(context, attendance)
                : _endingView(context,attendance, "($start)"),
            attendance?.address?.id != null
                ? SizedBox()
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: JitsiMeetCallWidget(attendance)),
          ])),
      childBottom: hideView
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Center(
                  child: ConfirmationSlider(
                width: MediaQuery.of(context).size.width > 400
                    ? 400
                    : MediaQuery.of(context).size.width - 50,backgroundColorEnd: AppThemeUtils.colorPrimaryClient,
                foregroundColor: AppThemeUtils.colorPrimary,
                height: 60,
                onConfirmation: () {
                  currentAttendanceBloc.patchEnd(context, attendance);
                },
                text: StringFile.finalizarAtendimento,
              )))
          : null,
    );
  }
}

Column _endingView(BuildContext context,Attendance attendance, String ending) {
  return Column(
    children: [
      Container(
          margin: EdgeInsets.only(right: 30, left: 30, top: 0, bottom: 10),
          child: Text(
            StringFile.seuAtendimentoFinalizado,
            style: AppThemeUtils.normalSize(fontSize: 20),
            textAlign: TextAlign.center,
          )),
      lineViewWidget(),
      titleDescriptionWebListWidget(context,
          title: null,wrap: true,
          description:
          attendance?.attendanceItems?.map<String>((e) => e.name)?.toList()),
      // Container(
      //     margin: EdgeInsets.only(right: 30, left: 30, top: 20, bottom: 0),
      //     child: Text(
      //       StringFile.tempoEmAtendimento,
      //       style: AppThemeUtils.normalSize(fontSize: 16),
      //       textAlign: TextAlign.center,
      //     )),
      // d
      // Container(
      //     margin: EdgeInsets.only(right: 30, left: 30, top: 10, bottom: 20),
      //     child: Text(
      //       "${MyDateUtils.durationToStringHours(MyDateUtils.compareDateNowDateTime(attendance.dateInit, null, dateEnd: attendance.dateEnd, isSegunds: true))} ",
      //       style: AppThemeUtils.normalSize(
      //           fontSize: 20, color: AppThemeUtils.colorPrimary),
      //       textAlign: TextAlign.center,
      //     )),
      lineViewWidget(),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(
            ending == "(0)"
                ? StringFile.aguardeInternet
                : StringFile.aguardarValidacao +
                    " " +
                    StringFile.aguardarValidacaoPt2 +
                    ending,
            style: AppThemeUtils.normalSize(fontSize: 18),
            textAlign: TextAlign.center,
          )),
      ending == "(0)"
          ? Container(
              margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 0),
                onPressed: () {
                  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
                  currentBloc.updateCurrentAttendance(null);
                },
                child: Text(
                  StringFile.sair,
                  style: AppThemeUtils.normalBoldSize(
                    color: AppThemeUtils.colorPrimary,
                  ),
                ),
              ),
            )
          : SizedBox()
    ],
  );
}

class _AttendanceBodyCircle extends StatelessWidget {
  final MyCurrentAttendanceBloc currentAttendanceBloc;
  final int start;
  final Attendance attendance;

  _AttendanceBodyCircle(
      this.currentAttendanceBloc, this.attendance, this.start);

  @override
  Widget build(BuildContext context) {
    var hideView = (attendance.dateEnd == null ||
        attendance.status == ActivityUtils.EM_ATENDIMENTO);
    return ViewAttendanceWidget(
      childTop: null,
      childCenter: CenterViewAttendance(
          image: !hideView ? ImagePath.imageThanks : null,
          title: !hideView ? "" : StringFile.em_atendimento,
          subtitle: Column(children: [

            hideView
                ? Column(
                    children: [
                      titleDescriptionWebListWidget(context,
                          title: null,wrap: true,
                          description:
                         attendance?.attendanceItems?.map<String>((e) => e.name)?.toList()),
                      // _componenteCircle(context, attendance),
                      attendance?.address?.id != null
                          ? SizedBox()
                          : Container(
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: JitsiMeetCallWidget(attendance)),
                      cardCallTeamView(attendance),
                      // chatField(attendance),
                    ],
                  )
                : _endingView(context,attendance, "($start)"),

          ])),
      childBottom: hideView
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Center(
                  child: ConfirmationSlider(
                width: MediaQuery.of(context).size.width > 400
                    ? 400
                    : MediaQuery.of(context).size.width - 50,backgroundColorEnd: AppThemeUtils.colorPrimaryClient,
                foregroundColor: AppThemeUtils.colorPrimary,
                height: 60,
                onConfirmation: () {
                  currentAttendanceBloc.patchEnd(context, attendance);
                },
                text: StringFile.finalizarAtendimento,
              )))
          : null,
    );
  }
}

Center _componenteCircle(BuildContext context, Attendance attendance) {
  return Center(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: Border.all(
                  width: 3,
                  color: AppThemeUtils.colorPrimary,
                  style: BorderStyle.solid)),
          child: NtpTimeComponent(
              periodic: true,
              buildTime: (_context, _dateTime) {
                if (_dateTime == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      loadElements(context),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: AutoSizeText(
                            "Estabelecendo \nconexão de horario local!\nVocê já está em atendimento não se preocupe!",
                            style: AppThemeUtils.normalSize(
                                fontSize: 6, color: AppThemeUtils.colorPrimary),
                            textAlign: TextAlign.center,
                          ))
                    ],
                  );
                } else {
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: TimerView(
                        dateInit: MyDateUtils.compareDateNowDateTime(
                            attendance?.dateInit, _dateTime,
                            dateEnd: _dateTime, isSegunds: true),
                        actionPlay: () {},
                        actionPause: () {},
                        actionStop: () {},
                        color: AppThemeUtils.colorPrimary,
                        observableTime: (time) {
                          //widget.attendance.dateInit = time;
                        },
                      ));
                }
              })));
}
