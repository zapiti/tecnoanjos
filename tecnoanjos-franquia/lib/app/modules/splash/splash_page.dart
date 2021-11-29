import 'package:tecnoanjos_franquia/app/components/gradient_container.dart';

import 'package:tecnoanjos_franquia/app/modules/login/repositories/auth_repository.dart';
import 'package:tecnoanjos_franquia/app/utils/image/image_logo_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app_bloc.dart';

import '../../routes/constants_routes.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      redirectToPage(context);
    });
  }

  @override
  void didUpdateWidget(SplashPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      redirectToPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: gradientContainer(
          child: Center(
        child: getLogoIcon(),
      )),
    );
  }
}

void redirectToPage(BuildContext context) {
  final auth = Modular.get<AuthRepository>();
  final appBloc = Modular.get<AppBloc>();
  Future.delayed(Duration(seconds: kIsWeb ? 0 : 1), () {
    if (!kIsWeb) {
//      PackageInfo.fromPlatform().then((packageInfo) {
//        String versionName = packageInfo.version;
//        // String versionCode = packageInfo.buildNumber;
//       debugPrint('V-Name $versionName');
      _redirectToAuth(auth, appBloc);
      //      if (versionName.contains("dev")) {
//          showChangeUrlDialog(context, AwsConfiguration.base_url,
//              positiveCallback: (value) {
//            // Navigator.pop(  _scaffoldKey.currentContext);
//            if (value.contains("http://") || value.contains("https:/")) {
//              _redirectToAuth(auth, appBloc);
//            } else {
//              Utils.showSnackBar(
//                  "Adicione a porta http ou https para continyar",
//                  _scaffoldKey);
//            }
//          });
//        } else {
//          _redirectToAuth(auth, appBloc);
//        }
      //   });
    } else {
      _redirectToAuth(auth, appBloc);
    }
  });
}

void _redirectToAuth(AuthRepository auth, AppBloc appBloc) {
  var user = appBloc.getCurrentUserFutureValue().stream.value;
  if (user != null) {
    Modular.to.pushReplacementNamed(ConstantsRoutes.HOME);
  } else {
    Modular.to.pushReplacementNamed(ConstantsRoutes.LOGIN);
  }
}
