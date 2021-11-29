import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/model.dart';
import 'package:get_mac/get_mac.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/selected_address_page.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/calling.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'attendance/activity_utils.dart';
import 'date_utils.dart';
import 'image/image_path.dart';
import 'object/object_utils.dart';

class Utils {
  static List<Pairs> listStates = [
    Pairs('AC', 'Acre'),
    Pairs('AL', 'Alagoas'),
    Pairs('AP', 'Amapá'),
    Pairs('AM', 'Amazonas'),
    Pairs('BA', 'Bahia'),
    Pairs('CE', 'Ceará'),
    Pairs('DF', 'Distrito Federal'),
    Pairs('ES', 'Espirito Santo'),
    Pairs('GO', 'Goiás'),
    Pairs('MA', 'Maranhão'),
    Pairs('MS', 'Mato Grosso do Sul'),
    Pairs('MT', 'Mato Grosso'),
    Pairs('MG', 'Minas Gerais'),
    Pairs('PA', 'Pará'),
    Pairs('PB', 'Paraíba'),
    Pairs('PR', 'Paraná'),
    Pairs('PE', 'Pernambuco'),
    Pairs('PI', 'Piauí'),
    Pairs('RJ', 'Rio de Janeiro'),
    Pairs('RN', 'Rio Grande do Norte'),
    Pairs('RS', 'Rio Grande do Sul'),
    Pairs('RO', 'Rondônia'),
    Pairs('RR', 'Roraima'),
    Pairs('SC', 'Santa Catarina'),
    Pairs('SP', 'São Paulo'),
    Pairs('SE', 'Sergipe'),
    Pairs('TO', 'Tocantins'),
  ];

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
      listError.add(StringFile.caracterEsp.toLowerCase());
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

  static addressFormatMyData(MyAddress myAddress) {
    if (myAddress == null) {
      return '--';
    } else {
      return "${myAddress.myAddress} ${myAddress.num} - ${myAddress.neighborhood}, ${myAddress.nameRegion}";
    }
  }

  static limitSizeOfNumber(
      String newVal, int maxLength, TextEditingController controller) {
    String text = controller.text;
    if (newVal.length <= maxLength) {
      text = newVal;
    } else {
      controller.value = new TextEditingValue(
          text: text,
          selection: new TextSelection(
              baseOffset: maxLength,
              extentOffset: maxLength,
              affinity: TextAffinity.downstream,
              isDirectional: false),
          composing: new TextRange(start: 0, end: maxLength));
      controller.text = text;
    }
  }

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

  String unMask(String phone) {
    var _phoneUnMask = phone?.replaceAll('(', '');
    _phoneUnMask = _phoneUnMask?.replaceAll(')', '');
    _phoneUnMask = _phoneUnMask?.replaceAll('-', '');
    return _phoneUnMask;
  }

  Future<String> getCookieCache() async {
    return '';
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

    // final snackBar = SnackBar(
    //   content: Text(message),
    //   elevation: 0,
    //   duration: Duration(milliseconds: duration),
    //   behavior: SnackBarBehavior.floating,
    //   action: action,
    // );
    // _scaffoldKey.currentState.showSnackBar(snackBar);
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
          return null;
          break;
      }
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

  static String addressFormat(Address value) {
    return "${value.thoroughfare ?? value.featureName}";
  }

  static getMaskPhone(String text) {
    // if(updateController == null){
    //   if ((text?.length ?? 0) >= 13 || text?.length == 0) {
    //     if (updateController != null) {
    //       updateController('(00) 0 0000-0000');
    //     }
    //
    //     return '(00) 0 0000-0000';
    //   }else {
    //     return '(00) 0 0000-0000';
    //   }
    // }else{
    //   if (text?.length == 13 || text?.length == 0) {
    //     if (updateController != null) {
    //       updateController('(00) 0000-0000');
    //     }
    //
    //     return '(00) 0000-0000';
    //   }
    //   if ((text?.length ?? 0) >= 14) {
    //     if (updateController != null) {
    //       updateController('(00) 0 0000-0000');
    //     }
    return '(00) 0 0000-0000';
    // }
    //}
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
    var _phoneUnMask = text?.replaceAll('(', '');
    _phoneUnMask = _phoneUnMask?.replaceAll(')', '');
    _phoneUnMask = _phoneUnMask?.replaceAll(' ', '');
    _phoneUnMask = _phoneUnMask?.replaceAll('-', '');
    _phoneUnMask = _phoneUnMask?.replaceAll('.', '');
    _phoneUnMask = _phoneUnMask?.replaceAll(' ', '');
    return _phoneUnMask;
  }

