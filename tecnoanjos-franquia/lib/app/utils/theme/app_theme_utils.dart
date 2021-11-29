import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/hex_color_utils.dart';

enum ThemeSize { BIG, MEDIUM, SMALL }
enum ThemeLayoutType { WEB, ANDROID, IOS }

class AppThemeUtils {
  static var lightGray = Colors.grey[300];




  static TextStyle bigBoldSize({Color color}) => GoogleFonts.ubuntu(
      decoration: TextDecoration.none,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: color);

  static TextStyle bigSize({Color color, double fontSise = 22}) =>
      GoogleFonts.ubuntu(
          decoration: TextDecoration.none, fontSize: fontSise, color: color);

  static TextStyle normalBoldSize({Color color, double fontSize = 16}) =>
      GoogleFonts.ubuntu(
          decoration: TextDecoration.none,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color);

  static TextStyle normalSize({
    Color color,
    double fontSize = 16,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      GoogleFonts.ubuntu(
          decoration: decoration,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color);

  static TextStyle smallSize({Color color, double fontSize = 14}) =>
      GoogleFonts.ubuntu(
          decoration: TextDecoration.none, fontSize: fontSize, color: color);
  static Color colorPrimaryClient = HexColor("00A4D5"); //"00A4D5");
  static var colorSecundary = Colors.white;
  static Color colorPrimaryLight = HexColor("00A4D5"); //"00A4
  static Color colorPrimary = HexColor("00A4D5"); //"00A4D5");
  static Color colorPrimaryDark = HexColor("041E42"); //"00A4D5");
  static Color black = Colors.black;
  static Color colorText = Colors.black;
  static Color darkGrey = Colors.grey[400];
  static Color colorGreenLight = HexColor("55BB9D");
  static Color colorRedLight = HexColor("F2A5A5");
  static Color whiteColor = HexColor("FFFFFF");
  static Color colorSuccess = HexColor("FFFFFF");
  static Color colorError = Colors.grey;
  static Color greenGC = HexColor("6c966d");
  static Color pinkGC = HexColor("FF5CA1");
  static Color yellowGC = HexColor("FFB800");
  static Color blueGC = HexColor("57CAFB");
  static var colorGrayLight = Colors.grey[400];
  static Color orangeColor = HexColor("F06565");
  static Color blueColor = HexColor("309AE7");
  static var iconColor = HexColor("00A4D5");

  static bool isWeb(BuildContext context) {
    return kIsWeb;
  }
}

bool getSizeResponsive(BuildContext context) {
  return MediaQuery.of(context).size.width > 800;
}

double getSizeResponsiveWidth() {
  return 800;
}
