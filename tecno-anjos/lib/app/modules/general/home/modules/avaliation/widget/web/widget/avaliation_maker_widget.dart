import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/card/card_web_widget.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../avaliation_bloc.dart';
import '../../avaliation_builder.dart';

class AvaliationMakerWidget extends StatelessWidget {
  final AvaliationBloc blocAvaliacoes;
  AvaliationMakerWidget(this.blocAvaliacoes);
  @override
  Widget build(BuildContext context) {
    return cardWebWidget(
      context,
      height: 600,
      child: Flex(
        direction: Axis.vertical,
        children: [
          AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                StringFile.avaliacoesFeitas,
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
            child: AvaliationBuilder.buildContentPageEvaluation(
                blocAvaliacoes.listMakerEvaluationInfo.stream,
                (data) => blocAvaliacoes.getListAvaliationReceiver(page: data),
                blocAvaliacoes),
            height: 450,
          )
        ],
      ),
    );
  }
}
