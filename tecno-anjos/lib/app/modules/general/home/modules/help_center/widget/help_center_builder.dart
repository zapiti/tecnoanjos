import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/help_center/help_center_bloc.dart';

import 'help_center_item_list_widget.dart';

class HelpCenterBuilder {
  var helpCenterBloc = Modular.get<HelpCenterBloc>();
  Widget buildBodyHelpCenter(
      BuildContext context, ResponsePaginated responsePaginated) {
    return _buildContentPageFaq(context, responsePaginated);
  }

  Widget _buildContentPageFaq(
      BuildContext context, ResponsePaginated responsePaginated) {
    return builderInfinityListViewComponent(responsePaginated,
        callMoreElements: (page) => helpCenterBloc.getListFaq(page: page),
        buildBody: (content) => HelpCenterItemListWidget(content));
  }
}
