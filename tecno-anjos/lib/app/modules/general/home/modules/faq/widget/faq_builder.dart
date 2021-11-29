import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/faq/faq_bloc.dart';

import 'faq_item_list_widget.dart';

class FaqBuilder {
  var faqBloc = Modular.get<FaqBloc>();
  Widget buildBodyFaq(
      BuildContext context, ResponsePaginated responsePaginated) {
    return _buildContentPageFaq(context, responsePaginated);
  }

  Widget _buildContentPageFaq(
      BuildContext context, ResponsePaginated responsePaginated) {
    return builderInfinityListViewComponent(responsePaginated,
        callMoreElements: (page) => faqBloc.getListFaq(page: page),
        buildBody: (content) => FaqItemListWidget(content));
  }
}
