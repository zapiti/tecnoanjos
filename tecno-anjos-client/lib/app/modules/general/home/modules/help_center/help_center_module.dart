import 'package:flutter_modular/flutter_modular.dart';


import 'help_center_bloc.dart';
import 'help_center_page.dart';

class HelpCenterModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => HelpCenterBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => HelpCenterPage()),
      ];

  static Inject get to => Inject<HelpCenterModule>.of();
}
