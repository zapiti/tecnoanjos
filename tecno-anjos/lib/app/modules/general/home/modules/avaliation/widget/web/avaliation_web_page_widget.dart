import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/card_web_with_title.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/avaliation_bloc.dart';

import '../avaliation_builder.dart';

Widget avaliationWebPageWidget(BuildContext context,AvaliationBloc avaliationBloc) {
  return CardWebWithTitle(child:  Container(
      height: MediaQuery.of(context).size.height,
      child:    AvaliationBuilder.buildBodyEvaluation(avaliationBloc)));
}
