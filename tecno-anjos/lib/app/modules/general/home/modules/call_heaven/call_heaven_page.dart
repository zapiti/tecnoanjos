import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/call_heaven_bloc.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../../../app_bloc.dart';
import 'chat/chat_perspective_heaven.dart';

class CallHeavenPage extends StatelessWidget {
  final appBloc = Modular.get<AppBloc>();
  final socketService = Modular.get<CallHeavenBloc>();
  final Attendance attendance;

  CallHeavenPage(this.attendance);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          socketService.createSocketConnection(attendance);
        },
        child: DefaultPageWidget(
            enableBar: false,
            childMobile: WillPopScope(
                onWillPop: () async {
                  socketService.dispose();
                  return true;
                },
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(StringFile.chat,
                          style: AppThemeUtils.normalSize(
                              color: AppThemeUtils.colorPrimary)),
                      centerTitle: true,
                    ),
                    body: builderComponent<ResponsePaginated>(
                      emptyMessage: StringFile.erroCallSky,
                      stream: socketService.roomSubject,
                      buildBodyFunc: (context, snapshot) {
                        return ChatPerspectiveHeaven(snapshot.content);
                      },
                    ))),
            childWeb: WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(StringFile.chat,
                          style: AppThemeUtils.normalSize(
                              color: AppThemeUtils.colorPrimary)),
                      centerTitle: true,
                    ),
                    body: builderComponent<ResponsePaginated>(
                      emptyMessage: StringFile.erroCallSky,
                      stream: socketService.roomSubject,
                      buildBodyFunc: (context, snapshot) {
                        return ChatPerspectiveHeaven(snapshot.content);
                      },
                    )))));
  }
}
