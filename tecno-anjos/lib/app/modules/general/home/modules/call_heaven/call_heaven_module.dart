import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/call_heaven_page.dart';

class CallHeavenModule extends ChildModule {
  @override
  List<Bind> get binds => [


      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => CallHeavenPage(args.data)),
      ];

  static Inject get to => Inject<CallHeavenModule>.of();
}
