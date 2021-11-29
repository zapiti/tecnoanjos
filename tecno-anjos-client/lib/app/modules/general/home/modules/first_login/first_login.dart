import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';




class FirstOnboard extends StatefulWidget {
  @override
  _FirstOnboardState createState() => _FirstOnboardState();
}

class _FirstOnboardState extends State<FirstOnboard> {
  final appBloc = Modular.get<AppBloc>();

  var countEtapa = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: InkWell(
          onTap: () {
            setState(() {
              if (countEtapa == 4) {

                codePreferences.set(key: AppBloc.FIRSTONBOARD, value: false);
                AmplitudeUtil.createEvent(AmplitudeUtil.iniciouOnboard);
                appBloc.firstOnboardSubject.sink.add(false);
              } else {
                countEtapa += 1;
              }
            });
          },
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 1000),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppThemeUtils.colorPrimary,
                child: Image.asset(
                  ImagePath.imageOnboard(countEtapa),fit: BoxFit.fill,

                ),
              ))),
    ));
  }
}

class SecondOnboard extends StatefulWidget {
  @override
  _SecondOnboardState createState() => _SecondOnboardState();
}

class _SecondOnboardState extends State<SecondOnboard> {
  final appBloc = Modular.get<AppBloc>();

  var countEtapa = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: InkWell(
          onTap: () {
            setState(() {
              if (countEtapa == 12) {
                codePreferences.set(key: AppBloc.ONBOADACTIVE, value: false);
                AmplitudeUtil.createEvent(AmplitudeUtil.finalizouOnboard);
                appBloc.secondOnboardSubject.sink.add(false);
              } else {
                countEtapa += 1;
              }
            });
          },
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppThemeUtils.colorPrimaryDark2,
                child: Image.asset(
                  ImagePath.imageOnboard(countEtapa),
                  fit: BoxFit.fill,
                ),
              ))),
    ));
  }
}

class ThirdOnboard extends StatefulWidget {
  @override
  _ThirdOnboardState createState() => _ThirdOnboardState();
}

class _ThirdOnboardState extends State<ThirdOnboard> {
  final appBloc = Modular.get<AppBloc>();

  var countEtapa = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: InkWell(
          onTap: () {
            setState(() {
              if (countEtapa == 12) {
                codePreferences.set(key: AppBloc.ONBOADACTIVE, value: false);
                AmplitudeUtil.createEvent(AmplitudeUtil.finalizouOnboard);
                appBloc.thirdOnboardSubject.sink.add(false);
              } else {
                countEtapa += 1;
              }
            });
          },
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppThemeUtils.colorPrimaryDark2,
                child: Image.asset(
                  ImagePath.imageOnboard(countEtapa),
                  fit: BoxFit.fill,
                ),
              ))),
    ));
  }
}
