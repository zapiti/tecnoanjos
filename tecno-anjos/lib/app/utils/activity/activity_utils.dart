import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import '../../app_bloc.dart';
import '../utils.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';


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
  static const String CANCELADO_TECNO = "CT";


  static Color getColorWithDate(DateTime dateTime, DateTime _dateTime) {
    if (dateTime == null) {
      return Colors.grey;
    }

    if (dateTime
        .add(Duration(days: 1))
        .isAfter(MyDateUtils.convertDateToDate(_dateTime, _dateTime))) {
      return AppThemeUtils.blueColor;
    } else if (dateTime
        .isBefore(MyDateUtils.convertDateToDate(_dateTime, _dateTime))) {
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

  static getWithType(DateTime date, String filter, DateTime _dateTime) {
    if (date == null) {
      return false;
    }

    if (filter == ActivityUtils.EM_ATENDIMENTO) {
      return MyDateUtils.convertDateToDate(_dateTime, _dateTime).isAfter(date);
    } else if (filter == ActivityUtils.FINALIZADO) {
      return MyDateUtils.convertDateToDate(_dateTime, _dateTime).isBefore(date);
    } else if (filter == "H") {
      return MyDateUtils.parseDateTimeFormat(
              MyDateUtils.convertDateToDate(_dateTime, _dateTime), _dateTime) ==
          MyDateUtils.parseDateTimeFormat(date, _dateTime);
    } else {
      return true;
    }
  }
  

  static String getTotalWithListMoney(Attendance attendance) {
    return Utils.moneyFormat(attendance.totalValue);
  }

  static String getStatusName(String status) {
    switch (status) {
      case ActivityUtils.EM_ATENDIMENTO:
        return "Em Atendimento";
      case ActivityUtils.ENCERRADO:
        return "Concluído com sucesso";
      case ActivityUtils.PENDENTE:
        return "Pendente";
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
      case ActivityUtils.AGUARDO_QR:
        return "Aguardando QR code";
      case ActivityUtils.CANCELADO_CLIENTE:
        return "Cancelado pelo cliente";
      case ActivityUtils.CANCELADO_TECNO:
        return "Cancelado pelo tecnico";
      case ActivityUtils.NAO_AGUARDO_QR:
        return "Não Aguardando QR code";
      default:
        return "Sem registro";
    }
  }

  static String getTotalHoursWorked(Attendance attendance, DateTime _dateTime) {
    return "${MyDateUtils.compareDateNowDateTime(attendance.dateInit, _dateTime, dateEnd: attendance.dateEnd, isHours: true)} horas";
  }

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

  static bool isFinished(Attendance attendance) {
    return attendance.status == ActivityUtils.ENCERRADO &&
        attendance.clientNF != true;
  }

  static bool isAlterClient(Attendance attendance) {
    return attendance.status == ActivityUtils.ALTERADO_CLIENTE;
  }

  static bool isReviewClient(Attendance attendance) {
    return attendance.status == ActivityUtils.RECUSADO_CLIENTE ||
        attendance.status == ActivityUtils.CANCELADO_CLIENTE;
  }

  static bool isCancelTecno(Attendance attendance) {
    return (attendance.status == ActivityUtils.CANCELADO) &&
        attendance.tecnoNF == false;
  }

  static bool isCancelClient(Attendance attendance) {
    return (attendance.status == ActivityUtils.CANCELADO) &&
        attendance.tecnoNF == false;
  }

  static bool isRefusedTecno(Attendance attendance) {
    return attendance.status == ActivityUtils.CANCELADO_TECNO;
  }

  static bool isReceipt(Attendance attendance) {
    return (attendance.status == ActivityUtils.FINALIZADO ||
            attendance.status == ActivityUtils.ENCERRADO) &&
        !(attendance.tecnoNF ?? true);
  }

  static bool isEvaluation(Attendance attendance) {
    return (attendance.status == ActivityUtils.FINALIZADO ||
            attendance.status == ActivityUtils.ENCERRADO) &&
        (attendance.tecnoNF ?? false);
  }

  static String convertQrCode(Attendance attendance) {
    return base64.encode(utf8.encode(attendance?.id.toString()));
  }

  static Map generateBody(
      Attendance attendance, DateTime _dateTime, DateTime dateNow,
      {bool notify = true}) {
    return {
      "content": {
        "id": attendance?.id,
        "status": attendance.status,
        "dateEnd":
            MyDateUtils.convertStringServer(attendance?.dateEnd, _dateTime),
        "dateInit":
            MyDateUtils.convertStringServer(attendance?.dateInit, _dateTime),
        "tecnoNF": attendance?.tecnoNF ?? false
      },
      "sendNotification": notify
    };
  }

  static bool getWithTypeFake(DateTime date, String filter) {
    if (date == null && filter != null) {
      return false;
    }

    if (filter == "A") {
      return MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(
                  Modular.get<AppBloc>().dateNowWithSocket.stream.value, null))
          .isAfter(MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(date, null)));
    } else if (filter == "F") {
      return MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(
                  Modular.get<AppBloc>().dateNowWithSocket.stream.value, null))
          .isBefore(MyDateUtils.convertStringToDateTime(
              MyDateUtils.parseDateTimeFormat(date, null)));
    } else if (filter == "H") {
      return (MyDateUtils.parseDateTimeFormat(
              Modular.get<AppBloc>().dateNowWithSocket.stream.value, null) ==
          MyDateUtils.parseDateTimeFormat(date, null));
    } else {
      return true;
    }
  }
}
