
import 'package:flutter_modular/flutter_modular.dart';

import 'transition_page.dart';

class TransitionModule extends ChildModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => TransitionPage()),
      ];

  static Inject get to => Inject<TransitionModule>.of();
}
