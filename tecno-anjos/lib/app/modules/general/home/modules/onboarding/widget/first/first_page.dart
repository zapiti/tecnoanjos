import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjostec/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/onboarding/onboarding_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';

import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var profileBloc = Modular.get<ProfileBloc>();

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          Modular.get<OnboardingBloc>().enableButton.sink.add(true);
        },
        onDidUpdate: () {
          Modular.get<OnboardingBloc>().enableButton.sink.add(true);
        },
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          imageWithBgWidget(context, ImagePath.imageHands),
          builderComponent<Profile>(
              stream: profileBloc.userInfos.stream,
              enableError: false,
              enableEmpty: false,
              initCallData: () {
                  profileBloc.getUserInfo();
              },
              enableLoad: false,
              buildBodyFunc: (context, response) {
                var profileData = response;

                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "${profileData?.name ?? ""}, ",
                          style: AppThemeUtils.normalSize(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 24),
                          children: <TextSpan>[
                            TextSpan(
                                text: StringFile.sejaBemVindoATecnoanjos,
                                style: AppThemeUtils.normalSize(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                    fontSize: 24)),
                          ],
                        )));
              }),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Text(
                StringFile.firstOnboard,
                textAlign: TextAlign.center,
                style: AppThemeUtils.normalSize(
                    color: Theme.of(context).textTheme.bodyText2.color,
                    fontSize: 18),
              )),
        ])));
  }
}
