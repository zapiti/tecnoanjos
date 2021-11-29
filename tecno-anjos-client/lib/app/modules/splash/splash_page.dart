import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/modules/general/login/repositories/auth_repository.dart';

import 'package:tecnoanjosclient/app/notification/onsignal_notification.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final appBloc = Modular.get<AppBloc>();
  // GifController controller3;


  @override
  void initState() {

    super.initState();
    // controller3 = GifController(vsync: this,
    //     duration: Duration(seconds: 1),
    //     reverseDuration: Duration(seconds: 0));
    // controller3.animateTo(80);
    //
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appBloc.setTheme();

      Future.delayed(Duration(seconds: 3)).then((value) {
        //     //   setState(() {
        //     //     controller3.value = 0;
        //     //     controller3.reset();
        //     //     controller3.addStatusListener((status){
        //     //       controller3.removeListener(() { });
        //     //       if(status == AnimationStatus.completed){
        //
        //     // controller3.repeat(min:0,max:80,period:Duration(seconds:3));
        //     controller3.reset();
        //     controller3.value = 0;
        //     //     controller3.reset();
        //     controller3.animateTo(80, duration: Duration(seconds: 3));
        //     controller3.addStatusListener((status2) {
        //       if (status2 == AnimationStatus.completed) {
        //         controller3.dispose();


          redirectToPage(context);

        //       }
        //       //
        //       //   });
        //       //
        //       // }
        //
        //       //   });
        //       //   // controller3.repeat(min:0,max:80,period:Duration(seconds:3));
        //       //
      });
    });
    //
    //   // loop from 0 frame to 29 frame
    //   //  controller3.repeat(min:0,max:80,period:Duration(milliseconds:5000));
    //
    //   // jumpTo thrid frame(index from 0)
    //   // controller3.value = 0;
    //
    //   // from current frame to 26 frame
    //   //   controller3.animateTo(80);
    // });
    // controller3.forward();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(ImagePath.imageLogoGif), context);
    precacheImage(AssetImage(ImagePath.loadElementEmpty), context);
    precacheImage(AssetImage(ImagePath.loadElement), context);
    precacheImage(AssetImage(ImagePath.imageLogo), context);


    return Scaffold(
        backgroundColor: AppThemeUtils.colorPrimary,
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Slider(
            //   onChanged: (v) {
            //     controller3.value = v;
            //     setState(() {
            //
            //     });
            //   },
            //   max: 53,
            //   min: 0,
            //   value: controller3.value,
            // ),
            Image.asset(ImagePath.imageLogoGif),
            // ),
          ],
        ));
  }
}

void redirectToPage(BuildContext context) {
  Future.delayed(Duration(seconds:  1), () {
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

void _redirectToAuth(BuildContext context, AuthRepository auth,
    AppBloc appBloc) {
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
