import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic_textfield.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/modules/general/home/core/current_attendance_repository.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/pendency.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/models/avaliation.dart';



import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import '../../../../../app_bloc.dart';




class MyCurrentAttendanceBloc extends Disposable {
  static const ATENDIMENTO = "ATENDIMENTO";
  static const INICIADO = "INICIADO";
  static const ID = "ID";
  static const BODY = "BODY";
  static const VIDEO = "VIDEO";
  static const CURRENT = "CURRENT";

  // var intAttendance = BehaviorSubject<Attendance>();
  var myCurrentAttendance = BehaviorSubject<Attendance>();
  var qtdSubject = BehaviorSubject<int>.seeded(1);
  final repository = CurrentAttendanceRepository();

  static const TECNO = 'TECNO';
  static const CLIENT = 'CLIENT';

  Future<String> collectionDocUser() async {
    final appBloc = Modular.get<AppBloc>();
    var user = appBloc.getCurrentUserFutureValue().stream.value;
    // return "155";
    return user?.id?.toString() ?? "-1";
  }

  ///**Escuta se tem video chamada
  Stream<DocumentSnapshot> listenToVideoChamada(Attendance attendance) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(ATENDIMENTO)
        .doc(CURRENT)
        .collection(attendance?.id.toString())
        .doc(VIDEO)
        .snapshots();
  }

  ///**Atualiza na video chamada
  atuaLizaToVideoChamada(Attendance attendance, bool status) {
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(ATENDIMENTO)
        .doc(CURRENT)
        .collection(attendance?.id.toString())
        .doc(VIDEO)
        .set({CLIENT: status});
  }

  ///** Escuta o firebase para pegar o atendimento corrente
  Stream<DocumentSnapshot> streamToCurrentService(String user) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(ATENDIMENTO)
        .doc(INICIADO)
        .collection(user)
        .doc(ID)
        .snapshots();
  }

  ///** Escuta o firebase para pegar o atendimento corrente
  Attendance myCurrentService(DocumentSnapshot event) {
    if (collectionDocUser() != null) {
      var temp = event.data();
      if (temp.toString().contains('attendance')) {
        var attendance = Attendance.fromMap(event.get('attendance'));
        if (attendance.tecnoAvaliation == true ||
            attendance.status == ActivityUtils.PENDENTE) {
          return null;
        } else {
          return attendance;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  ///** Escuta o firebase para pegar o atendimento corrente
  Stream<Attendance> streamToCurrent(Attendance attendance) {
    if (attendance == null) {
      return null;
    } else {
      Modular.get<AppBloc>()
          .firebaseReference()
          .collection(ATENDIMENTO)
          .doc(CURRENT)
          .collection(attendance?.id.toString())
          .doc(BODY)
          .snapshots()
          .listen((snapshotCurrent) {
        var attendance = myCurrentServiceCurrent(snapshotCurrent);
        if (attendance == null) {
          resetAttendance();

        } else {
          if (attendance.status == ActivityUtils.PENDENTE) {
            resetAttendance();
          } else {
            myCurrentAttendance.sink.add(attendance);
          }
        }
      });
    }
    return myCurrentAttendance;
  }

  void resetAttendance() {
             Future.delayed(Duration(seconds: 2),(){
      myCurrentAttendance.sink.add(null);
    });
  }

  ///** Atualizar o atendimento corrente
  updateCurrentAttendance(Attendance attendance) {
    myCurrentAttendance.sink.add(attendance);
  }

  ///** Escuta o firebase para pegar o atendimento corrente
  Attendance myCurrentServiceCurrent(DocumentSnapshot event) {
    if (event == null) {
      return null;
    } else {
      var temp = event.data();
      if (temp.toString().contains('attendance')) {
        var attendance = Attendance.fromMap(event.get('attendance'));
        if (attendance.tecnoAvaliation == true) {
          return null;
        } else {
          return attendance;
        }
      } else {
        return null;
      }
    }
  }

  ///**Iniciar um atendimento
  patchReschedule(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchReschedule(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("REAGENDAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("REAGENDAR ATENDIMENTO"));
    }
  }

  ///**Iniciar um atendimento
  patchInit(BuildContext context, Attendance attendance) async {
    showLoading(true);

    var response = await repository.patchInit(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("INICIAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("INICIAR ATENDIMENTO"));
    }
  }

  ///**Aceita um atendimento
  patchAccept(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchAccept(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("ACEITAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("ACEITAR ATENDIMENTO"));
    }
  }

  ///**Começa o atendimento que foi iniciado um atendimento
  patchStart(BuildContext context, Attendance attendance) async {
    showLoading(true);

    attendance.status = ActivityUtils.EM_ATENDIMENTO;
    var _dateTime = await MyDateUtils.getTrueTime();
    attendance.dateInit = MyDateUtils.convertDateToDate(_dateTime, _dateTime);

    // var body = ActivityUtils.generateBody(attendance, _dateTime);
    var chechInvoice = await repository.patchStart(attendance);
    // showLoading(false);
    var startCalledBloc = Modular.get<StartCalledBloc>();
    if (chechInvoice.status == 406) {
      showLoading(false);
      var textEditing = TextEditingController();
      startCalledBloc.hideButton.sink.add(true);
      startCalledBloc.hideButton.sink.add(false);
      showTextFieldGenericDialog(
          title: chechInvoice.error ?? "Falha",
          icon: Icons.error_outline,
          context: context,
          controller: textEditing,
          negativeCallback: () {},
          hintText: "CVV",
          keyboardType: TextInputType.number,
          inputFormatters: [LengthLimitingTextInputFormatter(4)],
          positiveCallback: () {
            Navigator.of(context).pop();
            showLoading(true);
            repository.updateCvv(attendance, textEditing.text).then((t) {
              showLoading(false);
              patchStart(context, attendance);
            });
          });
    } else {
      showLoading(false);
      if (chechInvoice.error == null) {
        if (chechInvoice.content.toString().contains("invoice") && chechInvoice.content['invoice'] != null
            ? (chechInvoice.content['invoice']['pagarmeStatus'] == "refused" ||
                chechInvoice.content['invoice']['status'] == "REFUSED" ||
                chechInvoice.content['invoice']['status'] == "refused")
            : false) {
          showGenericDialog(
              context: context,
              title: StringFile.opps,
              description: StringFile.seuCartaoFoiRecusado,
              subtitle: StringFile.verificarFormaPagamento,
              iconData: Icons.payment_rounded,
              containsPop: false,
              negativeText: StringFile.cancelar,
              negativeCallback: () {
                Navigator.pop(context);
                startCalledBloc.hideButton.sink.add(true);
                startCalledBloc.hideButton.sink.add(false);
              },
              positiveCallback: () {
                Navigator.pop(context);

                var startBloc = Modular.get<StartCalledBloc>();
                startBloc.alterPayment(context, attendance);
                startCalledBloc.hideButton.sink.add(true);
                startCalledBloc.hideButton.sink.add(false);
              },
              positiveText: StringFile.editar);
        } else {
          if (chechInvoice.content != null) {
            try {
              var attendance = Attendance.fromMap(chechInvoice.content);
              updateCurrentAttendance(attendance);
            } catch (e) {}
          }


          AmplitudeUtil.createEvent(
              AmplitudeUtil.eventoEmAtendimento("COMEÇAR ATENDIMENTO"));
          //  var chechInvoice = await repository.patchStart(attendance);
        }
      } else {
        AmplitudeUtil.createEvent(
            AmplitudeUtil.eventoFalhaEmAtendimento("COMEÇAR ATENDIMENTO"));
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${chechInvoice.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {
              startCalledBloc.hideButton.sink.add(true);
              startCalledBloc.hideButton.sink.add(false);
            },
            positiveText: StringFile.ok);
      }
    }

    // if (response.error != null) {
    //   showGenericDialog(
    //       context: context,
    //       title: StringFile.atencao,
    //       description: "${response.error}",
    //       iconData: Icons.error_outline,
    //       positiveCallback: () {},
    //       positiveText: StringFile.OK);
    // }
    // showLoading(false);
  }

  ///**Encerra o atendimento que foi iniciado um atendimento
  patchEnd(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchEnd(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("ENCERRAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("ENCERRAR ATENDIMENTO"));
    }
  }

  ///**Visualiza o atendimento
  patchConclude(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchConclude(attendance);

    if (response.error != null) {
      showLoading(false);
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("CONCLUIR ATENDIMENTO"));
      try {
        updateCurrentAttendance(response.content);
        qtdSubject.sink.add(1);
        // showGenericDialog(
        //     context: context,
        //     title: StringFile.atencao,
        //     description: "${response.error}",
        //     iconData: Icons.error_outline,
        //     positiveCallback: () {},
        //     positiveText: StringFile.OK);
      } catch (e) {}
    } else {
      showLoading(false);

      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("CONCLUIR ATENDIMENTO"));
    }
  }



  // periodicTransaction(BuildContext context) async {
  //
  //
  //   _timer?.cancel();
  //   if (_timer == null || !(_timer?.isActive ?? true)) {
  //     _timer = Timer.periodic(Duration(milliseconds: 5000), (timer) async {
  //       final paymentRepository = WalletRepository();
  //       if (myCurrentAttendance.stream.value.status == ActivityUtils.EM_ATENDIMENTO) {
  //         var responsePayment = await paymentRepository.makePayment(myCurrentAttendance.stream.value);
  //         if (responsePayment.error != null) {
  //           _timer.cancel();
  //           if (myCurrentAttendance.stream.value.status == ActivityUtils.EM_ATENDIMENTO) {
  //           patchCancel(context, myCurrentAttendance.stream.value);
  //
  //
  //             AmplitudeUtil.createEvent(AmplitudeUtil.eventoFalhaEmAtendimento(
  //                 "RECUSADO PAGAMENTO ATENDIMENTO"));
  //             showGenericDialog(
  //                 context: context,
  //                 title: "Pagamento não autorizado",
  //                 description:
  //                     "Seu atendimento foi cancelado devido a recusa do cartão por favor contate nosso administrativo",
  //                 iconData: Icons.error_outline,
  //                 positiveCallback: () {
  //
  //                 },
  //                 positiveText: StringFile.OK);
  //           }
  //         } else {
  //           final value = (qtdSubject.stream.value + 1);
  //           qtdSubject.sink.add(value);
  //         }
  //       }
  //     });
  //   }
  // }

  ///**Avalia o atendimento
  patchAvaliation(BuildContext context, Attendance attendance,
      Avaliation avaliation) async {
    showLoading(true);
    var response = await repository.patchAvaliation(attendance, avaliation);
    if (response.error != null) {
      showLoading(false);
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("AVALIAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      showLoading(false);
      if (response.content != null) {
        updateCurrentAttendance(null);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("AVALIAR ATENDIMENTO"));
    }
  }

  ///**Não inicia o atendimento
  patchNotInitNow(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchNotInitNow(attendance);
    if (response.error != null) {
      showLoading(false);
      AmplitudeUtil.createEvent(AmplitudeUtil.eventoFalhaEmAtendimento(
          "NÃO INICIAR AGORA ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      showLoading(false);
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("NÃO INICIAR AGORA ATENDIMENTO"));
      var _attendanceBloc = Modular.get<AttendanceBloc>();

      _attendanceBloc.getListAttendance();
      _attendanceBloc.getListSchedule();
    }
  }

  ///**Cancela o atendimento
  patchCancel(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchCancel(attendance, Pendency());
    if (response.error != null) {
      showLoading(false);
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("CANCELAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      Modular.get<FirebaseClientTecnoanjo>().deleteInLocal(attendance);
      showLoading(false);
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("CANCELAR ATENDIMENTO"));
    }
  }

  @override
  void dispose() {
    qtdSubject.close();
    myCurrentAttendance.close();
  }

  Future<void> patchRefused(BuildContext context, Attendance attendance) async {
    var controllerPendency = TextEditingController();
    showTextFieldGenericDialog(
        context: context,
        title: (attendance.pendencies ?? []).isEmpty
            ? StringFile.digaOqDeveSerAlterado
            : StringFile.motivoRecusa,
        maxTitle: StringFile.adicionarMotivo,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        minSize: 9,
        erroText: StringFile.digiteNoMinimo50,
        controller: controllerPendency,
        lines: 5,
        positiveCallback: () {
          Navigator.of(context).pop();
          showLoading(true);
          // if((attendance.pendencies ??  []).isEmpty){
          repository
              .review(
                  attendance,
                  Pendency(
                      markerPendency: attendance.userClient?.id,
                      receiverPendency: attendance.userTecno?.id,
                      description: controllerPendency.text))
              .then((response) {
            showLoading(false);
            if (response.error != null) {
              AmplitudeUtil.createEvent(AmplitudeUtil.eventoFalhaEmAtendimento(
                  "RECUSAR ATENDIMENTO"));
              showGenericDialog(
                  context: context,
                  title: StringFile.atencao,
                  description: "${response.error}",
                  iconData: Icons.error_outline,
                  positiveCallback: () {},
                  positiveText: StringFile.OK);
            } else {
              if (response.content != null) {
                updateCurrentAttendance(response.content);
              }
              AmplitudeUtil.createEvent(
                  AmplitudeUtil.eventoEmAtendimento("RECUSAR ATENDIMENTO"));
            }
          });
          // }else{
          //   repository
          //       .patchCancel(
          //       attendance,
          //       Pendency(
          //           markerPendency: attendance.userClient?.id,
          //           receiverPendency: attendance.userTecno?.id,
          //           description: controllerPendency.text))
          //       .then((response) {
          //     if (response.error != null) {
          //       showGenericDialog(
          //           context: context,
          //           title: StringFile.atencao,
          //           description: "${response.error}",
          //           iconData: Icons.error_outline,
          //           positiveCallback: () {},
          //           positiveText: StringFile.OK);
          //     }
          //     showLoading(false);
          //   });
          // }
        },
        negativeCallback: () {});
  }

  ///**delete await
  Future<void> deleteAwait(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.deleteAwait(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("DELETAR POPUP ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("DELETAR POPUP ATENDIMENTO"));
    }
  }

  ///**Cancela atendimento corrent
  patchCancelCurrentAttendance(
      BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchCancelCurrentAttendance(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(AmplitudeUtil.eventoFalhaEmAtendimento(
          "CANCELAR EM ANDAMENTO ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(AmplitudeUtil.eventoEmAtendimento(
          "CANCELAR EM ANDAMENTO ATENDIMENTO"));
      var _attendanceBloc = Modular.get<AttendanceBloc>();

      _attendanceBloc.getListAttendance();
      _attendanceBloc.getListSchedule();
    }
  }

  ///**Aceita a review o atendimento
  patchAcceptReview(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchAcceptReview(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("ACEITAR REVIEW ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("ACEITAR REVIEW ATENDIMENTO"));
    }
  }
}
