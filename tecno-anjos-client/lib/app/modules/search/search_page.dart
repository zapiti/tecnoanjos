
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/search/search_bloc.dart';
import 'package:tecnoanjosclient/app/modules/search/widget/search_list_screen.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

class SearchPage extends StatelessWidget {
  final searchBloc = Modular.get<MySearchBloc>();
  final Pairs elemenst;

  SearchPage(this.elemenst);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          searchBloc.getSearch(elemenst.second);
        },
        child: DefaultPageWidget(
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
