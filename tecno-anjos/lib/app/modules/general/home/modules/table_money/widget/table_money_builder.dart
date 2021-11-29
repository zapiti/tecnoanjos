import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjostec/app/components/page/default_tab_page.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/table_money_bloc.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

class TableMoneyBuilder {
  final blocTableMoney = Modular.get<TableMoneyBloc>();

  Widget tableNameBuilder(
      BuildContext context, ResponsePaginated responsePaginated) {
    return DefaultTabPage(
      title: [StringFile.precoSobreServico],
      page: [
        buildContentTablePayment(context, responsePaginated),
      ],
    );
  }

  Widget buildContentTablePayment(
      BuildContext context, ResponsePaginated responsePaginated) {
    return builderInfinityListViewComponent(
      responsePaginated,
      callMoreElements: (page) => blocTableMoney.getListTableMoney(page: page),
      buildBody: (dados) => Column(
        children: [
          titleDescriptionMobileWidget(context,
              title: dados.name ?? "",
              description: Utils.moneyFormat(dados.money)),
          lineViewWidget(top: 10)
        ],
      ),
    );
  }
}
