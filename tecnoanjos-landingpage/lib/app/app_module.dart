import 'package:tecno_anjos_landing/app/modules/landing_page/landing_page_module.dart';
import 'package:tecno_anjos_landing/app/modules/quick_support/quick_support_module.dart';
import 'package:tecno_anjos_landing/app/routes/constants_routes.dart';

import 'app_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:tecno_anjos_landing/app/app_widget.dart';
import 'package:tecno_anjos_landing/app/modules/home/home_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: LandingPageModule()),
    ModularRouter(ConstantsRoutes.LANDING_PAGE, module: LandingPageModule()),
    ModularRouter(ConstantsRoutes.QUICKSUPPORT, module: QuickSupportModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
