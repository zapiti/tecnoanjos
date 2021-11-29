

import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';



import '../app_bloc.dart';
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
  static Future<DateTime> getTrueTime() async {
    final localTime = Modular.get<AppBloc>().dateNowWithSocket.stream.value;
    return localTime;
  }

  static String parseDateTimeFormat(dynamic date, DateTime dateTime,
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
        DateTime now = MyDateUtils.convertDateToDate(dateTime, dateTime);
        if (date is String) {
          now = DateTime.parse(date);
        } else {
          now = date;
        }




        return _myFormat(format,now);
      }
    }
  }



  static String converStringServer(dynamic date, DateTime dateTime,
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
        DateTime now = dateTime ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value;
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

  // static Future<DateTime> getDateTimeNow() async {
  //   try {
  //     DateTime now = await MyDateUtils.trueServerTime();
  //     return now;
  //   } catch (e) {
  //     return MyDateUtils.getTrueTime();
  //   }
  // }

  static Future<int> compareDateNow(String dateInit,
      {String dateEnd, bool isHours = false}) async {
    var _dateTime = await MyDateUtils.getTrueTime();
    final dateInitial = dateInit == "" || dateInit == null || dateInit == "null"
        ? MyDateUtils.convertDateToDate(_dateTime, _dateTime)
        : DateTime.parse(dateInit);
    final date2 = dateEnd == "" || dateEnd == null || dateEnd == "null"
        ? MyDateUtils.convertDateToDate(_dateTime, _dateTime)
        : DateTime.parse(dateEnd);
    var date21 =  convertDateToDate(date2, _dateTime);
    var dateInitial1 =  convertDateToDate(dateInitial, _dateTime);

    final difference = isHours
        ? date21.difference(dateInitial1 ?? _dateTime).inHours
        : date21.difference(dateInitial1 ?? _dateTime).inSeconds;
    return difference;
  }

  static DateTime convertDateToDate(dynamic date2, DateTime _dateTime) {
    try {
      var date = converStringServer(date2, _dateTime);
      return convertStringToDateTime(date);
    } catch (e) {
      return null;
    }
  }

  static int compareDateNowDatime(DateTime dateInit, DateTime _dateTime,
      {DateTime dateEnd,
      bool isDays = false,
      bool isHours = false,
      bool isSegunds = false}) {
    if (dateInit == null) {
      return 0;
    }

    final dateInitial = dateInit ?? _dateTime ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value;

    final date2 = dateEnd ?? _dateTime ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value;

    if(date2 == null || dateInit == null){
      return 0;
    }else {
      var dateFim = convertDateToDate(date2, _dateTime);
      var dateInicio = convertDateToDate(dateInitial, _dateTime);

      print("================");
      print("datecompare $dateInitial ------- $date2");
      print("================");

      final difference = isHours
          ? dateFim
          .difference(dateInicio ?? _dateTime ?? DateTime.now())
          .inHours
          : isDays
          ? dateFim
          .difference(dateInicio ?? _dateTime ?? DateTime.now())
          .inDays
          : isSegunds
          ? dateFim
          .difference(dateInicio ?? _dateTime ?? DateTime.now())
          .inSeconds
          : dateFim
          .difference(dateInicio ?? _dateTime ?? DateTime.now())
          .inMinutes;
      return isSegunds
          ? difference <= 0
          ? 1
          : difference
          : difference;
    }
  }

  static String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  static bool compareTwoDates(DateTime hourAttendance, DateTime dateTime) {
    if (hourAttendance == null) {
      return false;
    } else {
      var date1 = convertDateToDate(dateTime, dateTime);
      var date2 = convertDateToDate(hourAttendance, dateTime);

      return date1.isAfter(date2);
    }
  }
}
