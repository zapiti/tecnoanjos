import 'package:flutter_modular/flutter_modular.dart';

import 'update_my_app_page.dart';

class UpdateMyAppModule extends ChildModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => UpdateMyAppPage()),
      ];

  static Inject get to => Inject<UpdateMyAppModule>.of();
}
