import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/card/card_web_widget.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/table_money_bloc.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../table_money_builder.dart';

class TableMoneyWidget extends StatelessWidget {
  final TableMoneyBloc tableMoneyBloc;
  TableMoneyWidget(this.tableMoneyBloc);
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
                StringFile.precoSobreServico,
                style:
                AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
              )),
          SizedBox(
            height: 15,
          ),
          Container(
            child: builderComponent<ResponsePaginated>(
                stream: tableMoneyBloc.listTableMoneyInfo.stream,
                initCallData: () {
                  tableMoneyBloc.getListTableMoney();
                },
                emptyMessage: StringFile.semTabelaPreco,
                // tryAgain: () {
                //   tableMoneyBloc.getListTableMoney();
                // },
                buildBodyFunc: (context, response) => TableMoneyBuilder()
                    .buildContentTablePayment(context, response)),
            height: 450,
          )
        ],
      ),
    );
  }
}
