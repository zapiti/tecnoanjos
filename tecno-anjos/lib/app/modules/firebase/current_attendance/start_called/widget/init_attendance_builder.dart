import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/load/load_elements.dart';
import 'package:tecnoanjostec/app/components/state_view/empty_view_mobile.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_alter_called_tecno.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/stages/stage_init.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import '../start_called_bloc.dart';
import 'stages/stage_progress.dart';
import 'stages/stage_qrcode.dart';
import 'stages/stage_receipt.dart';

class InitAttendanceBuilder {
  static Widget buildBodyAttendance(
      BuildContext context, Attendance attendance) {


    Widget generateView(BuildContext context, response) {
      Attendance attendance;
      if (response?.content is Attendance) {
        attendance = (response?.content);
      } else {
        if (response?.content is List) {
          if ((response?.content?.length ?? 0) > 0) {
            attendance = response?.content?.first;
          }
        }
      }
      if (attendance == null) {
        Modular.get<FirebaseClientTecnoanjo>().removeCollection();
        return emptyViewMobile(context,
            emptyMessage: StringFile.vocenaoEstaEmAtendimento);
      } else {
        if (ActivityUtils.isInit(attendance)) {
          return StageInit(attendance, actionInitAttendance: (tabBar) {

          });
        } else if (ActivityUtils.isQrCode(attendance)) {
          return StageQrCode(attendance);
        } else if (ActivityUtils.isInProgress(attendance)) {
          return StageProgress(attendance);
        }
        else if (ActivityUtils.isReviewClient(attendance)) {
          return StageReviewCalledTecno(attendance);
        } else if (ActivityUtils.isReviewClient(attendance)) {
          return StageReviewCalledTecno(attendance);
        } else if (ActivityUtils.isFinished(attendance)) {
          return StageProgress(attendance);
        }
          else if (ActivityUtils.isCancelClient(attendance)) {
          return StageReceipt(attendance);
        } else if (ActivityUtils.isCancelTecno(attendance)) {
          return StageReceipt(attendance);
        } else if (ActivityUtils.isReceipt(attendance)) {
          return StageReceipt(attendance);
        } else {

          Modular.get<FirebaseClientTecnoanjo>().removeCollection();
          return emptyViewMobile(context,
              emptyMessage:StringFile.vocenaoEstaEmAtendimento);
        }
      }
    }

    var startCalledBloc = Modular.get<StartCalledBloc>();
    return builderComponentSimple<ResponsePaginated>(
        stream: startCalledBloc.currentAttendance,
        emptyMessage: StringFile.voceNaoPossuiAtendimento,
        buildBodyFunc: (context, response) {
          if (response.content == null) {
         AttendanceUtils.goToHome(context);
            return loadElements(context);
          } else {
            return generateView(context, response);



          }
        });
  }
}
