import 'dart:convert';

import 'package:tecnoanjos_franquia/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjos_franquia/app/utils/date_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

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
    'Otubro',
    'Novembro',
    'Dezembro'
  ];

  showSnackBars(String msg, GlobalKey<ScaffoldState> _scaffoldKey) {
    final snackBar = SnackBar(content: Text(msg));

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String unMask(String phone) {
    var _phoneUnMask = phone.replaceAll('(', '');
    _phoneUnMask = _phoneUnMask.replaceAll(')', '');
    _phoneUnMask = _phoneUnMask.replaceAll('-', '');
    return _phoneUnMask;
  }
  static String  getTypeStatus(String status) {
    switch(status){
      case 'PENDING':return"sendo preparado";
      case 'SEPARATION':return"Separando";
      case 'SENT':return"Enviado";
      case 'DELIVERED':return"Entregue";
      default:return "";
    }
  }
  Future<String> getCookieCache() async {
    /* final _sharedPreferences = SharedPreferencesHelper();
    final _constants = Constants;
    String result;

    await _sharedPreferences.get(_constants.JSESSIONID).then((value) {
      if (value.isNotEmpty) {
        result = 'JSESSIONID=$value';
      }
    });

    return result;*/

    return '';
  }

  static showSnackBar(String message,BuildContext context,
      {SnackBarAction action, int duration = 1200}) {
    showGenericDialog(context,
        iconData: Icons.error,
        title: "Ops",
        description:message, positiveCallback: () {

        }, positiveText: "OK");
  }

  String formatDate(String data) {
    var ff = monthLong[int.tryParse(data.substring(5, 7)) - 1];
    var dd = '${data.substring(8, 10)} de $ff de ${data.substring(0, 4)}';
    return dd;
  }

  String formatDateShort(String data) {
    var dd =
        '${data.substring(8, 10)}/${data.substring(5, 7)}/${data.substring(2, 4)}';
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
      return Theme.of(context).textTheme.bodyText1.color;
    } else if (status == "CONCLUIDO") {
      return AppThemeUtils.greenGC;
    } else {
      return Theme.of(context).textTheme.bodyText1.color;
    }
  }

  static String textToMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  static String textToBase64(String text) {
    return base64Encode(utf8.encode(text));
  }

  static String base64Totext(String text) {
    return utf8.decode(base64Decode(text.toString().replaceAll("\n", "")));
  }

  static getMaskPhone(String maskMoney) {
    if (maskMoney.length == 8) {
      return '0000-0000';
    } else if (maskMoney.length == 9) {
      return '90000-0000';
    } else if (maskMoney.length == 10) {
      return '(00) 0000-0000';
    } else {
      return '(00) 00000-00000';
    }
  }

  static cpfCnpj(String cpfpj) {
    var tamanho = (cpfpj ?? "").length;
    if (tamanho <= 11) {
      return ("000.000.000-00");
    } else {
      return ("00.000.000/0000-00");
    }
  }

  static String removeMask(String text) {
    var _phoneUnMask = text.replaceAll('(', '');
    _phoneUnMask = _phoneUnMask.replaceAll(')', '');
    _phoneUnMask = _phoneUnMask.replaceAll('-', '');
    _phoneUnMask = _phoneUnMask.replaceAll('.', '');
    _phoneUnMask = _phoneUnMask.replaceAll(' ', '');
    _phoneUnMask = _phoneUnMask.replaceAll('/', '');
    return _phoneUnMask;
  }

  static isSmall(BuildContext context) => MediaQuery.of(context).size.width < 900;

  static genderType(String gender) {
    if (gender == null) {
      return "--";
    } else {
      switch (gender) {
        case "M":
          return "Masculino";
          break;
        case "F":
          return "Feminino";
          break;
        default:
          return "Outros";
          break;
      }
    }
  }

  static String statusToText(String status) {
    switch (status) {
      case "P":
        return "Pendente";
        break;
      case "F":
        return "Finalizado";
        break;
      case "C":
        return "Cancelado";
        break;
      case "CC":
        return "Cancelado Cliente";
        break;
      case "CT":
        return "Cancelado Tecnico";
        break;
      default:
        return "Andamento";
        break;
    }
  }

  static String statusToPayment(String status) {
    switch (status) {
      case "P":
        return "Pago";
        break;
      default:
        return "Á pagar";
        break;
    }
  }


  static  bool isValidDate(String input) {
    try{
      final date = MyDateUtils.convertStringToDateTime(input);
      if(date == null){
        return false;
      }
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    }catch(e){
      return false;
    }

  }
  static  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }
}
