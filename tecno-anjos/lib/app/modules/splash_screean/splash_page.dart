import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:tecnoanjostec/app/core/websocket/my_web_socket.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/modules/general/login/repositories/auth_repository.dart';
import 'package:tecnoanjostec/app/notification/onsignal_notification.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import '../../app_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  var appBloc = Modular.get<AppBloc>();

  // GifController controller3;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appBloc.setTheme();

      Future.delayed(Duration(seconds: 3)).then((value) {

          redirectToPage(context);


      });
    });
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(ImagePath.imageLogoGif), context);
    precacheImage(AssetImage(ImagePath.loadElement), context);
    precacheImage(AssetImage(ImagePath.imageLogo), context);

    return Scaffold(
        backgroundColor: AppThemeUtils.whiteColor,
        body: Material(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(ImagePath.imageLogoGif),
          ],
        )));
  }
}

void redirectToPage(BuildContext context) {
  Future.delayed(Duration(seconds: 1), () {
    if (!kIsWeb) {
      final auth = Modular.get<AuthRepository>();
      final appBloc = Modular.get<AppBloc>();
      _redirectToAuth(context, auth, appBloc);
    } else {
      final auth = Modular.get<AuthRepository>();
      final appBloc = Modular.get<AppBloc>();
      _redirectToAuth(context, auth, appBloc);
    }
  });
}

void _redirectToAuth(
    BuildContext context, AuthRepository auth, AppBloc appBloc) {
  auth.getToken().then((token) {
    if (token != null) {
      try {
        var currentUser = CurrentUser.fromMap(Jwt.parseJwt(token));
        appBloc.setCurrent(currentUser);
        if (!kIsWeb) {
          OnsignalNotification().initPlatformState();
          OnsignalNotification().handleSetExternalUserId();
        }
        Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
      } catch (ex) {
        Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
      }
    } else {
      Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
    }
  });
}
