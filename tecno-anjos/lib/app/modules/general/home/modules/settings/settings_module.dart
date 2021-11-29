import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/settings/settings_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/settings/settings_page.dart';

class SettingsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => SettingsBloc()),
        Bind((i) => DrawerBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => SettingsPage()),
      ];

  static Inject get to => Inject<SettingsModule>.of();
}
