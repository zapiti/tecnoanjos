import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/cupertino.dart';

class NegociationUtils {
  static String statusName(String status) {
    return status == "N" ? "NÃO DEFINIDO" : status == "P" ? "PERDIDO" : "GANHO";
  }

  static Color statusColor(String status) {
    return status == "N"
        ? AppThemeUtils.darkGrey
        : status == "P" ? AppThemeUtils.colorError : AppThemeUtils.colorPrimary;
  }
}
