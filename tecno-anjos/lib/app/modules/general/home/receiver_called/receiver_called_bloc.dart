import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';

import 'core/receiver_called_repository.dart';

class ReceiverCalledBloc extends Disposable {
  var listReceivers = BehaviorSubject<ResponsePaginated>();
  var _repository = Modular.get<ReceiverCalledRepository>();
  var inCall = BehaviorSubject<bool>.seeded(false);

  @override
  void dispose() {
    listReceivers.drain();
    inCall.drain();
  }

  getListReceivers({bool load = true, int page = 1}) async {
    if (load) {
      listReceivers.sink.add(null);
    }

    var listReceiver = await _repository.getLisCalled();
    listReceivers.sink.add(listReceiver);
    var attendanceBloc = Modular.get<AttendanceBloc>();
    attendanceBloc.getListSchedule();
  }

  refuseCalled(BuildContext context, int codAttendance, DateTime hour,
      Function onSuccess) async {
    showLoading(true);
    var result = await _repository.refusedCalled(codAttendance);
    showLoading(false);

    if (result.error == null && result.content != null) {

      getListReceivers();
      Future.delayed(Duration(seconds: 1),(){
        var currentBloc =  GetIt.I.get<MyCurrentAttendanceBloc>();
        currentBloc.deleteAwait(context,Attendance(id: codAttendance));
      });

      onSuccess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {
            getListReceivers();
            //  onSuccess();
          },
          positiveText: StringFile.OK);
    }
  }

  acceptCalled(BuildContext context, Attendance attendance, DateTime hour,
      Function onSuccess) async {
    showLoading(true);
    var result = await _repository.acceptCalled(attendance);
    showLoading(false);
    if (result.error == null && result.content != null) {
      getListReceivers(load: false);

      if (attendance.hourAttendance == null) {
        var status = ActivityUtils.PRESENCIAL;
        if (attendance?.address == null &&
            (attendance.fullAddress ?? "") == "") {
          status = ActivityUtils.REMOTAMENTE;
        }

        attendance.status = status;
        var startCalledBloc = Modular.get<StartCalledBloc>();
        var _dateTime = MyDateUtils.getTrueTime();
          startCalledBloc.alterStatus(context,
              ActivityUtils.generateBody(attendance, _dateTime, _dateTime), () {
        });
      } else {
        getListReceivers(load: false);
        showGenericDialog(
            context: context,
            title: StringFile.sucesso,
            description: StringFile.agendadoPara +
                "${hour != null ? MyDateUtils.parseDateTimeFormat(hour, null, format: "dd/MM/yyyy HH:mm") : StringFile.maisbreve}",
            iconData: Icons.check_circle,
            positiveCallback: () {
              getListReceivers(load: true);
              onSuccess();
            },
            positiveText: StringFile.OK);
      }
    } else {

      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {
            getListReceivers();
            //  onSuccess();
          },
          positiveText: StringFile.OK);
    }
  }

//  void aceptAttendance() {
//    if(context == null){

//  }
}
