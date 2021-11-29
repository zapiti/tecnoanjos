import 'package:another_flushbar/flushbar.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/mobile/title_descritption_mobile_widget.dart';

import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/login/bloc/login_bloc.dart';

import 'package:tecnoanjostec/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../../../../../../main.dart';


class SettingsMobilePageWidget extends StatefulWidget {
  @override
  _SettingsMobilePageWidgetState createState() =>
      _SettingsMobilePageWidgetState();
}

class _SettingsMobilePageWidgetState extends State<SettingsMobilePageWidget> {
  AppBloc appBloc = Modular.get<AppBloc>();
  DrawerBloc drawerBloc = Modular.get<DrawerBloc>();
  LoginBloc authbloc = Modular.get<LoginBloc>();

  var count = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        titleDescriptionBigMobileWidget(context, action: () {
          setState(() {
            count++;
          });
          if (count > 5) {
            Flushbar(
              flushbarStyle: FlushbarStyle.GROUNDED,
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: AppThemeUtils.colorPrimary,
              message:
                  "${Flavor.I.getString(firebaseKey)}-${Flavor.I.getString(actualVersion)}",
              icon: Icon(
                Icons.pie_chart_rounded,
                size: 28.0,
                color: AppThemeUtils.whiteColor,
              ),
              duration: Duration(seconds: 2),
            )..show(context);
          }
        },
            title: StringFile.tema,
            iconData: MaterialCommunityIcons.brush,
            description: appBloc.darkThemeIsEnabled
                ? StringFile.escuro
                : StringFile.claro,
            customIcon: Switch(
                value: appBloc.darkThemeIsEnabled ?? false,
                activeColor: Theme.of(context).backgroundColor,
                onChanged: (value) => appBloc.setTheme(isDarkMode: value))),
        lineViewWidget(),
        titleDescriptionBigMobileWidget(
          context,
          action: () {
            AmplitudeUtil.createEvent(AmplitudeUtil.eventoSaiuDoApp);
            authbloc.getLogout();
          },
          iconData: MaterialCommunityIcons.exit_to_app,
          title: StringFile.sair,
        ),
        lineViewWidget(),
      ]),
    );
  }
}
