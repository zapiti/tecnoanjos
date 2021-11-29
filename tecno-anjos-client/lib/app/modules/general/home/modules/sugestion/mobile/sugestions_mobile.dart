import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/page/default_tab_page.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/sugestion/web/sugestions_web.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import '../sugestion_bloc.dart';

TabController tab;
class SugestionsMobile extends StatelessWidget {
  final sugestionsBloc = Modular.get<SugestionBloc>();
  final sugestionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  DefaultTabPage(tab,
            title: [StringFile.sugestoes, StringFile.critical],
            changeTab: (tab) {
              tab.addListener(() {
                FocusScope.of(context).requestFocus(FocusNode());
                sugestionsController.clear();
              });
            },
            page: [
              CriticalSuggestion(sugestionsController, isSuggestion: true),
              CriticalSuggestion(sugestionsController, isSuggestion: false),
            ]);
  }
}
