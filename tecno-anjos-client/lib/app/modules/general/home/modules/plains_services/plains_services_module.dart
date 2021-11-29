
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/plains_services/plains_services_page.dart';


class PlainsServicesModule extends ChildModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => PlainsServicesPage()),
      ];

  static Inject get to => Inject<PlainsServicesModule>.of();
}
