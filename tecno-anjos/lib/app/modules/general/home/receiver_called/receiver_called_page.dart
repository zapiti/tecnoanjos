import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjostec/app/components/state_view/empty_view_mobile.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/widget/attendance_item_list_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/receiver_called_bloc.dart';


import 'package:tecnoanjostec/app/utils/string/string_file.dart';

import '../../../../app_bloc.dart';


class ReceiverCalledPage extends StatelessWidget {
  final _receiverCalledBloc = Modular.get<ReceiverCalledBloc>();
  final currentBloc =  GetIt.I.get<MyCurrentAttendanceBloc>();
  final profileBloc = Modular.get<ProfileBloc>();
  final appBloc = Modular.get<AppBloc>();
  @override
  Widget build(BuildContext context) {

    SchedulerBinding.instance.addPostFrameCallback((_) {
      appBloc.currentContext.sink.add(context);
    });
    return  WillPopScope(
        onWillPop: () async {
          _receiverCalledBloc.inCall.sink.add(false);
          return true;
        },
        child: Scaffold(
            body: StreamBuilder<bool>(
          stream: profileBloc.isOnline.stream,
          initialData: false,
          builder: (context, snapashot) => !snapashot.data
              ? emptyViewMobile(context,
                  emptyMessage: StringFile.ficarOnlineDescription,tryAgainText:StringFile.ficarOnline,
                  tentarNovamente: () {
                  profileBloc.updateStatus(null, context, true);
                }
                )
              : builderComponent<ResponsePaginated>(
                  stream: _receiverCalledBloc.listReceivers.stream,
                  emptyMessage: StringFile.semAtendimentoAgendado,
                  initCallData: () {
                    _receiverCalledBloc.getListReceivers();
                  },
                  // tryAgain: () {
                  //   _receiverCalledBloc.getListReceivers(context);
                  // },
                  buildBodyFunc: (context2, data) =>
                      builderInfinityListViewComponent(data,
                          callMoreElements: (page) => {},
                          buildBody: (content) => attendanceItemListWidget(
                              context, content,content.status,currentBloc,isDependet: true)),
                ),
        )));
  }
}
