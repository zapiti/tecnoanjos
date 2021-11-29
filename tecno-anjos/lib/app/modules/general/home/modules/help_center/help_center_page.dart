import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/search/filter.dart';
import 'package:tecnoanjostec/app/components/search/search_app_bar.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/help_center_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/widget/help_center_builder.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';

class HelpCenterPage extends StatelessWidget {
  final _blocHelpCenter = Modular.get<HelpCenterBloc>();
  @override
  Widget build(BuildContext context) {
       return DefaultPageWidget(enableBar: false,
        childMobile:Scaffold(
        appBar: SearchAppBar<String>(
          title: Text(StringFile.centralDeAjuda),
          searchButtonPosition: 0,
          centerTitle: true,
          keyboardType: TextInputType.text,
          hintText: StringFile.buscar,
          filter: Filters.contains,
          changeLabel: (value) {
            if(value.isEmpty){
              _blocHelpCenter.getListFaq();
            }else{
              _blocHelpCenter.getListSearch(value);
            }

          },
          containsSearch: true,
          iconTheme: IconThemeData(color: Theme.of(context).backgroundColor),
        ),  drawer: Modular.get<DrawerPage>(),
        body: builderComponent<ResponsePaginated>(
            stream: _blocHelpCenter.listFaqStream,
            emptyMessage: StringFile.semRegistro,
            initCallData: () => _blocHelpCenter.getListFaq(),
            // tryAgain: () {
            //   _blocHelpCenter.getListFaq();
            // },
            buildBodyFunc: (context, response) =>
                HelpCenterBuilder().buildBodyHelpCenter(context, response))),childWeb: builderComponent<ResponsePaginated>(
           stream: _blocHelpCenter.listFaqStream,
           emptyMessage: StringFile.semRegistro,
           initCallData: () => _blocHelpCenter.getListFaq(),
           // tryAgain: () {
           //   _blocHelpCenter.getListFaq();
           // },
           buildBodyFunc: (context, response) =>
               HelpCenterBuilder().buildBodyHelpCenter(context, response)),);
  }
}
