import 'package:tecnoanjos_franquia/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjos_franquia/app/models/page/response_paginated.dart';
import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:tecnoanjos_franquia/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjos_franquia/app/modules/search/search_bloc.dart';
import 'package:tecnoanjos_franquia/app/modules/search/widget/search_list_screen.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchPage extends StatelessWidget {
  var searchBloc = Modular.get<MySearchBloc>();
  Pairs elemenst;

  SearchPage(this.elemenst);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          searchBloc.getSearch(elemenst.second);
        },
        child: DefaultPageWidget(
          desableBackHome: true,
          childMobile: SearchListScreen(elemenst.first),
          childWeb: SearchListScreen(elemenst.first),
        ));
  }
}

Future<Pairs> goToFilter(Future<ResponsePaginated> result, String title) async {
  var group = await Modular.to
      .pushNamed(ConstantsRoutes.SEARCH, arguments: Pairs(title, result));
  return group;
}
