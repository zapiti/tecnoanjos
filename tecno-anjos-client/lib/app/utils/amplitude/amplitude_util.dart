import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';

class AmplitudeUtil {
  static final _amplitudeInstanceName = "Tecnoanjos-cliente";
  static final _amplitudeKey = "2ceb92614f742a6825ae290cc70cc335";

  static String eventoSucessoAoCadastrar = "SUCESSO AO CADASTRAR";

  static String eventoFalhaAoCadastrar = "FALHA AO CADASTRAR";

  static String finalizouOnboard = "FINALIZOU O ONBOARD";

  static String iniciouOnboard = "INICIOU O ONBOARD";

  static String eventoSaiuDoApp = "SAIU DO APP";

  static String tocouNoBotaoIniciarAtendimento = "TOCOU NO BOTAO INICIAR ATENDIMENTO";

  static String atendimentoImediatoCriadoComSucesso = "ATENDIMENTO IMEDIATO CRIADO";

  static String atendimentoAgendadoCriadoComSucesso = "ATENDIMENTO AGENDADO CRIADO";

  static String atendimentoAgendadoFalha = "ATENDIMENTO AGENDADO FALHA NA CRIACAO";

  static String atendimentoImediatoFalha = "ATENDIMENTO IMEDIATO FALHA NA CRIACAO";

  static String sucessoAoSalvarEndereco = "SUCESSO AO SALVAR ENDEREÇO";

  static String falhaAoSalvarEndereco = 'FALHA AO SALVAR ENDEREÇO';

  static String cepNaoEncontrado = "CEP NÃO ENCONTRADO";

  static String sucessoAoSAlvarFormaDePagamento = "SUCESSO AO SALVAR FORMA DE PAGAMENTO";

  static String falhaAoSalvarFormaDePagamento = "FALHA AO SALVAR FORMA DE PAGAMENTO";

  static String abriuvideo = "ABRIR VIDEO";

  static String eventoEntrouNaTela(String upperCase) => "ENTROU NA TELA $upperCase";

  static eventoErroBackandByStatus(status) => "FALHA BACKAND CODIGO ($status)";

  static eventoPrimeiraTelaCadastroDeUsuario(etapa) =>
      "CADASTRO DE USUARIO ETAPA ($etapa)";

  static eventoCadastroDeUsuario(etapa) => "CADASTRO DE USUARIO ETAPA ($etapa)";

  static eventCriarAtendimento(etapa) => "CRIAR UM CHAMADO ETAPA ($etapa)";

  static eventoEmAtendimento(etapa) => "EM ATENDIMENTO ETAPA ($etapa)";
  static eventoFalhaEmAtendimento(etapa) => "FALHA EM ATENDIMENTO ETAPA ($etapa)";

  static Future<void> createEvent(String eventType,
      {Map<String, dynamic> eventProperties}) async {
    if (!kIsWeb) {
      final appBloc = Modular.get<AppBloc>();
      // Create the instance
      final Amplitude analytics =
      Amplitude.getInstance(instanceName: _amplitudeInstanceName);

      // Initialize SDK
      analytics.init(_amplitudeKey);

      // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
      analytics.enableCoppaControl();

      // Set user Id
      var currentUser = appBloc
          .getCurrentUserFutureValue()
          .stream
          .value;
      var url =  Flavor.I.getString(Keys.apiUrl);
      var horario = await MyDateUtils.getTrueTime();
      analytics.setUserId(
          "${currentUser?.id} - ${currentUser?.telephone}");

      // Turn on automatic session events
      analytics.trackingSessionEvents(true);

      // Log an event
      analytics.logEvent(eventType, eventProperties: {
        "SERVIDOR": url,
        "HORARIO": MyDateUtils.parseDateTimeFormat(
            horario, horario, format: "dd/MM/yyyy HH:mm")
      });
    }
  }

    static Future<void> exampleForAmplitude() async {
      // Create the instance
      final Amplitude analytics = Amplitude.getInstance(
          instanceName: "project");

      // Initialize SDK
      analytics.init(_amplitudeKey);

      // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
      analytics.enableCoppaControl();

      // Set user Id
      analytics.setUserId("test_user");

      // Turn on automatic session events
      analytics.trackingSessionEvents(true);

      // Log an event
      analytics.logEvent('MyApp startup', eventProperties: {
        'friend_num': 10,
        'is_heavy_user': true
      });

      // Identify
      final Identify identify1 = Identify()
        ..set('identify_test',
            'identify sent at ${DateTime
                .now()
                .millisecondsSinceEpoch}')
        ..add('identify_count', 1);
      analytics?.identify(identify1);

      // Set group
      analytics.setGroup('orgId', 15);

      // Group identify
      final Identify identify2 = Identify()
        ..set('identify_count', 1);
      analytics.groupIdentify('orgId', '15', identify2);
    }



}
