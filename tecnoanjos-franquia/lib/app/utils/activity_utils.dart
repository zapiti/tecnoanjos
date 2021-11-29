import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';

class ActivityUtils {
  static Color getColorWithDate(DateTime dateTime) {
    if (dateTime == null) {
      return Colors.grey;
    }

    if (dateTime.isAfter(DateTime.now())) {
      return AppThemeUtils.blueColor;
    } else if (dateTime == DateTime.now()) {
      return AppThemeUtils.colorPrimary;
    } else {
      return AppThemeUtils.orangeColor;
    }
  }

  static Color getColorWithString(String filter) {
    if (filter == "A") {
      return AppThemeUtils.orangeColor;
    } else if (filter == "F") {
      return AppThemeUtils.blueColor;
    } else if (filter == "H") {
      return AppThemeUtils.colorPrimary;
    } else {
      return Colors.grey[200];
    }
  }

  static getWithType(DateTime date, String filter) {
    if (date == null) {
      return false;
    }

    if (filter == "A") {
      return DateTime.now().isAfter(date);
    } else if (filter == "F") {
      return DateTime.now().isBefore(date);
    } else if (filter == "H") {
      return DateTime.now() == date;
    } else {
      return true;
    }
  }
}
