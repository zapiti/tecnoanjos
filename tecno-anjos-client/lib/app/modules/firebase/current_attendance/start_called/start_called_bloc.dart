import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/components/dialog_hatting.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/widget/wallet_bottom_sheet.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'core/start_called_repository.dart';

class StartCalledBloc extends Disposable {
  //dispose will be called automatically by closing its streams

  final _repository = Modular.get<StartCalledRepository>();

  var isLoadAttendance = BehaviorSubject<bool>.seeded(false);
  var _finish = BehaviorSubject<bool>.seeded(false);
  var qrcodeSubject = BehaviorSubject<String>();
  var raating = BehaviorSubject<double>.seeded(5.0);
  var resenha = BehaviorSubject<String>.seeded("");

  var hideButton = BehaviorSubject<bool>.seeded(false);
  var inAttendance = BehaviorSubject<bool>.seeded(false);

  var currentAttendance = BehaviorSubject<ResponsePaginated>();
  var pendency = BehaviorSubject<String>();

  var awaitAttendanceTemp = BehaviorSubject<ResponsePaginated>();
  var tempAttendance = BehaviorSubject<Attendance>();
  var isFinishAttendance = BehaviorSubject<bool>.seeded(false);

  var temporaryCallWithout = BehaviorSubject<bool>.seeded(false);

  var temporaryCallNext = BehaviorSubject<bool>.seeded(false);

  Future<void> joinRoom() async {}

