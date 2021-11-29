import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/core/websocket/my_web_socket.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
import 'modules/profile/profile_bloc.dart';
import 'package:tecnoanjostec/app/utils/alert/alert_utils.dart';

import 'widget/mobile/home_mobile_page_widget.dart';
import 'widget/web/home_web_page_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var drawerBloc = Modular.get<DrawerBloc>();
  var appBloc = Modular.get<AppBloc>();
  var profileBloc = Modular.get<ProfileBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AlertUtils.playCalledOnCurrent();
    AlertUtils.playCalledOnAttendance();
    MyWebSocket.getMyWebSocketClock();
    profileBloc.getUserInfo(isReload: false).then((value) async {
      if (value.isFirstLogin ?? false) {
        var isFirst = await appBloc.getIsFirstLogin();
        if(isFirst){

        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
   // _blocStartCalled.openSocket(context);
    profileBloc.getUserData(context);
    return Scaffold(
        body: DefaultPageWidget(
      childMobile: homeMobilePageWidget(context, profileBloc, appBloc),
      enableBar: false,
      childWeb: homeWebPageWidget(drawerBloc, appBloc),
    ));
  }
}
