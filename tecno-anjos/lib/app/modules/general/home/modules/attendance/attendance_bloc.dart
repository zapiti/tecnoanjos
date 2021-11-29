import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/core/attendance_repository.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'models/attendance.dart';

class AttendanceBloc extends Disposable {
  var totalAttendance = BehaviorSubject<int>.seeded(0);
  var listAttendanceInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempAttendance = List<Attendance>.from([]);
  var totalCancel = BehaviorSubject<int>.seeded(0);
  var listCancelInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempCancel = List<Attendance>.from([]);
  var totalSchedule = BehaviorSubject<int>.seeded(0);
  var listScheduleInfo = BehaviorSubject<ResponsePaginated>();
  var detailAttendance = BehaviorSubject<ResponsePaginated>();
  var _listTempSchendule = List<Attendance>.from([]);
  var _repository = Modular.get<AttendanceRepository>();
  var listScheduleTotalInfo = BehaviorSubject<List<Attendance>>();

  getListAttendance({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
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

    await Future.delayed(
        Duration(milliseconds: 100), () => listAttendanceInfo.sink.add(result));
  }

  getListSchedule(
      {int page = 0, bool isFilter = false, bool containsTotal = false}) async {
    listScheduleTotalInfo.sink.add(null);
    if (page == 0 || isFilter) {
      listScheduleInfo.sink.add(null);
      if (_listTempSchendule.isNotEmpty) _listTempSchendule.clear();
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
    listScheduleTotalInfo.sink.add(ObjectUtils.parseToObjectList<Attendance>(
        result.content ?? <Attendance>[]));

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

  getDetailsAttendance(int codAttendance,Function(Attendance) onSuccess) async {
    showLoading(true);
    detailAttendance.sink.add(null);
    var detail = await _repository.getDetailsAttendance(codAttendance);
    showLoading(false);
    detailAttendance.sink.add(detail);
    onSuccess(detail.content);
  }

  @override
  void dispose() {
    listAttendanceInfo?.drain();
    listScheduleInfo?.drain();
    detailAttendance?.drain();
    listScheduleTotalInfo?.drain();
    listCancelInfo?.drain();
    _listTempAttendance.clear();
    _listTempCancel.clear();
    if (_listTempSchendule.isNotEmpty) _listTempSchendule.clear();
    totalAttendance.drain();
    totalCancel.drain();
    totalSchedule.drain();
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
}
