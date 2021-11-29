import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_page.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/core/registre_user_repository.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';

class ProfileModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => DrawerBloc()),
    Bind((i) => RegistreBloc()),
    Bind((i) => RegistreUserRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => ProfilePage()),
      ];

  static Inject get to => Inject<ProfileModule>.of();
}
