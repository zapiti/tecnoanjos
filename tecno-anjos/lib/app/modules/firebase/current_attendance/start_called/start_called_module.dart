import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_page.dart';


class StartCalledModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute,
            child: (_, args) => StartCalledPage(args.data)),
      ];

  static Inject get to => Inject<StartCalledModule>.of();
}
