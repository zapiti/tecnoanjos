import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/page/detail_avaliation.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/page/make_avaliation_page.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'avaliation_bloc.dart';
import 'avaliation_page.dart';
import 'core/avaliation_repository.dart';

class AvaliationModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AvaliationBloc()),
        Bind((i) => AvaliationRepository()),
        Bind((i) => DrawerBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => AvaliationPage()),
    ModularRouter(ConstantsRoutes.DETAILS_AVALIATION,
            child: (_, args) => DetailAvaliationPage(args.data)),
    ModularRouter(ConstantsRoutes.MAKE_AVALIATION,
        child: (_, args) => MakeAvaliationPage(args.data)),
      ];

  static Inject get to => Inject<AvaliationModule>.of();
}
