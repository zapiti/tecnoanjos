import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/external/datepicker/date_picker.dart';
import 'package:tecnoanjosclient/app/components/external/datepicker/model/i18nmodel.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import '../../app_bloc.dart';

class DialogDateTime {
  static selectDate(BuildContext context,
      {bool isTime = false, Function(DateTime) onDate, String cancel}) async {
    // var dateTime = await MyDateUtils.getTrueTime();
    var dateTime = Modular.get<AppBloc>().dateNowWithSocket.stream.value;
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        confirmMessage: StringFile.agendar,
        minTime: dateTime.add(Duration(minutes: 30)),
        onCancel: () {
          onDate(null);
        },
        cancelMessage: cancel ?? StringFile.maisbreve,
        maxTime: dateTime.add(Duration(days: 365)),
        onChanged: (date) {
          // onDate(date);
        },
        onConfirm: (date) {
          onDate(date);
        },
        currentTime: dateTime.add(Duration(hours: 1)),
        locale: LocaleType.pt);
    // DateTime datePicked;
    // var _dateTime = await MyDateUtils.getTrueTime();
    // final DateTime picked = await showDatePicker(
    //     context: context,locale: Locale('pt', 'BR'),cancelText: "Assim que disponível",
    //     initialDate: MyDateUtils.convertDateToDate(_dateTime,_dateTime),confirmText: "Confirmar",
    //     firstDate: DateTime(2015, 8),
    //     lastDate: DateTime(2101));
    //
    // datePicked = picked;
    //
    // if (picked == null) {
    //   return picked;
    // }
    //
    // if (isTime) {
    //   final TimeOfDay pickedTime =
    //       await showTimePicker(context: context, initialTime: TimeOfDay.now(),cancelText: StringFile.cancelar,helpText: "Selecione o horário");
    //
    //   if (pickedTime != null) {
    //     datePicked = DateTime(picked.year, picked.month, picked.day,
    //             pickedTime.hour, pickedTime.minute)
    //         .toLocal();
    //   }
    // }
    //
    // return datePicked;
  }

  static Future<DateTime> selectTime(BuildContext context) async {
    DateTime datePicked;

    final TimeOfDay pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      datePicked =
          DateTime(2000, 1, 1, pickedTime.hour, pickedTime.minute).toLocal();
    }

    return datePicked;
  }

  static selectDateNasc(BuildContext context, Function(DateTime) onDate) async {
    // var dateTime = await MyDateUtils.getTrueTime();
    var dateTime = Modular.get<AppBloc>().dateNowWithSocket.stream.value;
    var newDate =
        new DateTime(dateTime.year - 18, dateTime.month, dateTime.day);
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 3, 5),
        maxTime: newDate, onChanged: (date) {
      // onDate(date);
    }, onConfirm: (date) {
      onDate(date);
    }, currentTime: newDate, locale: LocaleType.pt);
  }


}
