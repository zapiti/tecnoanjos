import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/modules/general/login/repositories/auth_repository.dart';
import 'package:tecnoanjosclient/app/notification/onsignal_notification.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

class RouterPermissionGuard implements RouteGuard {
  @override
  bool canActivate(String url) {
    return true;
  }

  @override
  // TODO: implement executors
  List<GuardExecutor> get executors => [LoginExecutor()];
}

class LoginExecutor extends GuardExecutor {
  @override
  onGuarded(String path, {bool isActive}) {
    final _blocApp = Modular.get<AuthRepository>();
    _blocApp.getToken().then((token) {
      if (token != null) {
        var value = CurrentUser.fromMap(Jwt.parseJwt(token));


        if (value == null) {
          OnsignalNotification().handleRemoveExternalUserId();
          Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
        } else {
          //  PermissionUtils.initialRedirect();
        }
      }});


  }
}
