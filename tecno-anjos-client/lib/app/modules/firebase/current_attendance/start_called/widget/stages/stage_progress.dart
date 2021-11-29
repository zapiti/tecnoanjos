import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjosclient/app/components/card_call_teamview.dart';

import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/chat_tecno_client/chat/chat_perspective.dart';

import 'package:tecnoanjosclient/app/modules/meet/jitsi_meet_call_widget.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import '../../start_called_bloc.dart';

class StageProgress extends StatelessWidget {
  final startCalledBloc = Modular.get<StartCalledBloc>();
  final Attendance attendance;

  StageProgress(this.attendance);

  @override
  Widget build(BuildContext context) {
    return _PageProgressAttendance(attendance);
  }
}

class _PageProgressAttendance extends StatefulWidget {
  final Attendance attendance;

  _PageProgressAttendance(this.attendance);

  final attendanceBloc = Modular.get<AttendanceBloc>();

  @override
  __PageProgressAttendanceState createState() =>
      __PageProgressAttendanceState();
}

class __PageProgressAttendanceState extends State<_PageProgressAttendance> {
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: ViewAttendanceWidget(
      childTop: null,
      // childTop: Center(
      //   child: Container(
      //     height: 80,
      //     child: Text(StringFile.emAtendimento,
      //         textAlign: TextAlign.center,
      //         style: AppThemeUtils.normalBoldSize(fontSize: 20)),
      //   ),
      // ),
      childCenter: CenterViewAttendance(
          title: StringFile.emAtendimento,
          subtitle: Column(
            children: [
              titleDescriptionWebListWidget(context,
                  title: null,
                  wrap: true,
                  description: widget.attendance?.attendanceItems
                      ?.map<String>((e) => e.name)
                      ?.toList()),
              // _componenteCircle(context, widget.attendance),

              widget.attendance?.address?.id != null
                  ? SizedBox()
                  : Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: JitsiMeetCallWidget(widget.attendance)),
              cardCallTeamView(widget.attendance),
              SizedBox(
                height: 0,
              ),
              SizedBox(
                height: 0,
              ),
              SizedBox(
                height: 15,
              ),
            ],
          )),
      childBottom: widget.attendance?.address?.id != null
          ? SizedBox()
          : chatField(
              widget.attendance,
              context,
            ),
    ));
  }
}

//   _attendanceBodyCircle(BuildContext context) {
//     return ViewAttendanceWidget(
//       childTop: Center(
//         child: Container(
//           height: 80,
//           child: Text(StringFile.em_atendimento,
//               textAlign: TextAlign.center,
//               style: AppThemeUtils.normalBoldSize(fontSize: 20)),
//         ),
//       ),
//       childCenter: ProgressHUD(
//           child: Column(
//             children: [
//               _componenteCircle(context,widget.attendance),
//               Container(
//                   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                   child: Text(
//                     "Aguardando seu Tecnoanjo solicitar o encerramento!",
//                     style: AppThemeUtils.normalSize(fontSize: 20),
//                     textAlign: TextAlign.center,
//                   )),
//               widget.attendance?.address?.id != null
//                   ? SizedBox()
//                   : Container(
//                   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//                   child: JtsiMeetCallWidget(widget.attendance)),
//               cardCallTeamView(widget.attendance),
//               SizedBox(
//                 height: 0,
//               ),
//               SizedBox(
//                 height: 0,
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//             ],
//           )),
//       childBottom: widget.attendance?.address?.id != null
//           ? SizedBox()
//           : chatField(widget.attendance, context,progress),
//     );
//   }
// }

// Center _componenteCircle(BuildContext context, Attendance attendance) {
//   return Center(
//       child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
//           width: 200,
//           height: 200,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(100)),
//               border: Border.all(
//                   width: 3,
//                   color: AppThemeUtils.colorPrimary,
//                   style: BorderStyle.solid)),
//           child: NtpTimeComponent(
//               periodic: true,
//               buildTime: (_context, _dateTime) {
//                 if (_dateTime == null) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       loadElements(context),
//                       Container(
//                           margin: EdgeInsets.symmetric(
//                             horizontal: 10,
//                           ),
//                           child: AutoSizeText(
//                             "Estabelecendo \nconexão de horario local!\nVocê já está em atendimento não se preocupe!",
//                             style: AppThemeUtils.normalSize(
//                                 fontSize: 6,
//                                 color: AppThemeUtils.colorPrimary),
//                             textAlign: TextAlign.center,
//                           ))
//                     ],
//                   );
//                 } else {
//                   return Container(
//                       margin: EdgeInsets.symmetric(vertical: 15),
//                       child: TimerView(
//                         dateInit: MyDateUtils.compareDateNowDatime(
//                             attendance?.dateInit, _dateTime,
//                             dateEnd: _dateTime, isSegunds: true),
//                         actionPlay: () {},
//                         actionPause: () {},
//                         actionStop: () {},
//                         color: AppThemeUtils.colorPrimary,
//                         observableTime: (time) {
//                           //widget.attendance.dateInit = time;
//                         },
//                       ));
//                 }
//               })));
// }
