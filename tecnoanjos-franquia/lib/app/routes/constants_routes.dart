import 'package:flutter/material.dart';

class ConstantsRoutes {
//LOJISTA
  static const String LOGIN = '/login';

  static const String HOME = TECNICOS;


  static const String SPLASH = '/splash';

  static const String LOSTCONECTION = '/lost-conection';

  static String SEARCH = '/search';

  static const  String TECNICOS = '/tecnicos';
  static const String NOVO_TECNICO = '/novotecnico';
  static const String CALL_NOVO_TECNICO = TECNICOS+NOVO_TECNICO;
  static const  String ATTENDANCE = '/atendimentos';

  static const  String PAGAMENTO = '/pagamento';

  // static const  String RELATORIO = '/pagamento';

  static String getNameByRoute(String route) {
    switch (route) {

      // case ConstantsRoutes.HOME:
      //   return "Inicio";
      //   break;
      case ConstantsRoutes.TECNICOS:
        return "Tecnoanjos";
        break;
      case ConstantsRoutes.ATTENDANCE:
        return "Atendimentos";
        break;
      case ConstantsRoutes.PAGAMENTO:
        return "Pagamentos";
        break;
      default:
        return "Início";
        break;
    }
  }

  static bool containsSearch(String route) {
    // MetaDataBloc().updatePrimaryConfig(null);
//    if (route == FAQ || route == CENTRALDEAJUDA) {
//      return true;
//    }
    return false;
  }

  static containsFilter(String route) {
//    if (route == HORASTRABALHADAS) {
////      if (route == MEUSPEDIDOS) {
////        OrderedBloc().getListConfig(homeContextGlobal);
////      } else {
////        FinanceBloc().getListConfig(homeContextGlobal);
////      }
//      return true;
//    }
  }

  static TextInputType keyBordTypeFilter(String route) {
//    if (route == FiCHATECNICA || route == QUESTIONS || route == CAMPANHA) {
//      return TextInputType.text;
//    }
    return TextInputType.number;
  }
}
