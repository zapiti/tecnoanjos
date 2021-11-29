import 'package:flutter/material.dart';

class DialogDateTime {
  static Future<DateTime> selectDate(BuildContext context,
      {bool isTime = false}) async {
    DateTime datePicked;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    datePicked = picked;

    if (picked == null) {
      return picked;
    }

    if (isTime) {
      final TimeOfDay pickedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) {
        datePicked = DateTime(picked.year, picked.month, picked.day,
            pickedTime.hour, pickedTime.minute);
      }
    }

    return datePicked;
  }
}
