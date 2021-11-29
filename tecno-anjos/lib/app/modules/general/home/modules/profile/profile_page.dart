import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';
import '../../../../../app_bloc.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/profile/widget/mobile/profile_mobile_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/widget/web/profile_web_page_widget.dart';


class ProfilePage extends StatelessWidget {
  final userBloc = Modular.get<ProfileBloc>();
  final appBloc = Modular.get<AppBloc>();
  @override
  Widget build(BuildContext context) {

    return DefaultPageWidget(
      childMobile: profileMobilePageWidget(context, userBloc),
      childWeb: profileWebPageWidget(context, userBloc),
    );
  }
}
