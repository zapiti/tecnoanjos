import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/card/card_web_widget.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../../avaliation_bloc.dart';
import '../../avaliation_builder.dart';

class AvaliationReceiverWidget extends StatelessWidget {
  final AvaliationBloc blocAvaliacoes;

  AvaliationReceiverWidget(this.blocAvaliacoes);

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
                StringFile.avaliacoesRecebidas,
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
              height: 450,
              child: AvaliationBuilder.buildContentPageEvaluation(
                  blocAvaliacoes.listReceiverEvaluationInfo.stream,
                  (data) => blocAvaliacoes.getListAvaliationMaker(page: data),
                  blocAvaliacoes))
        ],
      ),
    );
  }
}
