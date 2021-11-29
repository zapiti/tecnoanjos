import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/help_center_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/help_center_page.dart';

import 'core/help_repository.dart';

class HelpCenterModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => HelpCenterBloc()),
        Bind((i) => HelpCenterRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => HelpCenterPage()),
      ];

  static Inject get to => Inject<HelpCenterModule>.of();
}
