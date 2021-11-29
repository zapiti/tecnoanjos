

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app_bloc.dart';
import 'components/load_view_element.dart';
import 'models/custom_theme.dart';

import 'modules/conection/connection_page.dart';

import 'modules/firebase/await_popup/await_popup.dart';
import 'modules/firebase/current_attendance/accept_attendance_logic.dart';
import 'modules/firebase/current_attendance/current_attendance_logic.dart';
import 'modules/update_my_app/update_my_app_page.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void didChangeDependencies() {
    print("==========================didChangeDependencies");

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print("==========================dispose");

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppWidget oldWidget) {
    print("==========================didUpdateWidget");

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = Modular.get<AppBloc>();

    return CupertinoApp(debugShowCheckedModeBanner: false ,
    localizationsDelegates: [
    DefaultMaterialLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
    ],home: StreamBuilder<CustomTheme>(
        initialData: _bloc.getDefaultTheme(),
        stream: _bloc.themeActualStream,
        builder: (context, snapshot) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: snapshot?.data?.themeData,
              home: Center(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 2048),
                      child: Stack(
                        children: [
                          MaterialApp(
                            navigatorKey: Modular.navigatorKey,
                            title: 'Tecnoanjos',
                            theme: snapshot?.data?.themeData,
                            initialRoute: '/',
                            supportedLocales: [const Locale('pt', 'BR')],
                            localizationsDelegates: [
                              GlobalMaterialLocalizations.delegate,
                              GlobalWidgetsLocalizations.delegate
                            ],
                            debugShowCheckedModeBanner: false,
                            onGenerateRoute: Modular.generateRoute,
                          ),
                          AwaitPopup(),
                          AcceptAttendanceLogic(),
                          CurrentAttendanceLogic(),
                          kIsWeb ? SizedBox() : UpdateMyAppPage(),
                          kIsWeb
                              ? SizedBox()
                              : ConnectionPage(),
                          LoadViewElement()
                        ],
                      ))));
        }));
  }
}
