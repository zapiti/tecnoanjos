import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/avaliation_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/widget/mobile/avaliation_mobile_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/widget/web/avaliation_web_page_widget.dart';

class AvaliationPage extends StatelessWidget {
  final blocAvaliacoes = Modular.get<AvaliationBloc>();

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: avaliationMobilePageWidget(blocAvaliacoes),
      childWeb: avaliationWebPageWidget(context,blocAvaliacoes),
    );
  }
}
