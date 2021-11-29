import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/page/hours_page.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/login/bloc/login_bloc.dart';


import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'calling_bloc.dart';
import 'model/calling.dart';

class CallingPage extends StatefulWidget {
  final Calling calling;

  CallingPage(this.calling);

  @override
  _CallingPageState createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  var index = 0;
  var profileBloc = Modular.get<ProfileBloc>();
  var loginBloc = Modular.get<LoginBloc>();
  final appBloc = Modular.get<AppBloc>();
  var callingBloc = Modular.get<CallingBloc>();
  var startCalledBloc = Modular.get<StartCalledBloc>();

  @override
  void initState() {
    super.initState();

    if (widget.calling != null) {
      callingBloc.myCalling.sink.add(widget.calling);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
    new GlobalKey<ScaffoldState>();
    return StreamBuilder(
        stream: appBloc.secondOnboardSubject,
        initialData: false,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: appBloc.thirdOnboardSubject,
              initialData: false,
              builder: (context, snapshot2) {
                var hideView = snapshot.data || snapshot2.data;
                return Scaffold(
                    key: _scaffoldKey,
                    appBar: hideView
                        ? null
                        : AppBar(
                      title: Text(
                        "ATENDIMENTO",
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.whiteColor),
                      ),
                      centerTitle: true,
                      backgroundColor: AppThemeUtils.colorPrimary,
                      automaticallyImplyLeading: false,
                      elevation: 0,

                      iconTheme: IconThemeData(
                          color: AppThemeUtils.whiteColor),
                    ),
                    body:HoursPage());
              });
        });
  }
}

