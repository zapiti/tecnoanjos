import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import '../../../app_bloc.dart';
import 'mobile/sugestions_mobile.dart';
class SugestionPage extends StatelessWidget {
  final appBloc = Modular.get<AppBloc>();
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: SugestionsMobile(),
      childWeb: SugestionsMobile(),
    );
  }
}