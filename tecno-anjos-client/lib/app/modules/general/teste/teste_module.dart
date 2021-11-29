import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/teste/repository/teste_repository.dart';

import 'teste_bloc.dart';
import 'teste_page.dart';

class TesteModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => TesteBloc()),
        Bind((i) => TesteRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => TestePage()),
      ];

  static Inject get to => Inject<TesteModule>.of();
}
