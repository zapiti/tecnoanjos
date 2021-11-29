import 'package:flutter/scheduler.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app_bloc.dart';

class RouterLoginGuard implements RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    // TODO: implement canActivate
    final _blocApp = Modular.get<AppBloc>();
    _blocApp.getCurrentUserFutureValue().stream.listen((value) {
      if (value != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Modular.to.pushReplacementNamed(ConstantsRoutes.HOME);
        });
      }
    });

    return true;
  }
//   @override
//   bool canActivate(String url) {
//     return true;
//   }
//   @override
//   // TODO: implement executors
//   List<GuardExecutor> get executors => [HomeExecutor()];
// }
//
// class HomeExecutor extends GuardExecutor {
//   @override
//   onGuarded(String path, {bool isActive}) {
//     final _blocApp = Modular.get<AppBloc>();
//     final value =  _blocApp.getCurrentUserFutureValue().stream.value;
//
//       if (value == null) {
//         if (path != ConstantsRoutes.LOGIN) {
//           Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
//         }
//       } else {
//         if(Modular.to.path == ConstantsRoutes.LOGIN || Modular.to.path == Modular.initialRoute) {
//           Modular.to.pushReplacementNamed(ConstantsRoutes.HOME);
//         }
//       }
//
//
//   }
}
