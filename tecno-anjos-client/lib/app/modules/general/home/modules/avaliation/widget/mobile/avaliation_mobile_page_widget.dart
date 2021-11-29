import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../avaliation_bloc.dart';
import '../avaliation_builder.dart';

Widget avaliationMobilePageWidget(AvaliationBloc blocAvaliacoes) {
  return  AvaliationBuilder.buildBodyEvaluation(blocAvaliacoes);
}
