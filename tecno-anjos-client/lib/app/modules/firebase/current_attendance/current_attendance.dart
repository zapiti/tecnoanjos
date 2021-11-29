import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';


import 'package:tecnoanjosclient/app/components/dialog_hatting.dart';

import 'package:tecnoanjosclient/app/components/state_view/empty_view_mobile.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_alter_called_client.dart';

import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_init.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_progress.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_qrcode.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_refused.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';

import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';





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
          emptyMessage: StringFile.vocenaoEstaEmAtendimento);
    } else {
      if (ActivityUtils.isInit(widget.attendance)) {
        return StageInit(widget.attendance, actionInitAttendance: (tabBar) {

        });
      } else if (ActivityUtils.isQrCode(widget.attendance)) {
        return StageQrCode(widget.attendance);
      } else if (ActivityUtils.isInProgress(widget.attendance)) {
        return ProgressHUD(child: StageProgress(widget.attendance));
      } else if (ActivityUtils.isAlterClient(widget.attendance)) {
        return StageReviewCalledTecno(widget.attendance);
      } else if (ActivityUtils.isAlterTecno(widget.attendance)) {
        return StageReviewCalledTecno(widget.attendance);
      } else if (ActivityUtils.isRefusedTecno(widget.attendance)) {
        return StageReviewCalledTecnoRefuzed(widget.attendance);
      } else if (ActivityUtils.isRefused(widget.attendance)) {
        return StageReviewCalledTecno(widget.attendance);
      } else if (ActivityUtils.isReceipt(widget.attendance)) {
        return StageReceipt(widget.attendance);
      } else if (ActivityUtils.isCancellClient(widget.attendance)) {
        return StageReceipt(widget.attendance);
      } else if (ActivityUtils.isCancellTecno(widget.attendance)) {
        return StageReceipt(widget.attendance);
      } else if (ActivityUtils.isEvaluation(widget.attendance)) {
        return EvaluateAttendanceView(widget.attendance);
      } else {
        Modular.get<FirebaseClientTecnoanjo>().removeCollection();
        return emptyViewMobile(context,
            emptyMessage: StringFile.vocenaoEstaEmAtendimento);
      }
    }
  }



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    // });
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: generateView(context),
    );
  }
}
