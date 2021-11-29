import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/table_money_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/widget/table_money_builder.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class TableMoneyPage extends StatelessWidget {
  final _tableMoneyBloc = Modular.get<TableMoneyBloc>();
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(childWeb: Scaffold(
        appBar: AppBar(
          title: Text(StringFile.configValor,  style:
    AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary)),
        ),
        body: builderComponent<ResponsePaginated>(
          stream: _tableMoneyBloc.listTableMoneyInfo.stream,
          initCallData: () {
            _tableMoneyBloc.getListTableMoney();
          },
          buildBodyFunc: (context, content) =>
              TableMoneyBuilder().tableNameBuilder(context, content),
        )), childMobile: Scaffold(
        appBar: AppBar(
          title: Text(StringFile.configValor,  style:
    AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary)),
        ),
        body: builderComponent<ResponsePaginated>(
          stream: _tableMoneyBloc.listTableMoneyInfo.stream,
          initCallData: () {
            _tableMoneyBloc.getListTableMoney();
          },
          buildBodyFunc: (context, content) =>
              TableMoneyBuilder().tableNameBuilder(context, content),
        )),enableBar: false,) ;
  }
}