  Future scan(BuildContext context, Attendance attendance) async {
    FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancelar", true, ScanMode.QR)
        .then((barcode) {
      if (barcode == ActivityUtils.convertQrCode(attendance)) {
        getQrCode(context, attendance);
      } else {
        showGenericDialog(
            context: context,
            title: StringFile.ops,
            description: "Código QR é inválido",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    });
  }

  void setCurrentAttendance() {
    inAttendance.sink.add(true);
  }

  void initManual(BuildContext context, Attendance attendance) async {
    var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
    currentBloc.patchStart(context, attendance);
  }

  void evalueteAction(
    BuildContext context,
    double rating,
    String resenha,
    Attendance attendance,
  ) async {
    final appBloc = Modular.get<AppBloc>();
    appBloc.addAvaliations.sink.add(true);
    //showLoadingDialog(context, title: "Salvando avaliação");
    await _repository.avaliateAttendance(context, resenha, rating, attendance);
    //   Navigator.of(context).pop();
  }

  void evalueateAttendance(BuildContext context, Attendance attendance) {
    showRattingDialog(attendance);
  }

  void finishAttendance(BuildContext context, Attendance attendance,
      VoidCallback onSucess) async {
    hideButton.sink.add(true);
//    attendance.status = ActivityUtils.FINALIZADO;
//    attendance.clientNF = false;
//
//    alterStatus(context, ActivityUtils.generateBody(attendance), onSucess);

    //  if (!isFinishAttendance.stream.value) {
    tempAttendance.sink.add(attendance);
    isFinishAttendance.sink.add(true);
    hideButton.sink.add(true);

    var _dateTime = await MyDateUtils.getTrueTime();
    var result = await _repository.finishAttendance(attendance);
    if (result.error == null) {
      attendance.clientNF = true;
      // attendance.status = ActivityUtils.FINALIZADO;
      result = await _repository.alterStatus(
          ActivityUtils.generateBody(attendance, _dateTime, notify: false));
    }

    hideButton.sink.add(false);
    if (result.error == null) {
      result?.content = attendance;
      currentAttendance.sink.add(result);

      //   evalueateAttendance(context, tempAttendance.stream.value);
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {
            Navigator.pop(context);
          },
          containsPop: false,
          positiveText: StringFile.ok,
          negativeCallback: () async {
            Navigator.pop(context);
            alterPayment(context, attendance);
          },
          negativeText: "Alterar pagamento");
    }
    //  }
  }

  void alterPayment(BuildContext context, Attendance attendance) {
    showBottomSheetWallet(context, (selected) {
      final payment = attendance.paymentMethod;
      payment.paymentMethodId = selected.pagarmeCardId;
      attendance.paymentMethod = payment;

      _repository.alterStatusNotNotfy(attendance.toMap());
    });
  }

  @override
  void dispose() {
    currentAttendance.drain();
    qrcodeSubject.drain();
    isLoadAttendance.drain();
    hideButton.drain();
    inAttendance.drain();
    pendency.drain();
    tempAttendance.drain();
    isFinishAttendance.drain();
    //   awaitAttendance.drain();
    awaitAttendanceTemp.drain();
    temporaryCallWithout.drain();
    temporaryCallNext.drain();
    raating.drain();
    resenha.drain();
    _finish.drain();
  }

  getQrCode(BuildContext context, Attendance attendance) async {
    //todo alterar
    initManual(context, attendance);
  }

  Future<void> conclude(BuildContext context, Attendance attendance) async {
    var _dateTime = await MyDateUtils.getTrueTime();
    showLoading(true);
    if (ActivityUtils.isCancellTecno(attendance)) {
      attendance.clientNF = true;
      alterStatus(context, ActivityUtils.generateBody(attendance, _dateTime),
          () {
        showLoading(false);
      });
    } else {
      attendance.clientNF = true;
      // attendance.status = ActivityUtils.FINALIZADO;

      alterStatus(context, ActivityUtils.generateBody(attendance, _dateTime),
          () {
        showLoading(false);
      });
    }
  }

  Future<void> alterStatus(
      BuildContext context, Map body, VoidCallback sucess) async {
    hideButton.sink.add(true);
    //  showLoadingDialog(context, title: "Atualizando");
    // Navigator.of(context).pop();
    var result = await _repository.alterStatus(body);

    hideButton.sink.add(false);
    if (result.error == null) {
      sucess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  Future<void> addPendency(
      BuildContext context, Attendance attendance, String text) async {
    attendance.status = ActivityUtils.RECUSADO_CLIENTE;
    showLoading(true);

    var body = {
      "content": {
        "id": attendance?.id,
        "pendency": [
          {
            "markerPendency": attendance.userClient?.id,
            "receiverPendency": attendance.userTecno?.id,
            "description": text
          }
        ]
      }
    };
    await _repository.addPendency(body);
    showLoading(false);
    var _dateTime = await MyDateUtils.getTrueTime();
    alterStatus(context, ActivityUtils.generateBody(attendance, _dateTime), () {
      Navigator.of(context).pop();
    });
  }

  Future<ResponsePaginated> editOnlyAttendance(
      Map<String, Map<String, Object>> body) {
    return _repository.editOnlyAttendance(body);
  }

  Future<void> addPendencyOnly(BuildContext context, bool accept,
      String pendency, Attendance attendance, Function onSucess) async {
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

    var body = {
      "content": {"id": attendance?.id, "pendency": tempPendency}
    };

    showLoading(true);

    var result = await startCalledBloc.editOnlyAttendance(body);
    showLoading(false);
    if (result.error == null) {
      onSucess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  Future<void> acceptRefusedAlterAttendance(BuildContext context, bool accept,
      String pendency, Attendance attendance, Function onSucess) async {
    var startCalledBloc = Modular.get<StartCalledBloc>();
    showLoading(true);
    var tempPendency = pendency == null
        ? []
        : [
            {
              "markerPendency": attendance.userClient?.id,
              "receiverPendency": attendance.userTecno?.id,
              "description": pendency
            }
          ];

    var body = {
      "codAttendance": attendance?.id,
      "action": accept ? "A" : "R",
      "pendency": tempPendency
    };

    //  showLoadingDialog(context, title: "Solicitando edição");

    var result = await startCalledBloc.acceptRefusedAlter(body);
    //   Navigator.of(context).pop();
    showLoading(false);
    var _dateTime = await MyDateUtils.getTrueTime();
    if (result.error == null) {
      attendance.status = accept
          ? ActivityUtils.EM_ATENDIMENTO
          : ActivityUtils.RECUSADO_CLIENTE;

      startCalledBloc.alterStatus(
          context, ActivityUtils.generateBody(attendance, _dateTime), () {
        onSucess();
      });
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  Future<ResponsePaginated> acceptRefusedAlter(Map<String, Object> body) {
    return _repository.acceptRefusedAlter(body);
  }

  void alterStatusNotNotfy(
      BuildContext context, Map body, VoidCallback sucess) async {
//    hideButton.sink.add(true);
    // showLoadingDialog(context, title: "Atualizando");
    // Navigator.of(context).pop();
    showLoading(true);
    var result = await _repository.alterStatusNotNotfy(body);
    showLoading(false);
    hideButton.sink.add(false);
    if (result.content != null) {
      var tempA = result.content as Attendance;

      var attendance = tempA;
      if (attendance != null) {
        attendance.status = tempA.status;
        attendance.dateEnd = tempA.dateEnd;
        //   attendance.pendencies = tempA.pendencies;
        result.content = attendance;
        // alterStatus(context, ActivityUtils.generateBody(attendance, attendance.dateInit),(){});
      } else {
        result?.content = tempA;
      }

      currentAttendance.sink.add(result);
      sucess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  Future<void> getAllInfoWithAttendance(ResponsePaginated response) async {
    if (response.content is Attendance) {
      if ((response.content as Attendance).status.toString().contains("C") ||
          (response.content as Attendance).status.toString().contains("R")) {
        var detail = await _repository
            .getDetailsAttendance((response.content as Attendance)?.id);
        currentAttendance.sink.add(detail);
      }
    }
  }

  Future<ResponsePaginated> getDetailAttendance(int codAttendance) async {
    var detail = await _repository.getDetailsAttendance(codAttendance);
    return detail;
  }
}
