
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';


import '../../app_bloc.dart';

class MyDateUtils {
  static String _myFormat(String format, DateTime now){
    if(now == null){
      return null;
    }
    String formattedDate = DateFormat(format, "pt_BR").format(now);
    return formattedDate;
  }

  static DateTime dateToUtcToTime(DateTime dateTime){
    if(dateTime == null){
      return null;
    }
    final dateUtc = DateTime.utc(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );

    final date = dateUtc.toLocal();
    return date;
  }
  static DateTime getTrueTime()  {
    final localTime = Modular.get<AppBloc>().dateNowWithSocket.stream.value;
    return localTime;
  }



  static String parseDateTimeFormat(dynamic date, DateTime dateNow,
      {format = "dd/MM/yyy", String defaultValue}) {
    if (date == null || date == "") {
      return defaultValue;
    }
    if (date.toString().contains("/")) {
      return date.toString();
    } else {
      if (date == null || date == "" || date is List) {
        return "--";
      } else {
        DateTime now = MyDateUtils.convertDateToDate(
            dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value, dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value);
        if (date is String) {
          now = DateTime.parse(date);
        } else {
          now = date;
        }

        return _myFormat(format,now);
      }
    }
  }


  static String convertStringServer(dynamic date, DateTime dateNow,
      {format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", String defaultValue}) {
    if (date == null || date == "") {
      return defaultValue;
    }
    if (date.toString().contains("/")) {
      return date.toString();
    } else {
      if (date == null || date == "" || date is List) {
        return null;
      } else {
        DateTime now = dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value;
        if (date is String) {
          now = DateTime.parse(date);
        } else {
          now = date;
        }

        return _myFormat(format,now);
      }
    }
  }

  static DateTime convertStringToDateTime(String date,
      {bool isDateTime = false, String format = "dd/MM/yyyy HH:mm"}) {
    if (date == null || date == "" || date == "null") {
      return null;
    } else {
      if (date.contains("Z")) {
        DateTime tempDate =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
        return tempDate;
      } else {
        if (date.contains("/")) {
          DateTime tempDate;
          if (date.contains(":")) {
            tempDate = DateFormat(format).parse(date);
          } else {
            tempDate = DateFormat(format).parse("$date 00:00");
          }

          return tempDate;
        } else {
          DateTime tempDate = isDateTime
              ? DateTime.parse(date)
              : new DateFormat(format).parse(date);
          return tempDate;
        }
      }
    }
  }

  static int compareDateNow(String dateInit, dateNow,
      {String dateEnd, bool isHours = false}) {
    final dateInitial = dateInit == "" || dateInit == null || dateInit == "null"
        ? MyDateUtils.convertDateToDate(
            dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value, dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value)
        : DateTime.parse(dateInit);
    final date2 = dateEnd == "" || dateEnd == null || dateEnd == "null"
        ? MyDateUtils.convertDateToDate(
            dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value, dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value)
        : DateTime.parse(dateEnd);
    var date21 = convertDateToDate(date2, dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value);
    var dateInitial1 =
        convertDateToDate(dateInitial, dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value);

    final difference = isHours
        ? date21.difference(dateInitial1).inHours
        : date21.difference(dateInitial1).inSeconds;
    return difference;
  }

  static DateTime convertDateToDate(dynamic date2, DateTime dateNow) =>
      convertStringToDateTime(
          convertStringServer(date2, dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value));

  static int compareDateNowDateTime(DateTime dateInit, DateTime dateNow,
      {DateTime dateEnd,
      bool isDays = false,
      bool isHours = false,
      bool isSegunds = false}) {
    if (dateInit == null) {
      return 0;
    }

    final dateInitial = dateInit ?? dateNow;

    final date2 = dateEnd ?? dateNow ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value;

    var dateFim = convertDateToDate(date2, dateNow);
    var dateInicio = convertDateToDate(dateInitial, dateNow);
    print("================");
    print(" $dateInitial ------- $date2");
    print("================");

    final difference = isHours
        ? dateFim.difference(dateInicio).inHours
        : isDays
            ? dateFim.difference(dateInicio).inDays
            : isSegunds
                ? dateFim.difference(dateInicio).inSeconds
                : dateFim.difference(dateInicio).inMinutes;
    return isSegunds
        ? difference <= 0
            ? 1
            : difference
        : difference;
  }

  static String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  static bool compareTwoDates(
      DateTime hourAttendance, DateTime dateTime, DateTime dateNow) {
    if (dateTime == null || hourAttendance == null) {
      return false;
    } else {
      var date1 = convertDateToDate(dateTime, dateNow);
      var date2 = convertDateToDate(hourAttendance, dateNow);

      return date1.isAfter(date2);
    }
  }

  static String durationToStringHours(dynamic seconds,
      {String defaultValue = "--"}) {
    if (seconds == null || seconds == "--" || seconds == "") {
      return defaultValue;
    } else {
      var duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }


}
