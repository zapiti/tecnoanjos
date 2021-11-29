import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/components/page/default_tab_page.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/calling_bloc.dart';



import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import '../../wallet_bloc.dart';
import '../wallet_builder.dart';
import 'card_wallet_page.dart';

class WalletMobilePageWidget extends StatelessWidget {
  final WalletBloc walletBloc;
  final bool hidePrefix;
  final ValueChanged<bool> removeElement;

  WalletMobilePageWidget(this.walletBloc, this.hidePrefix, this.removeElement);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {},
        child: WalletMobileContentWidget(walletBloc, hidePrefix, false,
            removeElement: (values) {}));
  }
}

TabController tab;

class WalletMobileContentWidget extends StatelessWidget {
  final ValueChanged<bool> removeElement;
  final WalletBloc walletBloc;
  final bool hidePrefix;
  final bool hideActions;
  final Function selectedItem;
  final Function onPreview;
  final Function(Wallet) sucessItem;
  final callingBloc = Modular.get<CallingBloc>();

  WalletMobileContentWidget(this.walletBloc, this.hidePrefix, this.hideActions,
      {this.selectedItem, this.removeElement, this.sucessItem, this.onPreview});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          walletBloc.getListWallet();
        },
        child: StreamBuilder<bool>(
            stream: walletBloc.hideListWallet,
            builder: (context, snapshot) {
              var hide = snapshot.data;

              if (hide == true) {
                callingBloc.hideConfirmButton.sink.add(hide);
              }

              return snapshot.data == null
                  ? loadElements(context)
                  : hide
                      ? builderComponentSimple<Wallet>(
                          stream: walletBloc.myPayment.stream,
                          enableLoad: false,
                          initCallData: () => {},
                          tryAgain: () {
                            walletBloc.getListWallet();
                          },
                          buildBodyFunc: (context, response) => CardWalletPage(
                                response,
                                onSave: (wallet) {
                                  if (sucessItem != null) {
                                    sucessItem(wallet);
                                  }
                                  tab?.animateTo(0);
                                },
                                onPreview: onPreview,
                              ))
                      : DefaultTabPage(
                          null,
                          title: [
                            StringFile.cartaoCadastrado,
                            StringFile.novoCadastroCartao,
                          ],
                          changeTab: (tabController) {
                            tab = tabController;
                            tab.addListener(() {
                              removeElement(tab.index == 1);
                              // callingBloc.hideConfirmButton.sink.add(tab.index == 1);

                              //   walletBloc.myPayment.sink.add(Wallet());
                              walletBloc.myPaymentEdit.sink.add(Wallet());
                            });
                          },
                          page: [
                            builderComponent<ResponsePaginated>(
                                stream: walletBloc.listWalletInfo.stream,
                                emptyMessage: StringFile.semCartaoCadastrado,
                                initCallData: () => walletBloc.getListWallet(),
                                // tryAgain: () {
                                //   walletBloc.getListWallet();
                                // },
                                onEmptyAction: () {
                                  tab?.animateTo(1);
                                },
                                buildBodyFunc: (context, response) {
                                  return WalletBuilder().buildBodyWallet(
                                      context,
                                      response,
                                      walletBloc,
                                      tab,
                                      hidePrefix,
                                      hideActions,
                                      selectedItem: selectedItem);
                                }),
                            builderComponentSimple<Wallet>(
                                stream: walletBloc.myPayment.stream,
                                enableLoad: false,
                                initCallData: () => {},
                                tryAgain: () {
                                  walletBloc.getListWallet();
                                },
                                buildBodyFunc: (context, response) =>
                                    CardWalletPage(
                                      response,
                                      onSave: (wallet) {
                                        if (sucessItem != null) {
                                          sucessItem(wallet);
                                        }
                                        tab?.animateTo(0);
                                      },
                                      onPreview: onPreview,
                                    ))
                          ],
                        );
            }));
  }
}
