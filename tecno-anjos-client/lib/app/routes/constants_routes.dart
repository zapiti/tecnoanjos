import 'package:flutter/material.dart';

class ConstantsRoutes {
  //static const String INICIO = '/inicio';
  static const String HOMEPAGE = '/homepage';
  static const String LOGIN = '/login';
  static const String RECOVERYPASS = '/recuperarsenha';
  static const String REGISTRE = '/registrar';
  static const String CALL_RECOVERYPASS = LOGIN + RECOVERYPASS;
  static const String MEUPERFIL = '/meuperfil';
  static const String PLANSSERVICES = '/servicos';
  static const String AVALIACOES = '/avaliacoes';

  static const String MAKE_AVALIATION = '/make-avaliation';

  static const String CALL_MAKE_AVALIATION = AVALIACOES+MAKE_AVALIATION;

 // static const String QUALIFICACOES = '/qualificacoes';
 // static const String REGIAOATENDIMENTO = '/regiaoatendimento';
  //static const String HORARIOSATENDIMENTO = '/horariosatendimento';
  static const String MEUSATENDIMENTOS = '/meusatendimentos';
  static const String MEUSPAGAMENTOS = '/meuspagamentos';
  static const String CONFIGURACOES = '/configuracoes';
  static const String CENTRALDEAJUDA = '/centraldeajuda';
  static const String CHAMARCEU = '/chamarceu';
  static const String INICIARCHAMADO = '/iniciarchamado';
  static const String FAQ = '/faq';
  static const String CALLING = '/chamado';

  static const String CARTEIRA = '/carteira';
  static const String ENDERECOS = '/enderecos';
  static const String ATENDIMENTO_ATUAL = '/atendimento-atual';
  static const String ATENDIMENTO_AWAIT = '/atendimento-espera';
  static const String CALLING_ATENDIMENTO_AWAIT = CALLING + ATENDIMENTO_AWAIT;
  static const String DETAILS_AVALIATION = '/detail-avaliation';
  static const String CALL_DETAILS_AVALIATION = AVALIACOES + DETAILS_AVALIATION;
  static const String DETAILS_ATTENDANCE = '/detail-attendance';
  static const String CALL_DETAILS_ATTENDANCE =
      MEUSATENDIMENTOS + DETAILS_ATTENDANCE;
 // static const String CURRRENT_ATTENDANCE = '/current-attendance';
  //static const String CALL_CURRENT_ATTENDANCE = HOMEPAGE + CURRRENT_ATTENDANCE;

  static const String PENDENCY = '/pendencia';
  static const String CALLPENDENCY = HOMEPAGE + PENDENCY;

  static const String DETAILS_PAYMENT = '/detalhe-pagamento';
  static const String CALL_DETAILS_PAYMENT = MEUSPAGAMENTOS + DETAILS_PAYMENT;

  static const String CARTEIRA_CLIENTES = '/meus-clientes';

  static const String CALLING_EDITONLY = '/editar-chamado';
  static const String CALLING_PAYMENT = '/calling-payment';

  static const String SEARCH = '/search';

  static const String CHATTECNOCLIENT = '/chat-tecnocliente';

  static const String SUGESTIONS = '/sugestoes';

  static const String LOSTCONECTION = '/lost-conection';

  static const SELECTEDADDRESS = '/select-address';

  static const CALL_SELECTED_ADDRESS = ENDERECOS + SELECTEDADDRESS;

  static const SPLASH = '/slash';

  static const String PLAINS = '/planos';

  static const String CHAT = '/chat';

  static const String CREATEATTENDANCE = '/createattendance';

  static const String TESTE = "/teste";




  static String getNameByRoute(
    String route,
  ) {
    switch (route) {
      case ConstantsRoutes.HOMEPAGE:
        return "Início";
        break;
      case ConstantsRoutes.MEUPERFIL:
        return "Perfil";
        break;
      case ConstantsRoutes.CARTEIRA_CLIENTES:
        return "Tecnoanjo favorito";
        break;
      case ConstantsRoutes.PLAINS:
        return "Planos e Pacotes";
        break;
      case ConstantsRoutes.SUGESTIONS:
        return "Sugestões/Críticas";
        break;
      case ConstantsRoutes.CARTEIRA:
        return "Carteira";
        break;
      case ConstantsRoutes.ENDERECOS:
        return "Meus Endereços";
        break;
      case ConstantsRoutes.AVALIACOES:
        return "Avaliações";
        break;
      // case ConstantsRoutes.QUALIFICACOES:
      //   return "Qualificações técnicas";
      //   break;
      // case ConstantsRoutes.HORARIOSATENDIMENTO:
      //   return "Horários de atendimento";
      //   break;
      // case ConstantsRoutes.REGIAOATENDIMENTO:
      //   return "Região de atendimento";
      //   break;
      case ConstantsRoutes.MEUSATENDIMENTOS:
        return "Meus atendimentos";
        break;
      case ConstantsRoutes.MEUSPAGAMENTOS:
        return "Pagamentos realizados";
        break;
      case ConstantsRoutes.CONFIGURACOES:
        return "Configurações";
        break;
      case ConstantsRoutes.FAQ:
        return "FAQ";
        break;
      case ConstantsRoutes.INICIARCHAMADO:
        return "Iníciar/Encerrar";
        break;
      case ConstantsRoutes.CHAMARCEU:
        return "Chamar Céu";
        break;
      case ConstantsRoutes.CENTRALDEAJUDA:
        return "Central de ajuda";
        break;
      case ConstantsRoutes.ATENDIMENTO_AWAIT:
        return "Espera por atendimento";
        break;
      case ConstantsRoutes.PLANSSERVICES:
        return "Planos e pacotes";
        break;
      case ConstantsRoutes.TESTE:
        return "Tela teste";
        break;
      default:
        return "Alteração";
        break;
    }
  }

  static bool containsSearch(String route) {

    if (route == FAQ || route == CENTRALDEAJUDA) {
      return true;
    }
    return false;
  }



  static TextInputType keyBordTypeFilter(String route) {
    return TextInputType.number;
  }
}
