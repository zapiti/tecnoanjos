import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_page.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/receiver_called_page.dart';

import 'package:tecnoanjostec/app/modules/general/home/widget/mobile/schedules_called_page.dart';
import 'package:tecnoanjostec/app/modules/notification/notification_bloc.dart';
import 'package:tecnoanjostec/app/modules/notification/notification_page.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Widget homeMobilePageWidget(
    BuildContext context, ProfileBloc profileBloc, AppBloc appBloc) {
  var _attendanceBloc = Modular.get<AttendanceBloc>();
  var _blocStartCalled = Modular.get<StartCalledBloc>();
  var notificationBloc = Modular.get<NotificationBloc>();

  return StatefulWrapper(
      onInit: () {
        appBloc.enablePopUp.sink.add(true);
        notificationBloc.getListNotification();
        if (!appBloc.isFirstLogin.stream.value) {
          if (!ModalRoute.of(context)
              .settings
              .name
              .contains(ConstantsRoutes.ONBOARD)) {}
        } else {

          Future.delayed(Duration(seconds: 15), () {
            _blocStartCalled.showCalled.sink.add(false);
          });
          _blocStartCalled.isLoadAttendance.sink.add(false);

          profileBloc.getStatus(context);

        }
      },
      onDidUpdate: () {

      },
      child: DefaultTabController(
          length: 2,
          child: builderComponent<bool>(
              stream: profileBloc.isOnline.stream,
              initCallData: () => {_attendanceBloc.getListSchedule()},
              buildBodyFunc: (context, response) => Scaffold(
                  appBar: AppBar(
                    title: Text(response ? "Online" : "Offline",
                        style: AppThemeUtils.normalBoldSize(
                            color: AppThemeUtils.colorPrimary,fontSize: 22)),centerTitle: true,
                    bottom: TabBar(
                      labelColor: AppThemeUtils.colorPrimary,
                      tabs: [
                        Tab(
                          text: "Meus agendamentos",
                        ),
                        Tab(
                          text: "Chamados pendentes",
                        ),
                      ],
                    ),
                    actions: [
                      Builder(
                          builder: (context) => Switch(
                              value: response ?? false,
                              activeColor: AppThemeUtils.colorPrimary,
                              onChanged: (value) {
                                profileBloc.updateStatus(null, context, value);
                              })),
                      Builder(builder: (contextNew) {
                        return IconButton(
                          icon:  StreamBuilder<String>(
                            stream: appBloc.notificationsCount,
                            builder: (context, snapshot) => Stack(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(snapshot.data == null ? Icons.notifications:Icons.notifications_active,
                                      color: AppThemeUtils.colorPrimary,size: snapshot.data == null ? 24 : 30,)),
                                snapshot.data == null ? Align( ):      Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                      size: 16,
                                    )),    Align(
                                    alignment: Alignment.center,
                                    child:Container(
                                        width: 11,
                                        child: Center(child:   AutoSizeText(  snapshot.data?? "",maxLines: 1,maxFontSize: 12,minFontSize: 2,)))),
                              ],
                            ),
                          ),
                          color: AppThemeUtils.colorPrimary,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()),
                            );
                          },
                        );
                      })
                    ],
                  ),
                  drawer: Modular.get<DrawerPage>(),
                  body: TabBarView(children: [
                    Stack(children: [
                      SchedulesCalledPage(_attendanceBloc),

                    ]),
                    ReceiverCalledPage()
                  ])))));
}
