import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/address_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';

import 'address_item_list_widget.dart';

class AddressBuilder {
  Widget buildBodyAddress(
      BuildContext context,
      ResponsePaginated responsePaginated,
      AddressBloc addressBloc,
      TabController tabController,
      bool hidePrefix,
      {Function selectedItem,
      Function actionEdit}) {
    return _buildContentPageAddress(
        context, responsePaginated, addressBloc, tabController, hidePrefix,
        selectedItem: selectedItem, actionEdit: actionEdit);
  }

  Widget _buildContentPageAddress(
      BuildContext context,
      ResponsePaginated responsePaginated,
      AddressBloc addressBloc,
      TabController tabController,
      bool hidePrefix,
      {Function selectedItem,
      Function actionEdit}) {
    return builderInfinityListViewComponent(responsePaginated,
        callMoreElements: (page) => addressBloc.getListAddress(page: page),
        buildBody: (content) {
          if (content is MyAddress) {
            if (selectedItem != null) {
              List list = responsePaginated.content;
              var indexOf = list.indexOf(content);
              if (indexOf == 0) {
                selectedItem(content);
              }
            }
          }

          return AddressItemListWidget(content, tabController, hidePrefix,
              actionEdit: actionEdit, selectedItem: selectedItem);
        });
  }
}
