


import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app_bloc.dart';


class LoadViewElement extends StatelessWidget {
  final Widget  child;
  var appBloc = Modular.get<AppBloc>();
  LoadViewElement({this.child});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: appBloc.loadElement.stream,
    initialData: false,
        builder: (context,snapshot)=>AbsorbPointer(
      absorbing: snapshot.data,
      child:Stack(children: [child ?? SizedBox(),
    Container(

    child:  snapshot.data ? LinearProgressIndicator(
    valueColor: AlwaysStoppedAnimation<
        Color>(  AppThemeUtils.colorPrimary),
      minHeight: 10,
    ):SizedBox()),])));
  }
}
