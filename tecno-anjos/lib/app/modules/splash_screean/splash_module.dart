
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/splash_screean/splash_page.dart';


class SplashScreeanModule extends ChildModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => SplashPage()),
      ];

  static Inject get to => Inject<SplashScreeanModule>.of();
}