  static String geMaskCep() {
    return '00.000-000';
  }

  static Future<String> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = kIsWeb ? "Web" : await GetMac.macAddress;
    } on PlatformException {
      platformVersion = 'Web';
    } catch (e) {
      platformVersion = Platform.isAndroid
          ? "Android_${e.toString()}".replaceAll(" ", "")
          : "Ios_${e.toString()}".replaceAll(" ", "");
    }
    return platformVersion;
  }

  // bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  // bool hasDigits = password.contains(new RegExp(r'[0-9]'));
  // bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
  // bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  // bool hasMinLength = password.length > minLength;

  static bool isMinLetter(String text, int i) {
    return text.length > i;
  }

  static bool isUppercase(String text) {
    return text.contains(new RegExp(r'[A-Z]'));
  }

  static bool isCharacter(String text) {
    return text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static bool isCep(String text) {
    return text.contains(new RegExp(r'[d{5}[-]d{2}]'));
  }

  static bool hasDigits(String text) {
    return text.contains(new RegExp(r'[0-9]'));
  }

  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    //currentFocus.nextFocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static Future<MyAddress> goToAddress(BuildContext context, String cep) async {
    var group = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressSearchPage(cep)),
    );
    // Modular.to
    //      .pushNamed(ConstantsRoutes.CALL_SELECTED_ADDRESS,);
    return group;
  }

  static String getTitlePopup(Attendance attendance) {
    switch (attendance.popupStatus) {
      case "A":
        return "Atendimento aceito";
      case "C":
        return "Atendimento cancelado";
      case "CR":
        return attendance?.userTecno?.id == null
            ? "Nenhum Tecnoanjo encontrado"
            : "Reagende seu atendimento";
      case "R":
        return "Atendimento recusado";
      default:
        return "Atendimento";
    }
    // popupStatus = "A" 'Aceito' (atendimento aceito)
    // popupStatus = "C" 'Cancelado' (atendimento cancelado pelo servico de cancelar)
    // popupStatus = "CR" ='Cancelado /Reagendar' (atendimento cancelado pelo notInitNow)
    // popupStatus = "R" ='Recusado' (atendimento recusado)
  }

  static String getImageByIndexOnboard(int countEtapa) {
    switch (countEtapa) {
      case 0:
        return "Atendimento aceito";
      case 0:
        return "Atendimento cancelado";
      case 0:
        return "Atendimento recusado";
      case 0:
        return "Atendimento recusado";
      default:
        return ImagePath.inAttendance;
    }
  }

  static isSmall(BuildContext context) =>
      MediaQuery.of(context).size.width < 900;

  static String getYearOld(Profile profile) {
    var date = DateTime.now();

    var years = date.year -
        (MyDateUtils.convertStringToDateTime(profile.birthDate) ?? date).year;
    return "$years anos";
  }

  static IconData getIconToPayment(AsyncSnapshot<Calling> snapshot) {
    IconData ccBrandIcon;
    if (snapshot?.data?.wallet?.brand?.toLowerCase()?.contains('visa') ==
        true) {
      ccBrandIcon = FontAwesomeIcons.ccVisa;
    } else if (snapshot?.data?.wallet?.brand
            ?.toLowerCase()
            ?.contains('master') ==
        true) {
      ccBrandIcon = FontAwesomeIcons.ccMastercard;
    } else if (snapshot?.data?.wallet?.brand
                ?.toLowerCase()
                ?.contains('american') ==
            true ||
        snapshot?.data?.wallet?.brand?.toLowerCase()?.contains('amex') ==
            true) {
      ccBrandIcon = FontAwesomeIcons.ccAmex;
    } else if (snapshot?.data?.wallet?.brand
            ?.toLowerCase()
            ?.contains('discover') ==
        true) {
      ccBrandIcon = FontAwesomeIcons.ccDiscover;
    } else if (snapshot?.data?.wallet?.brand
            ?.toLowerCase()
            ?.contains('diners') ==
        true) {
      ccBrandIcon = FontAwesomeIcons.ccDinersClub;
    } else if (snapshot?.data?.wallet?.brand?.toLowerCase()?.contains('jcb') ==
        true) {
      ccBrandIcon = FontAwesomeIcons.ccJcb;
    } else {
      ccBrandIcon = MaterialCommunityIcons.credit_card;
    }
    return ccBrandIcon;
  }

  static int getCountByPairs(
      Pairs elements, List<ServiceProd> listServiceProd) {
    final totalList =
        ObjectUtils.parseToObjectList<ServiceProd>(listServiceProd) ?? [];

    final list =
        totalList.where((element) => element.type == elements.third).toList();

    return list.length;
  }
}
