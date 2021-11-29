import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/onboarding/onboarding_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/onboarding/widget/first/first_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/onboarding/widget/five/five_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/login/bloc/login_bloc.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';

import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class OnboardPage extends StatefulWidget {
  final String title;

  const OnboardPage({Key key, this.title = "Onboarding"}) : super(key: key);

  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  var index = 0;
  var appBloc = Modular.get<AppBloc>();
  var loginBloc = Modular.get<LoginBloc>();
  var onboardBloc = Modular.get<OnboardingBloc>();
  var profileBloc = Modular.get<ProfileBloc>();

  bool userImage = false;
  File image;
  var keyOnboard = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProfile = profileBloc?.userProfile?.stream?.value;
    if (userProfile != null) {
      var user = userProfile.content as Profile;
      user.inOnboard = true;
      userProfile.content = user;
      profileBloc?.userProfile?.sink?.add(userProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (index == 0) {
            showGenericDialog(
                context: context,
                title: StringFile.atencao,
                description: StringFile.desejaSair,
                iconData: Icons.error_outline,
                positiveCallback: () {},
                positiveText: StringFile.continuar,
                negativeText: StringFile.sair,
                negativeCallback: () {
                  Modular.get<LoginBloc>().getLogout();
                });

            return false;
          } else {
            changeAction(isNegative: true);
            return false;
          }
        },
        child: Scaffold(
            key: keyOnboard,
            appBar: AppBar(
              title: Text(""),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
              // actions: [
              //
              //   Builder(
              //       builder: (context) => ElevatedButton(
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //           color: AppThemeUtils.colorError,
              //           child: Text(
              //             "Fechar",
              //             style: AppThemeUtils.normalSize(
              //                 color: AppThemeUtils.whiteColor),
              //           ),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: new BorderRadius.circular(10.0),
              //               side:
              //               BorderSide(color: AppThemeUtils.colorError)))),
              //
              // ],
            ),
            body: StreamBuilder<bool>(
                stream: onboardBloc.hideButton.stream,
                builder: (context, snapshot) {
                  return Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Expanded(child: changePageActual()),
                          snapshot.data ?? false
                              ? SizedBox()
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  child: StreamBuilder<bool>(
                                      stream: onboardBloc.enableButton.stream,
                                      builder: (context, snapshot) {
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: snapshot.data ?? true
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey[300],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8)))),
                                            onPressed: snapshot.data ?? true
                                                ? changeAction
                                                : () {},
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                            child: Text(
                                              changeTextLabel(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ));
                                      })),
                          snapshot.data ?? false
                              ? SizedBox()
                              : bottomChangeView(context),
                          SizedBox(
                            height: 25,
                          )
                        ],
                      ));
                })));
  }

  Widget bottomChangeView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index >= 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]),
        ),
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index >= 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]),
        ),
        // Container(
        //   width: 12,
        //   height: 12,
        //   margin: EdgeInsets.all(3),
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: index >= 2
        //           ? Theme.of(context).primaryColor
        //           : Colors.grey[300]),
        // ),
        // Container(
        //   width: 12,
        //   height: 12,
        //   margin: EdgeInsets.all(3),
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: index >= 3
        //           ? Theme.of(context).primaryColor
        //           : Colors.grey[300]),
        // ),
        // Container(
        //   width: 12,
        //   height: 12,
        //   margin: EdgeInsets.all(3),
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: index >= 3
        //           ? Theme.of(context).primaryColor
        //           : Colors.grey[300]),
        // )
      ],
    );
  }

  String changeTextLabel() {
    if (index != 1) {
      if (index == 0) {
        return StringFile.comecar;
      } else {
        return StringFile.avancar;
      }
    } else {
      return StringFile.concluir;
    }
  }

  changeAction({isNegative = false}) {
    onboardBloc.enableButton.sink.add(true);

    if (index != 1) {
      onboardBloc.hideButton.sink.add(false);

      setState(() {
        if (isNegative) {
          index -= 1;
        } else {
          index += 1;
        }
      });
    } else {
      if (!isNegative) {
        _createConfig();
      } else {
        setState(() {
          index -= 1;
        });
      }
    }
    if (index == 0) {
      onboardBloc.enableButton.sink.add(true);
    }
    if (index == 1 && !userImage) {
      onboardBloc.enableButton.sink.add(false);
    }

    if (index == 0) {
      onboardBloc.enableButton.sink.add(true);
    }
  }

  Future<void> _createConfig() {
    return profileBloc.createConfig(context, [], () {
      appBloc.isFirstLogin.sink.add(false);
      profileBloc.userProfile.sink.add(null);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
      });
    });
  }

  Widget changePageActual() {
    switch (index) {
      case 0:
        return FirstPage();

      default:
        return FivePage(
            image: image,
            changeButton: (pairsButton) {
              userImage = pairsButton.first;
              image = pairsButton.second;

              onboardBloc.enableButton.sink.add(pairsButton.first);
            });
    }
  }
}
