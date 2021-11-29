import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/widget/wallet_item_list_widget.dart';

import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../wallet_bloc.dart';

class WalletBuilder {
  Widget buildBodyWallet(
      BuildContext context,
      ResponsePaginated responsePaginated,
      WalletBloc walletBloc,
      TabController tabController,
      bool hidePrefix,
      bool hideActions,
      {Function selectedItem }) {
    return _buildContentPageWallet(
        context, responsePaginated, walletBloc, tabController, hidePrefix,
        selectedItem: selectedItem == null ? (x){}:selectedItem,hideActions:hideActions);
  }

  Widget _buildContentPageWallet(
      BuildContext context,
      ResponsePaginated responsePaginated,
      WalletBloc walletBloc,
      TabController tabController,
      bool hidePrefix,
      {Function selectedItem,bool hideActions}) {
    return builderInfinityListViewComponent(responsePaginated,
        callMoreElements: (page) => walletBloc.getListWallet(page: page),headerWidget:()=> Column(children: [
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
                child: Text(
                  "Selecione seu cartão",
                  style: AppThemeUtils.normalBoldSize(),
                )),
            IconButton(
                icon: StreamBuilder<bool>(
                    initialData: false,
                    stream:
                    walletBloc.editAddress,
                    builder: (ctx, snapshot) =>
                    !snapshot.data
                        ? Icon(
                      Icons.edit,
                      color: AppThemeUtils
                          .darkGrey,
                    )
                        : Icon(
                      Icons.close,
                      color: AppThemeUtils
                          .darkGrey,
                    )),
                onPressed: () {
                  walletBloc.editAddress.sink
                      .add(!walletBloc
                      .editAddress
                      .stream
                      .value);
                })
          ],
        )),lineViewWidget() ,
        ],),
        buildBody: (content) => WalletItemListWidget(
              content,
              tabController,
              hidePrefix,
              ObjectUtils.parseToObjectList<Wallet>(responsePaginated.content)
                  .indexOf(content),
              selectedItem: selectedItem,hideActions:hideActions
            ));
  }
}
