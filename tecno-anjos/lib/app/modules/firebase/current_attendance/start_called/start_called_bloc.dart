import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';

import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';

import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/components/dialog_hatting.dart';

import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';


import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';

import 'package:tecnoanjostec/app/utils/date/date_utils.dart';

import 'package:tecnoanjostec/app/utils/string/string_file.dart';


import '../../../../app_bloc.dart';
import 'core/start_called_repository.dart';
import 'current_attendance_bloc.dart';

class StartCalledBloc extends Disposable {
  final _repository = Modular.get<StartCalledRepository>();
  final appBloc = Modular.get<AppBloc>();
  final profileBloc = Modular.get<ProfileBloc>();
  final showCalled = BehaviorSubject<bool>.seeded(false);
  final lastCalled = BehaviorSubject<Attendance>();
  var currentAttendance = BehaviorSubject<ResponsePaginated>();
  var tempAttendanceSchedulingAccept = BehaviorSubject<ResponsePaginated>();
  var isLoadAttendance = BehaviorSubject<bool>.seeded(false);
  var _finish = BehaviorSubject<bool>.seeded(false);
  var qrcodeSubject = BehaviorSubject<String>();
  var rating = BehaviorSubject<double>.seeded(5.0);
  var resenha = BehaviorSubject<String>.seeded("");

  var hideButton = BehaviorSubject<bool>.seeded(false);
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  void dispose() {
    currentAttendance.drain();
    qrcodeSubject.drain();
    isLoadAttendance.drain();
    lastCalled.drain();
    tempAttendanceSchedulingAccept.drain();
    hideButton.drain();
    rating.drain();
    resenha.drain();
    _finish.drain();
    showCalled.drain();
  }

  getQrCode(int codAttendance) async {
    if (!_finish.stream.value) {
      _finish.sink.add(true);
      qrcodeSubject.sink.add(null);
      var result = await _repository.getQrcode(codAttendance);
      qrcodeSubject.sink.add(result.content);
      _finish.sink.add(false);
    }
  }

  Future<void> checkContainsActivity() async {
    if (!(profileBloc.userInfos.stream.value?.isFirstLogin ?? true) &&
        profileBloc.isOnline.stream.value) {
      var response;
      if (tempAttendanceSchedulingAccept.stream.value == null) {
        response = await _repository.getAcceptCalled();
      } else {
        response = tempAttendanceSchedulingAccept.stream.value;
      }

      if (response.content != null) {
        if (tempAttendanceSchedulingAccept.stream.value != response.content) {
          tempAttendanceSchedulingAccept.sink.add(response);
        }
        tempAttendanceSchedulingAccept.sink.add(response);
      } else {
        tempAttendanceSchedulingAccept.sink.add(null);
      }
    }
  }

  void evalueteAction(
    BuildContext context,
    double rating,
    String resenha,
    Attendance attendance,
  ) async {
    var appBloc = Modular.get<AppBloc>();
    appBloc.addAvaliations.sink.add(true);

    //showLoadingDialog(context, title: "Salvando avaliação");
    await _repository.avaluateAttendance(context, resenha, rating, attendance);
    //   Navigator.of(context).pop();
  }

  void evalueateAttendance(BuildContext context, Attendance attendance) {
    showRattingDialog(attendance);
  }

  Future<void> conclude(BuildContext context, Attendance attendance) async {
    //  var _dateTime = await MyDateUtils.getTrueTime();
    showLoading(true);
    if (ActivityUtils.isCancelTecno(attendance)) {
      attendance.tecnoNF = true;
      alterStatus(context, ActivityUtils.generateBody(attendance, null, null),
          () {
        showLoading(false);
      });
    } else {
      attendance.tecnoNF = true;
      attendance.status = ActivityUtils.FINALIZADO;
      alterStatus(context,
          ActivityUtils.generateBody(attendance, null, null, notify: false),
          () {
        showLoading(false);
      });
    }
  }

  Future<void> alterStatusNotNotify(
      BuildContext context, Map body, VoidCallback success) async {
    hideButton.sink.add(true);
    showLoading(true);

    var result = await _repository.notAlterStatus(body);
    showLoading(false);
    hideButton.sink.add(false);
    if (result.content != null) {
      // var tempA = result.content as Attendance;
      currentAttendance.sink.add(null);

      Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
      success();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  Future<void> alterStatus(
      BuildContext context, Map body, VoidCallback sucess) async {
    hideButton.sink.add(true);
    showLoading(true);

    var result = await _repository.alterStatus(body);
    showLoading(false);
    hideButton.sink.add(false);
    if (result.content != null) {
      // var tempA = result.content as Attendance;
      currentAttendance.sink.add(result);

      sucess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }


  Future<ResponsePaginated> editOnlyAttendance(
      Map<String, Map<String, Object>> body) {
    return _repository.editOnlyAttendance(body);
  }

  Future<void> acceptRefusedAlterAttendance(BuildContext context, bool accept,
      String pendency, Attendance attendance, Function onSuccess) async {
    var startCalledBloc = Modular.get<StartCalledBloc>();

    var tempPendency = pendency == null
        ? []
        : [
            {
              "markerPendency": attendance.userTecno?.id,
              "receiverPendency": attendance.userClient?.id,
              "description": pendency
            }
          ];

    var body = {
      "codAttendance": attendance?.id,
      "action": accept ? "A" : "R",
      "pendecy": tempPendency
    };

    showLoading(true);

    var result = await startCalledBloc.acceptRefusedAlter(body);
    showLoading(false);
    if (result.error == null) {
      attendance.status =
          accept ? ActivityUtils.EM_ATENDIMENTO : ActivityUtils.RECUSADO_TECNO;
      var _dateTime = MyDateUtils.getTrueTime();
      startCalledBloc.alterStatus(
          context, ActivityUtils.generateBody(attendance, _dateTime, _dateTime),
          () {
        onSuccess();
      });
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  Future<ResponsePaginated> acceptRefusedAlter(Map<String, Object> body) {
    return _repository.acceptRefusedAlter(body);
  }

  Future<void> addPendencyOnly(BuildContext context, bool accept,
      String pendency, Attendance attendance, Function onSuccess) async {
    var startCalledBloc = Modular.get<StartCalledBloc>();

    var tempPendency = pendency == null
        ? []
        : [
            {
              "markerPendency": attendance.userClient?.id,
              "receiverPendency": attendance.userTecno?.id,
              "description": pendency
            }
          ];

    var body = {"codAttendance": attendance?.id, "pendecy": tempPendency};

    showLoading(true);
    var result = await startCalledBloc.acceptRefusedAlter(body);
    showLoading(false);
    if (result.error == null) {
      onSuccess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  Future<ResponsePaginated> getDetailAttendance(int codAttendance) async {
    var detail = await _repository.getDetailsAttendance(codAttendance);
    return detail;
  }

  void alterStatusAtendance(
      BuildContext context, Attendance attendance, VoidCallback sucess) async {
    hideButton.sink.add(true);
    showLoading(true);
    var _dateTime = MyDateUtils.getTrueTime();
    var body = ActivityUtils.generateBody(attendance, _dateTime, _dateTime);
    var result = await _repository.alterStatus(body);
    showLoading(false);
    hideButton.sink.add(false);
    if (result.content != null) {
      // var tempA = result.content as Attendance;
      currentAttendance.sink.add(result);

      sucess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }


}
