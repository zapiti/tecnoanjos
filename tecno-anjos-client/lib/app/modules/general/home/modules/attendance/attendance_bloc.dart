import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';

import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';

import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';


import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';

import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';

import 'core/attendance_repository.dart';
import 'models/attendance.dart';

class AttendanceBloc extends Disposable {
  //dispose will be called automatically by closing its streams
  var totalAttendance = BehaviorSubject<int>.seeded(0);
  var listAttendanceInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempAttendance = List<Attendance>.from([]);

  //-
  var totalCancel = BehaviorSubject<int>.seeded(0);
  var listCancelInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempCancel = List<Attendance>.from([]);

  //-
  var totalSchedule = BehaviorSubject<int>.seeded(0);
  var listScheduleInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempSchendule = List<Attendance>.from([]);

  var _repository = Modular.get<AttendanceRepository>();

  var listScheduleTotalInfo = BehaviorSubject<List<Attendance>>();
  var detailAttendance = BehaviorSubject<ResponsePaginated>();

  var qtdTimeCancellInSeconds = BehaviorSubject<int>.seeded(0);
  var qtdTimeCancellInMin = BehaviorSubject<int>.seeded(0);

  var temporary = BehaviorSubject<bool>.seeded(false);

// var totalHoursSchedule = BehaviorSubject<String>();

  getListAttendance({int page = 1, bool isFilter = false}) async {
    if (page == 1 || isFilter) {
      listAttendanceInfo.sink.add(null);
      _listTempAttendance.clear();
    }
    var result = await _repository.getListAttendance(page: page);
    var listTemp = List<Attendance>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<Attendance>(result.content));
    }

    _listTempAttendance.addAll(listTemp);
    _listTempAttendance = _listTempAttendance.toSet().toList();
    if (page != 0) {
      result.content = (_listTempAttendance);
    }
    totalAttendance.sink.add(result?.content?.length ?? 0);

    // getTotalHoursWorked(type: ActivityUtils.FINALIZADO);
    await Future.delayed(
        Duration(milliseconds: 100), () => listAttendanceInfo.sink.add(result));
  }

  getListSchedule({int page = 0, bool isFilter = false}) async {
    listScheduleTotalInfo.sink.add(null);
    if (page == 0 || isFilter) {
      listScheduleInfo.sink.add(null);
      _listTempSchendule.clear();
    }
    var result = await _repository.getListSchedule(page: page);
    var listTemp = List<Attendance>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<Attendance>(result.content));
    }
    _listTempSchendule.addAll(listTemp);
    _listTempSchendule = _listTempSchendule.toSet().toList();
    if (page != 0) {
      result.content = (_listTempSchendule);
    }
    totalSchedule.sink.add(result?.content?.length ?? 0);
    listScheduleTotalInfo.sink
        .add(ObjectUtils.parseToObjectList<Attendance>(result.content));

    //  getTotalHoursWorked(type: ActivityUtils.EM_ATENDIMENTO);
    await Future.delayed(
        Duration(milliseconds: 100), () => listScheduleInfo.sink.add(result));
  }

  getListCancel({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      listCancelInfo.sink.add(null);
      _listTempCancel.clear();
    }
    var result = await _repository.getListCancel(page: page);
    var listTemp = List<Attendance>.from([]);
    if (result.error == null) {
      listTemp
          .addAll(ObjectUtils.parseToObjectList<Attendance>(result.content));
    }
    _listTempCancel.addAll(listTemp);
    _listTempCancel = _listTempCancel.toSet().toList();
    if (page != 0) {
      result.content = (_listTempCancel);
    }
    totalCancel.sink.add(result?.content?.length ?? 0);

    await Future.delayed(
        Duration(milliseconds: 100), () => listCancelInfo.sink.add(result));
  }

  @override
  void dispose() {
    temporary.drain();
    listAttendanceInfo?.drain();
    listScheduleInfo?.drain();
    listScheduleTotalInfo?.drain();
    listCancelInfo?.drain();
    _listTempAttendance.clear();
    _listTempCancel.clear();
    _listTempSchendule.clear();
    totalAttendance.drain();
    totalCancel.drain();
    totalSchedule.drain();
    qtdTimeCancellInSeconds.drain();
    qtdTimeCancellInMin.drain();
    //  totalHoursSchedule.drain();
    detailAttendance.drain();
  }

  Future<List> filterElement(List<Attendance> listAttendance,
      {String filter = "T"}) async {
    List<Attendance> items = List<Attendance>.from([]);
    listAttendance.forEach((element) {
      if (ActivityUtils.getWithTypeFake(element.hourAttendance, filter)) {
        items.add(element);
      }
    });
    totalSchedule.sink.add(items.length ?? 0);
    return items;
  }

  cancelAttendance(
      BuildContext context, Attendance attendance, VoidCallback sucess) async {
    var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
    currentBloc.patchCancelCurrentAttendance(context, attendance);
    // showGenericDialog(
    //     context: context,
    //     title: StringFile.atencao,
    //     description: StringFile.desejaCancelar,
    //     iconData: Icons.error_outline,
    //     positiveCallback: () {
    //       return aceptEndCancellAttendance(context, attendance, sucess);
    //     },
    //     positiveText: StringFile.sim,
    //     negativeCallback: () {
    //       return false;
    //     });
  }

  getTimeMaxHoursCancell(Attendance attendance) async {
    var detail = await _repository.getTimeMaxHoursCancell();
    var currentHours = await MyDateUtils.getTrueTime();
    var seconds = MyDateUtils.compareDateNowDatime(
        attendance.createdAt, currentHours ?? DateTime.now(),
        isSegunds: true);

    var result = detail - seconds;
    qtdTimeCancellInMin.sink.add(ObjectUtils.parseToInt(detail));
    qtdTimeCancellInSeconds.sink
        .add(ObjectUtils.parseToInt(result < 0 ? 0 : result));
  }

  getDetailsAttendance(int codAttendance,Function(Attendance) onSuccess) async {
    showLoading(true);
    detailAttendance.sink.add(null);
    var detail = await _repository.getDetailsAttendance(codAttendance);
    showLoading(false);
    detailAttendance.sink.add(detail);
    onSuccess(detail.content);
  }

// Future<bool> _cancellAttendance(
//     BuildContext context, Attendance attendance, VoidCallback sucess) async {
//   showLoading(true);
//
//   var result = await _repository.cancelAttendance(attendance);
//
//   showLoading(false);
//   if (result.error == null) {
//     sucess();
//     return true;
//   } else {
//     showGenericDialog(
//         context: context,
//         title: StringFile.opps,
//         description: "${result.error}",
//         iconData: Icons.error_outline,
//         positiveCallback: () {},
//         positiveText: StringFile.ok);
//     return false;
//   }
// }

// Future<void> aceptEndCancellAttendance(
//     BuildContext context, Attendance attendance, Function() onSucess) async {
//   var startAttendanceBloc = Modular.get<StartCalledBloc>();
//
//   attendance.status = ActivityUtils.CANCELADO;
//   attendance.clientNF = true;
//   attendance.dateEnd = null;
//   attendance.dateInit = null;
//
//   startAttendanceBloc
//       .alterStatus(context, ActivityUtils.generateBody(attendance, null), () {
//     startAttendanceBloc.currentAttendance.sink.add(null);
//
//     startAttendanceBloc.awaitAttendanceTemp.sink.add(null);
//     // Modular.get<FirebaseClientTecnoanjo>().deleteMyAttendanceOnAwait();
//     // Modular.get<FirebaseClientTecnoanjo>().removeCollection();
//
//     onSucess();
//   });
// }
}
