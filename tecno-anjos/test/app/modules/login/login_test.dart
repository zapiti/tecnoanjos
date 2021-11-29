

import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnoanjostec/app/app_module.dart';
import 'package:tecnoanjostec/app/configuration/aws_configuration.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/modules/general/login/repositories/auth_repository.dart';
import 'constant/login_test_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Modular.init(AppModule());
  Modular.bindModule(AppModule());

  var _requestManager = Modular.get<RequestCore>();
  body(username, password, asignature) => {
        'phone': username ?? "",
        'password': password ?? "",
        'client': 'TECNO',
        "signature": asignature
      };

  setUp(() {
    // mockDataConnectionChecker = MockDataConnectionChecker();
    // networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);

    // responseLogin = json.decode(
    //   fixture('top_headlines_news_response_model.json'),
    // );
  });

  group('TESTE DE LOGIN', () {
    //CT0001
    test(
      'CT0001 - Validar login de um técnico válido do tipo homebased',
      () async {
        // for (var i = 0; i <= 1000; i++) {

          var result = await _requestManager.requestWithTokenToForm(
              AuthRepository.LOGIN,
              serviceName: AuthRepository.SERVICELOGIN,
              test: true,
              body: body(AwsConfiguration.USERTESTHOMEBASED,
                  AwsConfiguration.PASSTEST, null),
              funcFromMap: (data) => data,
              typeRequest: TYPEREQUEST.POST,
              isObject: true);
          // if(i ==1000)
          expect(result.error, null);
        // };



      },
    );

    //CT0002
    test(
      'CT0002 - Validar login de um técnico válido do tipo funcionary',
          () async {
        var result = await _requestManager.requestWithTokenToForm(
            AuthRepository.LOGIN,
            serviceName: AuthRepository.SERVICELOGIN,
            test: true,
            body: body(AwsConfiguration.USERTESTFUNCIONARY,
                AwsConfiguration.PASSTEST, null),
            funcFromMap: (data) => data,
            typeRequest: TYPEREQUEST.POST,
            isObject: true);

        expect(result.error, null);
      },
    );

    //CT0003
    test(
      'CT0003 - Validar técnico login com dados do técnico inválido',
      () async {
        var result = await _requestManager.requestWithTokenToForm(
            AuthRepository.LOGIN,
            serviceName: AuthRepository.SERVICELOGIN,
            test: true,
            body: body(AwsConfiguration.PASSTEST,
                AwsConfiguration.USERTESTHOMEBASED, null),
            funcFromMap: (data) => data,
            typeRequest: TYPEREQUEST.POST,
            isObject: true);

        expect(result.error, LoginTestConstants.ERRORRESPONSEINVALIDO);
      },
    );

    //CT0004
    test(
      'CT0004 - Validar login com dados vazios',
     () async {
        var result = await _requestManager.requestWithTokenToForm(
            AuthRepository.LOGIN,
            serviceName: AuthRepository.SERVICELOGIN,
            test: true,
            body: body("", "", null),
            funcFromMap: (data) => data,
            typeRequest: TYPEREQUEST.POST,
            isObject: true);

        expect(result.error, LoginTestConstants.ERRORRESPONSEINVALIDO);
      },
    );

    //CT0005
    test(
      'CT0005 - Validar login utilizando somente campo nome preenchido',
      () async {
        var result = await _requestManager.requestWithTokenToForm(
            AuthRepository.LOGIN,
            serviceName: AuthRepository.SERVICELOGIN,
            test: true,
            body: body(AwsConfiguration.USERTESTHOMEBASED, "", null),
            funcFromMap: (data) => data,
            typeRequest: TYPEREQUEST.POST,
            isObject: true);

        expect(result.error, LoginTestConstants.ERRORRESPONSEPASS);
      },
    );

    //CT0006
    test(
      'CT0006 - Validar login utilizando somente campo senha preenchido',
      () async {
        var result = await _requestManager.requestWithTokenToForm(
            AuthRepository.LOGIN,
            serviceName: AuthRepository.SERVICELOGIN,
            test: true,
            body: body("", AwsConfiguration.PASSTEST, null),
            funcFromMap: (data) => data,
            typeRequest: TYPEREQUEST.POST,
            isObject: true);

        expect(result.error, LoginTestConstants.ERRORRESPONSEINVALIDO);
      },
    );
    //CT0007
    test(
      'CT0007 - Validar login utilizando dados do cliente',
      () async {
        var result = await _requestManager.requestWithTokenToForm(
            AuthRepository.LOGIN,
            serviceName: AuthRepository.SERVICELOGIN,
            test: true,
            body: body(AwsConfiguration.USERTEST,
                AwsConfiguration.PASSTEST, null),
            funcFromMap: (data) => data,
            typeRequest: TYPEREQUEST.POST,
            isObject: true);

        expect(result.error, LoginTestConstants.ERRORRESPONSEINVALIDO);
      },
    );
  });
}

