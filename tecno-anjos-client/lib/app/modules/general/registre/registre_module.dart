import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/widget/third/change_name_registre_page.dart';

import 'core/registre_user_repository.dart';


class RegistreModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => RegistreBloc()),
        Bind((i) => RegistreUserRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => ChangeNameRegistrePage()),
      ];

  static Inject get to => Inject<RegistreModule>.of();
}
