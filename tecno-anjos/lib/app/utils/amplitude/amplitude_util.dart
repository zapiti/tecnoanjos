import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import '../../app_bloc.dart';

class AmplitudeUtil {

  static final _amplitudeInstanceName = "Tecnoanjos-tecnico";
  static final _amplitudeKey = "726666485ec51de6479e7a5e98adb8bb";

  static String finalizouOnboard = "FINALIZOU O ONBOARD";

  static String iniciouOnboard = "INICIOU O ONBOARD";

  static String eventoSaiuDoApp = "SAIU DO APP";

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
    if(!kIsWeb) {
      var appBLoc = Modular.get<AppBloc>();

      final Amplitude analytics =
      Amplitude.getInstance(instanceName: _amplitudeInstanceName);

      analytics.init(_amplitudeKey);

      analytics.enableCoppaControl();
      var currentUser = appBLoc
          .getCurrentUserFutureValue()
          .stream
          .value;
      var url = Flavor.I.getString(Keys.apiUrl);
      var horario = MyDateUtils.getTrueTime();
      analytics.setUserId(
          "${currentUser?.id} - ${currentUser?.telephone}");
      analytics.trackingSessionEvents(true);

      analytics.logEvent(
          eventType, eventProperties: {"SERVIDOR": url, "HORARIO":
      MyDateUtils.parseDateTimeFormat(
          horario, horario, format: "dd/MM/yyyy HH:mm")});
    }
  }

 static Future<void> exampleForAmplitude() async {

    final Amplitude analytics = Amplitude.getInstance(instanceName: "project");
    analytics.init(_amplitudeKey);

    analytics.enableCoppaControl();

    analytics.setUserId("test_user");

    analytics.trackingSessionEvents(true);

    analytics.logEvent('MyApp startup', eventProperties: {
      'friend_num': 10,
      'is_heavy_user': true
    });

    final Identify identify1 = Identify()
      ..set('identify_test',
          'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
      ..add('identify_count', 1);
    analytics?.identify(identify1);

    analytics.setGroup('orgId', 15);

    final Identify identify2 = Identify()
      ..set('identify_count', 1);
    analytics.groupIdentify('orgId', '15', identify2);
  }


}
