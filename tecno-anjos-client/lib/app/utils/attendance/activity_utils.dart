import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../../app_bloc.dart';


class ActivityUtils {
  static const String EM_ATENDIMENTO = "A";
  static const String ENCERRADO = "E";
  static const String PENDENTE = "P";
  static const String FINALIZADO = "F";
  static const String RECUSADO = "R";
  static const String CANCELADO = "C";
  static const String INICIADO = "I";
  static const String REMOTAMENTE = "IR";
  static const String CANCELADO_PENDENCIA = "CP";
  static const String PRESENCIAL = "IP";
  static const String AGUARDO_QR = "QR";
  static const String NAO_AGUARDO_QR = "NQR";
  static const String ALTERADO_TECNO = "AT";
  static const String ALTERADO_CLIENTE = "AC";
  static const String RECUSADO_TECNO = "RT";
  static const String RECUSADO_CLIENTE = "RC";
  static const String CANCELADO_CLIENTE = "CC";
  static const String CANCELADO_TENO = "CT";

  // static playRemoteFile(Attendance attendance) async {
  //   final appBloc = Modular.get<AppBloc>();
  //   var attendanceId = await appBloc.getCurrentAttendanceId();
  //
  //   if (attendanceId != attendance?.id.toString()) {
  //     appBloc.setCurrent(attendance?.id.toString());
  //     //  SchedulerBinding.instance.addPostFrameCallback((_)  async {
  //     // Debouncer(
  //     //     milliseconds: 100,
  //     //     action: ()  {
  //     if (attendance.status == ActivityUtils.AGUARDO_QR ||
  //         attendance.status == ActivityUtils.NAO_AGUARDO_QR ||
  //         attendance.status == ActivityUtils.PENDENTE ||
  //         attendance.status == ActivityUtils.PRESENCIAL ||
  //         attendance.status == ActivityUtils.REMOTAMENTE) {
  //       try {
  //         AudioCache audioCache = AudioCache(
  //           fixedPlayer: AudioPlayer(),
  //         );
  //         HapticFeedback.mediumImpact();
  //         await audioCache.play(ImagePath.sound);
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //   }
  //   //     });
  //   // });
  // }

  static Color getColorWithDate(DateTime dateTime, DateTime now) {
    if (dateTime == null) {
      return Colors.grey;
    }

    var conver = MyDateUtils.convertDateToDate(now, now);
    var conver2 = MyDateUtils.convertDateToDate(now, now);
    if (dateTime.add(Duration(days: 1)).isAfter(conver)) {
      return AppThemeUtils.blueColor;
    } else if (dateTime.isBefore(conver2)) {
      return AppThemeUtils.orangeColor;
    } else {
      return AppThemeUtils.colorPrimary;
    }
  }

  static Color getColorWithString(String filter) {
    if (filter == ActivityUtils.EM_ATENDIMENTO) {
      return AppThemeUtils.orangeColor;
    } else if (filter == ActivityUtils.FINALIZADO) {
      return AppThemeUtils.colorPrimary;
    } else if (filter == "H") {
      return AppThemeUtils.colorPrimary;
    } else {
      return AppThemeUtils.colorPrimary;
    }
  }

