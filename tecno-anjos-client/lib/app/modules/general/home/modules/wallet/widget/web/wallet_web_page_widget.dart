import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/components/card_web_with_title.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/widget/mobile/wallet_mobile_page_widget.dart';


import '../../wallet_bloc.dart';


Widget walletWebPageWidget(
    BuildContext context, WalletBloc walletBloc, bool hidePrefix) {
  return CardWebWithTitle(child:  Container(
      height: MediaQuery.of(context).size.height,
      child:WalletMobileContentWidget(walletBloc, hidePrefix, false,
          removeElement: (values) {})));
}
