import 'package:flutter/scheduler.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app_bloc.dart';

class RouterPermissionGuard implements RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    // TODO: implement canActivate
    final _blocApp = Modular.get<AppBloc>();
    _blocApp.getCurrentUserFutureValue().stream.listen((value) {
      if (value == null) {
        print("entro Aqui");
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
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
//   List<GuardExecutor> get executors => [LoginExecutor()];
// }
//
// class LoginExecutor extends GuardExecutor {
//   @override
//   void onGuarded(String path, {bool isActive}) {
//     final _blocApp = Modular.get<AppBloc>();
//
//     final value =  _blocApp.getCurrentUserFutureValue().stream.value;
//
//       if (value == null) {
//         Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
//       } else {
//         //  PermissionUtils.initialRedirect();
//       }
//
//   }
// }
}
