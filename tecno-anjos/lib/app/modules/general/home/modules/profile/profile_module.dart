import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/widget/registre/registre_bloc.dart';



class ProfileModule extends ChildModule {
  @override
  List<Bind> get binds => [


        Bind((i) => DrawerBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => ProfilePage()),
      ];

  static Inject get to => Inject<ProfileModule>.of();
}
