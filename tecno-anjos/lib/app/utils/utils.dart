import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:geocoder/model.dart';
import 'package:get_mac/get_mac.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/address.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'activity/activity_utils.dart';
import 'date/date_utils.dart';

class Utils {
  final List<String> monthLong = const <String>[
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  String unMask(String phone) {
    var _phoneUnMask = phone.replaceAll('(', '');
    _phoneUnMask = _phoneUnMask.replaceAll(')', '');
    _phoneUnMask = _phoneUnMask.replaceAll('-', '');
    return _phoneUnMask;
  }

  static showSnackBar(String message, BuildContext context,
      {SnackBarAction action, int duration = 1200}) {
    try {
      if (context != null) {
        showGenericDialog(
            context: context,
            title: "Atenção!",
            description: "$message",
            iconData: Icons.warning_rounded,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    } catch (e) {}
  }

  String formatDate(String data) {
    var ff = monthLong[int.tryParse(data.substring(5, 7)) - 1];
    var dd = '${data.substring(8, 10)} de $ff de ${data.substring(0, 4)}';
    return dd;
  }

  String formatDateShort(String data) {
    var dd =
        '${data.substring(8, 10)}/${data.substring(5, 7)}/${data.substring(
        2, 4)}';
    return dd;
  }

  static String moneyFormat(double valor) {
    var controllerFormat = new MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$ ');
    controllerFormat.updateValue(valor ?? 0.0);
    return controllerFormat.text;
  }

  static void hideKeyBoard(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  static String defaultStatusByName(String status) {
    if (status == "EM_ABERTO") {
      return "Em aberto";
    } else if (status == "CONCLUIDO") {
      return "Concluído";
    } else {
      return "";
    }
  }

  static Color defaultColorByName(BuildContext context, String status) {
    if (status == "EM_ABERTO") {
      return Theme
          .of(context)
          .textTheme
          .bodyText1
          .color;
    } else if (status == "CONCLUIDO") {
      return AppThemeUtils.greenGC;
    } else {
      return Theme
          .of(context)
          .textTheme
          .bodyText1
          .color;
    }
  }

  static String addressFormat(Address value) {
    return "${value.thoroughfare ?? value.featureName}";
  }

  static String addressFormatMyData(MyAddress myAddress) {
    if (myAddress == null) {
      return '--';
    } else {
      return "${myAddress.myAddress} ${myAddress.num} - ${myAddress
          .neighborhood}, ${myAddress.nameRegion}";
    }
  }

  static getMaskPhone(String text) {
    return '(00) 0 0000-0000';
  }

  static cpfCnpj(String cpfpj) {
    var tamanho = (cpfpj ?? "").length;
    if (tamanho <= 11) {
      return ("000.000.000-00");
    } else {
      return ("00.000.000/0000-00");
    }
  }

  static genderType(String gender) {
    if (gender == null) {
      return "--";
    } else {
      switch (gender) {
        case "M":
          return "Masculino";
          break;
        case ActivityUtils.FINALIZADO:
          return "Feminino";
          break;
        default:
          return "Outros";
          break;
      }
    }
  }

  static removeMask(String text) {
    var _phoneUnMask = text?.replaceAll('(', '');
    _phoneUnMask = _phoneUnMask?.replaceAll(')', '');
    _phoneUnMask = _phoneUnMask?.replaceAll(' ', '');
    _phoneUnMask = _phoneUnMask?.replaceAll('-', '');
    _phoneUnMask = _phoneUnMask?.replaceAll('.', '');
    _phoneUnMask = _phoneUnMask?.replaceAll(' ', '');
    return _phoneUnMask;
  }

  static Future<String> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = kIsWeb ? "Web" : await GetMac.macAddress;
    } on PlatformException {
      platformVersion = 'Web';
    }catch(e){
      platformVersion = Platform.isAndroid ? "Android_${e.toString()}".replaceAll(" ", "") :  "Ios_${e.toString()}".replaceAll(" ", "");
    }
    return platformVersion;
  }


  static bool isMinLetter(String text, int i) {
    return text.length > i;
  }

  static bool isUppercase(String text) {
    return text.contains(new RegExp(r'[A-Z]'));
  }

  static bool isCharacter(String text) {
    return text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static bool hasDigits(String text) {
    return text.contains(new RegExp(r'[0-9]'));
  }

  static fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static String getTitlePopup(String popupStatus) {
    switch (popupStatus) {
      case "A":
        return "Atendimento aceito";
      case "C":
        return "Atendimento cancelado";
      case "CR":
        return "Atendimento reagendado";
      case "R":
        return "Atendimento recusado";
      default:
        return "Atendimento";
    }
  }

  static isSmall(BuildContext context) =>
      MediaQuery
          .of(context)
          .size
          .width < 900;

  static String getYearOld(Profile profile) {
    var date = DateTime.now();

    var years = date.year - (MyDateUtils
        .convertStringToDateTime(profile.birthDate) ?? date)
        .year;
    return  years  == 0 ? "" :"$years anos";
  }

  static showMessagePass(String pass, BuildContext context) {
    List<String> listError = [];

    if (!Utils.isMinLetter(pass, 6)) {
      listError.add(StringFile.minimo6Digitos.toLowerCase());
    }
    if (!Utils.hasDigits(pass)) {
      listError.add(StringFile.numero.toLowerCase());
    }
    if (!Utils.isUppercase(pass)) {
      listError.add(StringFile.letrasMaiusculas.toLowerCase());
    }
    if (!Utils.isCharacter(pass)) {
      listError.add("Caracter especial");
    }

    if (listError.isNotEmpty) {
      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: AppThemeUtils.colorPrimary,
        message: "Adicione ${listError.join(", ")}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: AppThemeUtils.whiteColor,
        ),
        duration: Duration(seconds: 5),
      )..show(context);
    }
  }
}
