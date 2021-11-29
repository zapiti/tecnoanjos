import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';

import 'options_item_list_widget.dart';

Widget listCarOptions(WalletBloc walletBloc) {
  return Card(
      child: Container(
          height: 270,
          child: builderComponent<ResponsePaginated>(
              stream: walletBloc.listWalletInfo.stream,
              initCallData: () => walletBloc.getListWallet(),
              // tryAgain: () {
              //   walletBloc.getListWallet();
              // },
              buildBodyFunc: (context, response) => Expanded(
                  child: builderInfinityListViewComponent(response,
                      callMoreElements: (page) =>
                          walletBloc.getListWallet(page: page),
                      buildBody: (content) =>
                          OpetionsItemListWidget(content))))));
}
