import 'package:flutter/material.dart';

class DialogDateTime {
  static Future<DateTime> selectDate(BuildContext context,
      {bool isTime = false}) async {
    DateTime datePicked;
    final DateTime picked = await showDatePicker(
        context: context,locale: Locale('pt', 'BR'),
        initialDate:  DateTime(2000, 1),
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2101));

    datePicked = picked;

    if (picked == null) {
      return picked;
    }

    if (isTime) {
      final TimeOfDay pickedTime =
      await showTimePicker(context: context, initialTime: TimeOfDay.now(),cancelText: "CANCELAR",helpText: "Selecione o horário");

      if (pickedTime != null) {
        datePicked = DateTime(picked.year, picked.month, picked.day,
            pickedTime.hour, pickedTime.minute)
            .toLocal();
      }
    }

    return datePicked;
  }
}
