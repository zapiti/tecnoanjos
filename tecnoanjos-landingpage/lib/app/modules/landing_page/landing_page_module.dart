
import 'package:tecno_anjos_landing/app/modules/landing_page/page/landing_app.dart';
import 'package:tecno_anjos_landing/app/routes/constants_routes.dart';

import 'core/lading_page_repository.dart';
import 'landing_page_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'landing_page_page.dart';
import 'page/landing_login.dart';
import 'widget/navbar/navigation_drawer.dart';

class LandingPageModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LandingPageBloc()),
    Bind((i) => NavigationDrawer()),

    Bind((i) => LadingPageRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => LandingPagePage(args.data)),
    ModularRouter(ConstantsRoutes.BE_A_CLIENTE, child: (_, args) => LandingApp()),

    ModularRouter(ConstantsRoutes.LOGIN_LANDING, child: (_, args) => LandingLogin()),
      ];

  static Inject get to => Inject<LandingPageModule>.of();
}
