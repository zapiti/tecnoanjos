import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/modules/general/login/repositories/auth_repository.dart';
import 'package:tecnoanjosclient/app/notification/onsignal_notification.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'package:tecnoanjosclient/app/utils/attendance/attendance_utils.dart';


class RouterLoginGuard implements RouteGuard {
  @override
  bool canActivate(String url) {
    return true;
  }
  @override
  // TODO: implement executors
  List<GuardExecutor> get executors => [HomeExecutor()];
}

class HomeExecutor extends GuardExecutor {
  @override
  onGuarded(String path, {bool isActive}) {
    final _blocApp = Modular.get<AuthRepository>();
    _blocApp.getToken().then((token) {
      if (token != null) {
        var value = CurrentUser.fromMap(Jwt.parseJwt(token));
        if (value == null) {
          OnsignalNotification().handleRemoveExternalUserId();
          if (path != ConstantsRoutes.LOGIN) {
            Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
          }
        } else {
          if (Modular.to.path == ConstantsRoutes.LOGIN ||
              Modular.to.path == Modular.initialRoute) {
            AttendanceUtils.goToHome(null);
          }
        }
      }});


    // Suppose login.

  }
}
