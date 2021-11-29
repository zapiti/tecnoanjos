class ConstantsRoutes {
  static const String HOMEPAGE = '/homepage';
  static const String LOGIN = '/login';
  static const String RECOVERYPASS = '/recuperarsenha';
  static const String CALL_RECOVERYPASS = LOGIN + RECOVERYPASS;
  static const String MEUPERFIL = '/meuperfil';
  static const String HORASTRABALHADAS = '/horastrabalhadas';
  static const String AVALIACOES = '/avaliacoes';
  static const String REGIAOATENDIMENTO = '/regiaoatendimento';
  static const String MEUSATENDIMENTOS = '/meusatendimentos';
  static const String MEUSPAGAMENTOS = '/tecno-meuspagamentos';
  static const String CONFIGURACOES = '/configuracoes';
  static const String CENTRALDEAJUDA = '/centraldeajuda';
  static const String CHAMARCEU = '/chamarceu';
  static const String INICIARCHAMADO = '/iniciarchamado';

  static const String FAQ = '/faq';
  static const String ONBOARD = '/onboard';
  static const String TABELA_DE_VALORES = '/tecno-tabeladeprecos';
  static const String DETAILS_AVALIATION = '/detail-avaliation';
  static const String CALL_DETAILS_AVALIATION = AVALIACOES + DETAILS_AVALIATION;
  static const String DETAILS_ATTENDANCE = '/detail-attendance';
  static const String CALL_DETAILS_ATTENDANCE =
      MEUSATENDIMENTOS + DETAILS_ATTENDANCE;

  static const String DETAILS_PAYMENT = '/tecno-detalhe-pagamento';
  static const String CALL_DETAILS_PAYMENT = MEUSPAGAMENTOS + DETAILS_PAYMENT;


  static const String CARTEIRA_CLIENTES = '/tecno-carteira-de-clientes';

  static const String INFORMATIVO = '/admin-informativo';

  static const String FINANCEIRO = '/admin-financeiro';

  static const String SUGESTIONS = '/sugestoes';

  static const String NOTFOULD = '/notfould';

  static const String CHATTECNOCLIENT = '/chat-tecnocliente';
  static const String CALLING_EDITONLY = '/editar-chamado';

  static const String BE_A_CLIENTE = '/landing-page-seja-cliente';

  static const String BE_A_TECNO = '/landing-page-seja-tecnico';

  static const String SPLASHPAGE = "/splashpage";

  static const String LOGIN_LANDING = "/lading-page-login";

  static const String SPLASH = '/splash';

  static const String LOSTCONECTION = '/lost-conection';

  static const String MAKE_AVALIATION = '/make-avaliation';

  static const String CALL_MAKE_AVALIATION = AVALIACOES + MAKE_AVALIATION;

  static String getNameByRoute(String route, {isOnline = false}) {
    switch (route) {
      case ConstantsRoutes.HOMEPAGE:
        return isOnline ? "Online" : 'Offline';
        break;
      case ConstantsRoutes.MEUPERFIL:
        return "Perfil";
        break;
      case ConstantsRoutes.HORASTRABALHADAS:
        return "Horas trabalhadas";
        break;
      case ConstantsRoutes.AVALIACOES:
        return "Avaliações";
        break;
      case ConstantsRoutes.REGIAOATENDIMENTO:
        return "Região de atendimento";
        break;
      case ConstantsRoutes.MEUSATENDIMENTOS:
        return "Meus atendimentos";
        break;
      case ConstantsRoutes.MEUSPAGAMENTOS:
        return "Meus pagamentos";
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
      case ConstantsRoutes.CARTEIRA_CLIENTES:
        return "Carteira de clientes";
        break;
      case ConstantsRoutes.INFORMATIVO:
        return "Informativo";
        break;
      case ConstantsRoutes.FINANCEIRO:
        return "Financeiro";
        break;
      case ConstantsRoutes.SUGESTIONS:
        return "Sugestões/Críticas";
        break;

      case ConstantsRoutes.BE_A_TECNO:
        return "Seja um franqueado";
        break;

      case ConstantsRoutes.BE_A_CLIENTE:
        return "Seja um cliente";
        break;
      case ConstantsRoutes.LOGIN_LANDING:
        return "Login";
        break;
      case ConstantsRoutes.LOGIN:
        return "Login";
        break;

      default:
        return "Início";
        break;
    }
  }

  static bool containsSearch(String route) {
    if (route == FAQ || route == CENTRALDEAJUDA) {
      return true;
    }
    return false;
  }

  static containsFilter(String route) {}

  static List<String> listRoutes() {
    return [
      HOMEPAGE,
      LOGIN,
      MEUPERFIL,
      HORASTRABALHADAS,
      AVALIACOES,
      REGIAOATENDIMENTO,
      MEUSATENDIMENTOS,
      MEUSPAGAMENTOS,
      CONFIGURACOES,
      CENTRALDEAJUDA,
      CHAMARCEU,
      INICIARCHAMADO,
      FAQ,
      ONBOARD,
      TABELA_DE_VALORES
    ];
  }
}
