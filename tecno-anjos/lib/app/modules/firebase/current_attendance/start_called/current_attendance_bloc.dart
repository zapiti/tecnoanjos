import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic_textfield.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/bottom_sheet/bottom_sheet_verify_code.dart';
import 'package:tecnoanjostec/app/modules/general/home/core/current_attendance_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/pendency.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat/chat_perspective.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/receiver_called_bloc.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjostec/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';
import '../../../../app_bloc.dart';

class MyCurrentAttendanceBloc extends Disposable {
  static const ATENDIMENTO = "ATENDIMENTO";
  static const INICIADO = "INICIADO";
  static const ID = "ID";
  static const BODY = "BODY";
  static const CURRENT = "CURRENT";
  var myCurrentAttendance = BehaviorSubject<Attendance>();
  static const VIDEO = "VIDEO";
  static const TECNO = 'TECNO';
  static const CLIENT = 'CLIENT';
  final repository = CurrentAttendanceRepository();

  String collectionDocUser() {
    var appBloc = Modular.get<AppBloc>();
    var user = appBloc.getCurrentUserFutureValue().stream.value;
    return user?.id?.toString();
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
        .set({TECNO: status});
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
        var attendance = Attendance.fromMap(temp['attendance']);
        if (attendance.tecnoAvaliation == true) {
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
          myCurrentAttendance.sink.add(null);
        } else {
          if (attendance.status == ActivityUtils.PENDENTE) {
            myCurrentAttendance.sink.add(null);
          } else {
            myCurrentAttendance.sink.add(attendance);
          }
        }
      });
    }
    return myCurrentAttendance;
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
        var attendance = Attendance.fromMap(temp['attendance']);
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
  patchInit(BuildContext context, Attendance attendance) async {
    var _dateTime = MyDateUtils.getTrueTime();
    var dateInit = (MyDateUtils.convertDateToDate(_dateTime, _dateTime) ??
            _dateTime ??
            Modular.get<AppBloc>().dateNowWithSocket.stream.value)
        .add(Duration(minutes: 30));

    if (MyDateUtils.compareTwoDates(
        dateInit, attendance.hourAttendance, _dateTime)) {
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: StringFile.atendimentoumahora,
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      showLoading(true);
      var response = await repository.patchInit(attendance);
      showLoading(false);
      if (response.error != null) {
        AmplitudeUtil.createEvent(
            AmplitudeUtil.eventoFalhaEmAtendimento("INICIAR ATENDIMENTO"));
        showGenericDialog(
            context: context,
            title: StringFile.Erro,
            description: "${response.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      } else {
        AmplitudeUtil.createEvent(
            AmplitudeUtil.eventoEmAtendimento("INICIAR ATENDIMENTO"));
        if (response.content != null) {
          updateCurrentAttendance(response.content);
        }
        var _receiverBloc = Modular.get<ReceiverCalledBloc>();
        _receiverBloc.getListReceivers(load: true);
        getSchedule();
      }
    }
  }

  ///**Aceita um atendimento
  patchAccept(
    BuildContext context,
    Attendance attendance,
  ) async {
    showLoading(true);
    var response = await repository.patchAccept(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("ACEITAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {
            var receiverCalledBloc = Modular.get<ReceiverCalledBloc>();
            receiverCalledBloc.refuseCalled(
                context, attendance?.id, attendance.hourAttendance, () {
              var receiverCalledBloc = Modular.get<ReceiverCalledBloc>();
              receiverCalledBloc.getListReceivers();

              Modular.get<FirebaseClientTecnoanjo>().removeCollectionAccept();
              //    Navigator.of(context).pop();
            });
          },
          positiveText: StringFile.OK);
    } else {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("ACEITAR ATENDIMENTO"));
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      var _receiverBloc = Modular.get<ReceiverCalledBloc>();
      _receiverBloc.getListReceivers(load: true);
      getSchedule();
    }
  }

  ///**Começa o atendimento que foi iniciado um atendimento
  patchStart(BuildContext context, Attendance attendance) async {
    if (attendance.status == ActivityUtils.REMOTAMENTE) {
      await _startAttendance(attendance, attendance.attendanceCode, context);
    } else {
      showBottomSheetServices(context, selected: (text) async {
        if (text.isNotEmpty) {
          await _startAttendance(attendance, text, context);
        } else {
          Utils.showSnackBar(
              "Para iniciar o atendimento digite a palavra chave que você pegará com cliente!",
              context);
        }
      });
    }
  }

  Future _startAttendance(
      Attendance attendance, String text, BuildContext context) async {
    showLoading(true);
    final firebaseClient = Modular.get<FirebaseClientTecnoanjo>();
    var response = await repository.patchStart(attendance, text);
    if (response.error != null) {
      firebaseClient.updateInLocal(attendance);
      showLoading(false);
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("CONFIRMAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      showLoading(false);
      if (response.content != null) {
        firebaseClient.successInLocal(attendance);
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("CONFIRMAR ATENDIMENTO"));
    }
  }

  ///**Encerra o atendimento que foi iniciado um atendimento
  patchEnd(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchEnd(attendance);
    if (response.error != null) {
      showLoading(false);
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("ENCERRAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      showLoading(false);
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("ENCERRAR ATENDIMENTO"));
    }
  }

  ///**Visualiza o atendimento
  patchConclude(
      BuildContext context, Attendance attendance, Function sucess) async {
    showLoading(true);
    var response = await repository.patchConclude(attendance);
    if (response.error != null) {
      showLoading(false);
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("CONCLUIR ATENDIMENTO"));
      updateCurrentAttendance(response.content);
      // showGenericDialog(
      //     context: context,
      //     title: StringFile.atencao,
      //     description: "${response.error}",
      //     iconData: Icons.error_outline,
      //     positiveCallback: () {},
      //     positiveText: StringFile.OK);
    } else {
      showLoading(false);
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("CONCLUIR ATENDIMENTO"));
      sucess();
    }
  }

  patchConcludeClient(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchConcludeClient(attendance);
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("CONCLUIR ATENDIMENTO"));
      try {
        showGenericDialog(
            context: context,
            title: StringFile.atencao,
            description: "${response.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      } catch (e) {}
    } else {
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("CONCLUIR ATENDIMENTO"));
    }
  }

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
          title: StringFile.Erro,
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
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(AmplitudeUtil.eventoFalhaEmAtendimento(
          "NÃO INICIAR AGORA ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      if (response.content != null) {
        updateCurrentAttendance(null);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("NÃO INICIAR AGORA ATENDIMENTO"));
      var _receiverBloc = Modular.get<ReceiverCalledBloc>();
      _receiverBloc.getListReceivers(load: true);
      getSchedule();
    }
  }

  ///**Cancela o atendimento
  patchCancel(BuildContext context, Attendance attendance) async {
    showLoading(true);
    var response = await repository.patchCancel(attendance, Pendency());
    showLoading(false);
    if (response.error != null) {
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoFalhaEmAtendimento("CANCELAR ATENDIMENTO"));
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("CANCELAR ATENDIMENTO"));
      getSchedule();
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
          title: StringFile.Erro,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(
          AmplitudeUtil.eventoEmAtendimento("ACEITAR REVIEW ATENDIMENTO"));
    }
  }

  @override
  void dispose() {
    myCurrentAttendance.close();
  }

  ///**Cancela atendimento
  Future<void> patchRefused(BuildContext context, Attendance attendance) async {
    var controllerPendency = TextEditingController();
    showTextFieldGenericDialog(
        context: context,
        title: StringFile.motivoRecusa,
        maxTitle: StringFile.adicionarMotivo,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        minSize: 9,
        erroText: StringFile.digiteNoMinimo50,
        controller: controllerPendency,
        lines: 5,
        positiveCallback: () {
          Navigator.of(context).pop();
          showLoading(true);
          repository
              .patchCancel(
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
              getSchedule();
            }
          });
        },
        negativeCallback: () {});
  }

  ///**delete await
  void patchRefusedAccept(BuildContext context, Attendance attendance) {
    var receiverCalledBloc = Modular.get<ReceiverCalledBloc>();
    receiverCalledBloc
        .refuseCalled(context, attendance?.id, attendance.hourAttendance, () {
      var receiverCalledBloc = Modular.get<ReceiverCalledBloc>();
      receiverCalledBloc.getListReceivers();

      // Modular.get<FirebaseClientTecnoanjo>()
      //     .removeCollectionAccept();
    });
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
          title: StringFile.Erro,
          description: "${response.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      // if(response.content !=  null){
      //
      //   updateCurrentAttendance(response.content);
      // }
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
      if (response.content != null) {
        updateCurrentAttendance(response.content);
      }
      AmplitudeUtil.createEvent(AmplitudeUtil.eventoEmAtendimento(
          "CANCELAR EM ANDAMENTO ATENDIMENTO"));
      getSchedule();
    }
  }

  void getSchedule() {
    var _attendanceBloc = Modular.get<AttendanceBloc>();
    _attendanceBloc.getListAttendance();
    _attendanceBloc.getListSchedule();
  }

  void patchRefusedReview(BuildContext context, Attendance attendance) {
    var controllerPendency = TextEditingController();
    showTextFieldGenericDialog(
        context: context,
        title: StringFile.motivoRecusa,
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
                      markerPendency: attendance.userTecno?.id,
                      receiverPendency: attendance.userClient?.id,
                      description: controllerPendency.text))
              .then((response) {
            showLoading(false);
            if (response.error != null) {
              AmplitudeUtil.createEvent(AmplitudeUtil.eventoFalhaEmAtendimento(
                  "RECUSAR REVIEW ATENDIMENTO"));
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
              AmplitudeUtil.createEvent(AmplitudeUtil.eventoEmAtendimento(
                  "RECUSAR REVIEW ATENDIMENTO"));
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

  void inLocal(BuildContext context, Attendance attendance) {
    final firebaseClient = Modular.get<FirebaseClientTecnoanjo>();
    final appBloc = Modular.get<AppBloc>();
    firebaseClient.sendInLocal(attendance);
    showGenericDialog(
        context: context,
        title: "Vamos lá?",
        containsPop: false,
        description:
            "Peça para o cliente o código de verificação do atendimento.",
        iconData: Icons.play_for_work_outlined,
        positiveCallback: () {
          Navigator.of(context).pop();
          patchStart(context, attendance);
        },
        negativeCallback: () {
          firebaseClient.deleteInLocal(attendance);
          Navigator.of(context).pop();
        },
        customWidget: Column(
          children: [
            Container(
              child: Text(
                "Peça para o cliente o código de verificação do atendimento.",
                textAlign: TextAlign.center,
                style: AppThemeUtils.normalSize(
                    color: AppThemeUtils.colorPrimary, fontSize: 18),
              ),
            ),
            Container(
              child: chatField(attendance, context),
            )
          ],
        ),
        negativeText: StringFile.cancelar,
        positiveText: "Digitar código");
  }
}
