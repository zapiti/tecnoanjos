import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/avaliation_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/widget/avaliation_builder.dart';

Widget avaliationMobilePageWidget(AvaliationBloc blocAvaliacoes) {
  return  AvaliationBuilder.buildBodyEvaluation(blocAvaliacoes);
}
