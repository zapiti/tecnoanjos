import 'package:tecnoanjostec/app/modules/general/information/repository/information_repository.dart';

import 'information_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'information_page.dart';

class InformationModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => InformationBloc()),
        Bind((i) => InformationRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => InformationPage()),
      ];

  static Inject get to => Inject<InformationModule>.of();
}