  static bool getWithTypeFake(DateTime date, String filter) {
    if (date == null && filter != null) {
      return false;
    }
    if (filter == "A") {
      return MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(Modular.get<AppBloc>().dateNowWithSocket.stream.value, null))
          .isAfter(MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(date, null)));
    } else if (filter == "F") {
      return MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(Modular.get<AppBloc>().dateNowWithSocket.stream.value, null))
          .isBefore(MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(date, null)));
    } else if (filter == "H") {
      return (MyDateUtils.parseDateTimeFormat(Modular.get<AppBloc>().dateNowWithSocket.stream.value, null) ==
          MyDateUtils.parseDateTimeFormat(date, null));
    } else {
      return true;
    }
  }

  static getWithType(DateTime date, String filter) async {
    var _dateTime = await MyDateUtils.getTrueTime();
    var compare1 = MyDateUtils.convertDateToDate(_dateTime, _dateTime);
    var compare2 = MyDateUtils.convertDateToDate(_dateTime, _dateTime);
    if (filter == ActivityUtils.EM_ATENDIMENTO) {
      return date == null ? false : compare1.isAfter(date);
    } else if (filter == ActivityUtils.FINALIZADO) {
      return date == null ? false : compare2.isBefore(date);
    } else if (filter == "H") {
      return date == null
          ? true
          : MyDateUtils.parseDateTimeFormat(
                  MyDateUtils.convertDateToDate(_dateTime, _dateTime),
                  _dateTime) ==
              MyDateUtils.parseDateTimeFormat(date, _dateTime);
    } else {
      return true;
    }
  }

  // static double getTotalWithList(List<Qualification> itensQualifications) {
  //   return ObjectUtils.parseToDouble(itensQualifications?.fold(
  //       0,
  //       (previousValue, element) => previousValue += element.sellValue ??
  //           (((element?.money ?? element?.currentValue ?? 0) ?? 0.0) *
  //               (element.quantity ?? 0))));
  // }

  static String getTotalWithListMoney(Attendance attendance, {int qtd = 1}) {
    return Utils.moneyFormat((attendance.totalValue ?? 0.0) * qtd);
    // return ActivityUtils.isCancellTecno(attendance)
    //     ? Utils.moneyFormat(0)
    //     : Utils.moneyFormat(attendance.totalValue ??
    //         getTotalWithList(attendance.attendanceItems));
  }

  static getStatusName(String status) {
    switch (status) {
      case ActivityUtils.EM_ATENDIMENTO:
        return "Em Atendimento";
      case ActivityUtils.ENCERRADO:
        return "Concluído com sucesso";
      case ActivityUtils.PENDENTE:
        return "Atendimento aceito";
      case ActivityUtils.FINALIZADO:
        return "Finalizado";
      case ActivityUtils.RECUSADO:
        return "Recusado";
      case ActivityUtils.CANCELADO:
        return "Cancelado";
      case ActivityUtils.INICIADO:
        return "Iniciado";
      case ActivityUtils.REMOTAMENTE:
        return "Remotamente";
      case ActivityUtils.PRESENCIAL:
        return "Presencial";
      case ActivityUtils.CANCELADO_CLIENTE:
        return "Cancelado pelo cliente";
      case ActivityUtils.CANCELADO_TENO:
        return "Cancelado pelo tecnico";
      case ActivityUtils.AGUARDO_QR:
        return "Aguardando QR code";
      case ActivityUtils.NAO_AGUARDO_QR:
        return "Não Aguardando QR code";
    }
  }

  // static String getTotalHoursWorked(Attendance attendance) {
  //   return "${MyDateUtils.compareDateNowDatime(attendance.dateInit, dateEnd: attendance.dateEnd, isHours: true)} horas";
  // }

  static bool isInit(Attendance attendance) {
    return attendance.status == ActivityUtils.REMOTAMENTE ||
        attendance.status == ActivityUtils.PRESENCIAL;
  }

  static bool isQrCode(Attendance attendance) {
    return attendance.status == ActivityUtils.AGUARDO_QR ||
        attendance.status == ActivityUtils.NAO_AGUARDO_QR;
  }

  static bool isInProgress(Attendance attendance) {
    return attendance.status == ActivityUtils.EM_ATENDIMENTO;
  }

  static bool isAlterClient(Attendance attendance) {
    return attendance.status == ActivityUtils.ALTERADO_CLIENTE ||
        attendance.status == ActivityUtils.RECUSADO_CLIENTE;
  }

  static bool isAlterTecno(Attendance attendance) {
    return attendance.status == ActivityUtils.CANCELADO_CLIENTE;
  }

  static bool isRefusedTecno(Attendance attendance) {
    return attendance.status == ActivityUtils.CANCELADO_TENO;
  }

  static bool isCancellTecno(Attendance attendance) {
    return (attendance.status == ActivityUtils.CANCELADO_CLIENTE ||
            attendance.status == ActivityUtils.CANCELADO) &&
        attendance.clientNF == false;
  }

  static bool isCancellClient(Attendance attendance) {
    return (attendance.status == ActivityUtils.CANCELADO_CLIENTE ||
            attendance.status == ActivityUtils.CANCELADO) &&
        attendance.clientNF == false;
  }

  static bool isFinished(Attendance attendance) {
    return attendance.status == ActivityUtils.ENCERRADO;
  }

  static bool isRefused(Attendance attendance) {
    return attendance.status == ActivityUtils.RECUSADO;
  }

  static bool isReceipt(Attendance attendance) {
    return (attendance.status == ActivityUtils.FINALIZADO ||
            attendance.status == ActivityUtils.ENCERRADO) &&
        !(attendance.clientNF ?? false);
  }

  static bool isEvaluation(Attendance attendance) {
    return (attendance.status == ActivityUtils.FINALIZADO ||
            attendance.status == ActivityUtils.ENCERRADO) &&
        (attendance.clientNF ?? false);
  }

  static String convertQrCode(Attendance attendance) {
    return base64.encode(utf8.encode(attendance?.id.toString()));
  }

  static Map generateBody(Attendance attendance, DateTime dateTime,
      {bool notify = true}) {
    return {
      "content": {
        "id": attendance?.id,
        // "pendency": attendance.pendency ?? [],
        "status": attendance.status,
        "dateEnd":
            MyDateUtils.converStringServer(attendance?.dateEnd, dateTime),
        "dateInit": MyDateUtils.converStringServer(
            attendance?.dateInit ??
                MyDateUtils.convertDateToDate(dateTime, dateTime),
            dateTime),
        "clientNF": attendance?.clientNF ?? false
      },
      "sendNotification": notify
    };
  }

  static addressFormatMyData(Attendance attendance) {
    if (attendance.fullAddress != null) {
      return attendance.fullAddress;
    } else {
      if (attendance.address == null) {
        return '';
      } else {
        return "${attendance.address.myAddress} ${attendance.address.num} - ${attendance.address.neighborhood}, ${attendance.address.nameRegion}";
      }
    }
  }

// static getItens(Attendance attendance) {
//   var listNewItens = attendance.attendanceItems
//       ?.where((element) => element.origin == "NEWITEMS")
//       ?.toList();
//   if ((listNewItens?.length ?? 0) > 0) {
//     return listNewItens;
//   } else {
//     return attendance.attendanceItems;
//   }
// }

// static getItensOld(Attendance attendance) {
//   var listNewItens = attendance.attendanceItems
//       ?.where((element) => element.origin == "OLDITEMS")
//       ?.toList();
//   return listNewItens;
// }
}
