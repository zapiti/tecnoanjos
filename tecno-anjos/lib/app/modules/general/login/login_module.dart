import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/recovery_pass/recovery_pass_module.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';

import 'login_page.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => LoginPage()),
    ModularRouter(ConstantsRoutes.RECOVERYPASS,module:
    RecoveryPassModule()),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
