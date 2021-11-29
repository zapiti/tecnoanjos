import 'package:tecnoanjos_franquia/app/app_bloc.dart';
import 'package:tecnoanjos_franquia/app/guard/router_permission_guard.dart';
import 'package:tecnoanjos_franquia/app/modules/payment/payment_module.dart';

import 'package:tecnoanjos_franquia/app/modules/search/search_module.dart';

import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/preferences/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_widget.dart';

import 'core/request_core.dart';
import 'guard/router_login_guard.dart';

import 'modules/attendance/attendance_module.dart';
import 'modules/conection/conection_module.dart';
import 'modules/default_page/widget/sidebar_menu..dart';
import 'modules/drawer/drawer_bloc.dart';
import 'modules/drawer/drawer_page.dart';

import 'modules/login/bloc/login_bloc.dart';
import 'modules/login/login_module.dart';

import 'modules/login/repositories/auth_repository.dart';

import 'modules/splash/splash_page.dart';
import 'modules/tecno/page/tecno_registration_page.dart';
import 'modules/tecno/tecno_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => SideBarMenu()),
        Bind((i) => DrawerPage()),
        Bind((i) => AppBloc()),
        Bind((i) => LoginBloc()),
        Bind((i) => LocalDataStore()),
        Bind((i) => RequestCore()),
        Bind((i) => DrawerBloc()),
        Bind((i) => AuthRepository()),
        Bind((i) => Dio())
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute,
            module: LoginModule(),
            guards: [RouterLoginGuard()],
            transition: TransitionType.fadeIn),
        ModuleRoute(ConstantsRoutes.LOSTCONECTION,
            module: ConectionModule(), transition: TransitionType.fadeIn),
        ModuleRoute(ConstantsRoutes.PAGAMENTO,
            module: PaymentModule(),
            guards: [RouterPermissionGuard()],
            transition: TransitionType.fadeIn),
        ModuleRoute(ConstantsRoutes.TECNICOS,
            module: TecnoModule(),
            guards: [RouterPermissionGuard()],
            transition: TransitionType.fadeIn),
        ModuleRoute(ConstantsRoutes.ATTENDANCE,
            module: AttendanceModule(),
            guards: [RouterPermissionGuard()],
            transition: TransitionType.fadeIn),
        ModuleRoute(ConstantsRoutes.SEARCH,
            module: SearchModule(),
            transition: TransitionType.fadeIn,
            guards: [RouterPermissionGuard()]),
        ModuleRoute(ConstantsRoutes.LOGIN,
            module: LoginModule(),
            guards: [RouterLoginGuard()],
            transition: TransitionType.fadeIn),
      ];
}
