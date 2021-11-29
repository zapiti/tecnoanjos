import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/widget/mobile/wallet_mobile_page_widget.dart';


class WalletPage extends StatelessWidget {
  final walletBloc = Modular.get<WalletBloc>();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      if(walletBloc.pageBuilderIndex.stream.value != 0){
       walletBloc. previusPageLogic(walletBloc.pageBuilderIndex.stream.value,context);
        return false;
      }else{
        return true;
      }

    },
    child:  DefaultPageWidget(
      childMobile: WalletMobilePageWidget(walletBloc, true,  (value){}),
      childWeb: WalletMobilePageWidget(walletBloc, true,  (value){}),
    ));
  }
}
