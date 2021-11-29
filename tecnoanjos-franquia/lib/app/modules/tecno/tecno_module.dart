import 'package:tecnoanjos_franquia/app/modules/tecno/page/tecno_registration_page.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';

import 'tecno_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'tecno_page.dart';

class TecnoModule extends Module {
  @override
  List<Bind> get binds => [
    Bind((i) => TecnoBloc())
      ];

  @override
  List<ModularRoute> get routes => [
       ChildRoute(Modular.initialRoute, child: (_, args) => TecnoPage()),
    ChildRoute(ConstantsRoutes.NOVO_TECNICO,
        child: (_, args) => TecnoRegistrationPage(args.data)),
      ];

}
