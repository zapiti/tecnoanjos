

import 'package:flutter_modular/flutter_modular.dart';

import 'my_address_page.dart';

class MyAddressModule extends ChildModule {
  @override
  List<Bind> get binds => [


      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => MyAddressPage()),


      ];

  static Inject get to => Inject<MyAddressModule>.of();
}
