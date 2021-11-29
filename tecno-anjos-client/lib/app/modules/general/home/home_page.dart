import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/core/websocket/my_web_socket.dart';

import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/accept_attendance_logic.dart';
import 'package:tecnoanjosclient/app/modules/general/home/widget/current/current_page.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjosclient/app/utils/alert/alert_utils.dart';

import 'modules/attendance/my_current_attendance_bloc.dart';
import 'modules/first_login/first_login.dart';
import 'modules/myaddress/my_address_bloc.dart';
import 'modules/profile/profile_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var drawerBloc = Modular.get<DrawerBloc>();
  final appBloc = Modular.get<AppBloc>();

  var profileBloc = Modular.get<ProfileBloc>();
  var myAddressBloc = Modular.get<MyAddressBloc>();
  var _blocStartCalled = Modular.get<StartCalledBloc>();
  var showBottom = false;
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyWebSocket.getMyWebSocketClock();
    AlertUtils.playCalledOnCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (!showBottom) {
            return true;
          } else {
            setState(() {
              showBottom = !showBottom;
            });
            return false;
          }
        },
        child: StreamBuilder(
            stream: appBloc.firstOnboardSubject,
            initialData: false,
            builder: (context, snapshot) => snapshot.data
                ? FirstOnboard()
                : DefaultPageWidget(
                    childMobile: mainViewClient(),
                    //homeMobilePageWidget(drawerBloc, appBloc),
                    childWeb:
                        mainViewClient() //homeWebPageWidget(drawerBloc, appBloc),
                    )));
  }

  StatefulWrapper mainViewClient() {
    return StatefulWrapper(
        onInit: () {
          // profileBloc.verifyNeedCpf(context,(va){});
          _blocStartCalled.isLoadAttendance.sink.add(false);

          profileBloc.getUserImage();
          profileBloc.getUserInfo();
          myAddressBloc.getListAddressForm();
        },
        onDidUpdate: () {},
        child: Stack(
          children: [
            showBottom ? CurrentPage() : AcceptAttendanceLogic(),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // lineViewWidget(),
                    // Container(
                    //     width:
                    //         MediaQuery.of(context).size.width,
                    //     color: AppThemeUtils.whiteColor,
                    //     child: InkWell(
                    //         onTap: () {
                    //           setState(() {
                    //             showBottom = !showBottom;
                    //           });
                    //         },
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //                 margin:
                    //                     EdgeInsets.all(10.0),
                    //                 child: Container(
                    //                     margin: EdgeInsets.all(
                    //                         10.0),
                    //                     child: Icon(
                    //                       MaterialCommunityIcons
                    //                           .calendar,
                    //                       color: AppThemeUtils
                    //                           .whiteColor,
                    //                     )),
                    //                 decoration: BoxDecoration(
                    //                     color: AppThemeUtils
                    //                         .colorPrimary,
                    //                     shape:
                    //                         BoxShape.circle)),
                    //             Text(showBottom
                    //                 ? StringFile.chamarTecnoAnjo
                    //                 : StringFile
                    //                     .meusAgendamentos),
                    //             SizedBox(
                    //               height: 15,
                    //             )
                    //           ],
                    //         )))
                  ],
                ))
            // bottomNavigationCurrentAttendance(context,
            //     constainsInit: false,
            //     nameAction: , action: () {
            //   setState(() {
            //     showBottom = !showBottom;
            //   });
            // }),
          ],
        ));
  }
}
