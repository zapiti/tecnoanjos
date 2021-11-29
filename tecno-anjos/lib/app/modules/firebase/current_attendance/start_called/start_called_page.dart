import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/widget/init_attendance_builder.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import 'start_called_bloc.dart';

class StartCalledPage extends StatelessWidget {
  final Attendance _attendance;
  final appBloc = Modular.get<AppBloc>();

  StartCalledPage(this._attendance);

  @override
  Widget build(BuildContext context) {
    var startCalledBloc = Modular.get<StartCalledBloc>();

    return DefaultPageWidget(
      childWeb: channelAttendance(context, startCalledBloc, _attendance),
      childMobile: channelAttendance(context, startCalledBloc, _attendance),
      enableBar: false,
    );
  }

  Widget channelAttendance(BuildContext context,
      StartCalledBloc startCalledBloc, Attendance attendance) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(StringFile.atendimentos,
              style:
                  AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary)),
          centerTitle: true,
          actions: attendance.status == ActivityUtils.REMOTAMENTE ||
                  attendance.status == ActivityUtils.PENDENTE ||
                  attendance.status == ActivityUtils.PRESENCIAL ||
                  attendance.status == ActivityUtils.AGUARDO_QR ||
                  _attendance.status == ActivityUtils.NAO_AGUARDO_QR
              ? []
              : [
                  Builder(builder: (contextNew) {
                    return IconButton(
                      icon: StreamBuilder<String>(
                        stream: appBloc.notificationsMSGCount,
                        builder: (context, snapshot) => Stack(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  snapshot.data == null
                                      ? Icons.chat
                                      : Icons.mark_chat_read_outlined,
                                  color: AppThemeUtils.colorPrimary,
                                  size: snapshot.data == null ? 24 : 30,
                                )),
                            snapshot.data == null
                                ? Align()
                                : Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                      size: 16,
                                    )),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                    width: 11,
                                    child: Center(
                                        child: AutoSizeText(
                                      snapshot.data ?? "",
                                      maxLines: 1,
                                      maxFontSize: 12,
                                      minFontSize: 2,
                                    )))),
                          ],
                        ),
                      ),
                      color: AppThemeUtils.colorPrimary,
                      onPressed: () {
                        Modular.get<FirebaseClientTecnoanjo>()
                            .removeMessageView(_attendance);
                        appBloc.notificationsMSGCount.sink.add(null);
                        AttendanceUtils.pushNamed(
                            context, ConstantsRoutes.CHATTECNOCLIENT,
                            arguments: _attendance);
                      },
                    );
                  })
                ],
        ),
        body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: StatefulWrapper(
              onInit: () {},
              onDidUpdate: () {
                startCalledBloc.isLoadAttendance.sink.add(true);
              },
              child: InitAttendanceBuilder.buildBodyAttendance(
                  context, _attendance),
            )));
  }
}
