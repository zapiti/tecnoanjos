import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_page.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/core/start_called_repository.dart';

import 'home_bloc.dart';
import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => DrawerPage()),
        Bind((i) => HomeBloc()),
        Bind((i) => DrawerBloc()),
        Bind((i) => StartCalledRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
