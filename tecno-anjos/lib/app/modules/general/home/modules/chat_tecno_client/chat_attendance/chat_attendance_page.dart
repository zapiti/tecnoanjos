import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import 'chat_attendance_bloc.dart';
import 'widget/chat_view.dart';

class ChatAttendancePage extends StatefulWidget {
  final Attendance attendance;

  ChatAttendancePage(this.attendance);

  @override
  _ChatAttendancePageState createState() => _ChatAttendancePageState();
}

class _ChatAttendancePageState extends State<ChatAttendancePage> {
  var chatAttendanceBloc = Modular.get<ChatAttendanceBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmplitudeUtil.createEvent(
        AmplitudeUtil.eventoEntrouNaTela("CHAT-TECNICO-CLIENTE".toUpperCase()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        chatAttendanceBloc.clearChat(widget.attendance);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: AppThemeUtils.whiteColor,
              centerTitle: false,
              iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
              title: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          top: 0, left: 0, right: 15, bottom: 0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[200],
                            child: widget.attendance.userClient?.pathImage ==
                                    null
                                ? SizedBox()
                                : Image.network(
                                    (widget.attendance.userClient.pathImage),
                                    fit: BoxFit.fill,
                                  ),
                          ))),
                  Expanded(
                      child: Text(
                    (widget.attendance?.userClient?.name) ?? "CHAT",
                    style: AppThemeUtils.normalSize(
                        color: AppThemeUtils.colorPrimaryDark, fontSize: 18),
                    textAlign: TextAlign.start,
                  ))
                ],
              )),
          body: StatefulWrapper(
              onInit: () {
                chatAttendanceBloc.getChatschedule(context, widget.attendance);
              },
              child: ChatClienteView(widget.attendance))),
    );
  }
}
