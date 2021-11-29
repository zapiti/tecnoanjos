
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/dialog_hatting.dart';
import 'package:tecnoanjostec/app/components/state_view/empty_view_mobile.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_alter_called_tecno.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_init.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_progress.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_qrcode.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_refused.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';


class CurrentAttendance extends StatefulWidget {
  final Attendance attendance;

  CurrentAttendance(this.attendance);

  @override
  _CurrentAttendanceState createState() => _CurrentAttendanceState();
}

class _CurrentAttendanceState extends State<CurrentAttendance> {
  Widget generateView(BuildContext context) {
    if (widget.attendance == null) {
      Modular.get<FirebaseClientTecnoanjo>().removeCollection();
      return emptyViewMobile(context,
          emptyMessage: "Você não esta em atendimento");
    } else {
      if (ActivityUtils.isInit(widget.attendance)) {
        //
        return StageInit(widget.attendance, actionInitAttendance: (tabBar) {

        });
      } else if (ActivityUtils.isQrCode(widget.attendance)) {
        return StageQrCode(widget.attendance);
      } else if (ActivityUtils.isInProgress(widget.attendance)) {
        return StageProgress(widget.attendance);
      } else if (ActivityUtils.isReviewClient(widget.attendance)) {
        return StageReviewCalledTecno(widget.attendance);
      } else if (ActivityUtils.isReviewClient(widget.attendance)) {
        return StageReviewCalledTecno(widget.attendance);
      } else if (ActivityUtils.isFinished(widget.attendance)) {
        return StageProgress(widget.attendance);
      } else if (ActivityUtils.isRefusedTecno(widget.attendance)) {
        return StageRefuzed(widget.attendance);
      } else if (ActivityUtils.isCancelClient(widget.attendance)) {
        return StageReceipt(widget.attendance);
      } else if (ActivityUtils.isCancelTecno(widget.attendance)) {
        return StageReceipt(widget.attendance);
      } else if (ActivityUtils.isReceipt(widget.attendance)) {
        return StageReceipt(widget.attendance);
      } else if (ActivityUtils.isEvaluation(widget.attendance)) {
        return EvaluateAttendanceView(widget.attendance);
      } else {
        Modular.get<FirebaseClientTecnoanjo>().removeCollection();
        return emptyViewMobile(context,
            emptyMessage: "Você não esta em atendimento");
      }
    }
  }

  var startCalledBloc = Modular.get<StartCalledBloc>();
  var appBloc = Modular.get<AppBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: generateView(context),
    );
  }
}
