import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class WalletItemListWidget extends StatelessWidget {
  final Wallet wallet;
  final TabController tabController;
  final bool hidePrefix;
  final Function selectedItem;
  final int index;
  final bool hideActions;
  WalletItemListWidget(
      this.wallet, this.tabController, this.hidePrefix, this.index,
      {this.selectedItem,this.hideActions = false});

  final walletBloc = Modular.get<WalletBloc>();

  @override
  Widget build(BuildContext context) {
    if (!hidePrefix &&
        walletBloc?.myPayment?.stream?.value?.id == null) {
      walletBloc.myPayment.sink.add(wallet);
   //   selectedItem(wallet);
    }else{
      if(walletBloc?.myPayment?.stream?.value?.id == wallet.id){
     //   selectedItem(wallet);
      }

    }
    IconData ccBrandIcon;
    if (wallet != null) {
      var brand = wallet.brand;
      if (brand.toLowerCase().contains('visa')) {
        ccBrandIcon = FontAwesomeIcons.ccVisa;
      } else if (brand.toLowerCase().contains('master')) {
        ccBrandIcon = FontAwesomeIcons.ccMastercard;
      } else if (brand.toLowerCase().contains('american') || brand.toLowerCase().contains('amex')) {
        ccBrandIcon = FontAwesomeIcons.ccAmex;
      } else if (brand.toLowerCase().contains('discover')) {
        ccBrandIcon = FontAwesomeIcons.ccDiscover;
      } else if (brand.toLowerCase().contains('diners')) {
        ccBrandIcon = FontAwesomeIcons.ccDinersClub;
      }else if (brand.toLowerCase().contains('jcb')) {
        ccBrandIcon = FontAwesomeIcons.ccJcb;
      }else{
        ccBrandIcon = FontAwesomeIcons.paypal;
      }
    }
    return Container(

        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(


            child:   Container(
                // padding: EdgeInsets.symmetric(horizontal:!hideActions ? 12:0,vertical: !hideActions ? 12:0),
                child:titleDescriptionBigMobileWidget(context,
                title: (wallet?.description ?? "") +
                    (index == 0 ? " (Principal)" : ""),
                padding: 12,
                iconWidget: FaIcon(
                  ccBrandIcon,

                  size: 28,
                  color: AppThemeUtils.colorPrimary,
                ),
                description: wallet?.number ?? "",
                maxLine: 1,
                prefix: hidePrefix
                    ? null
                    : StreamBuilder<Wallet>(
                        initialData: Wallet(),
                        stream: walletBloc.myPayment.stream,
                        builder: (context, snapshot) => Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: snapshot?.data?.id == wallet?.id
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppThemeUtils.colorPrimary,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.grey[300],
                                  ))), action:!hideActions ?null: () {
                  selectedItem(wallet);
              walletBloc.myPayment.sink.add(wallet);
            },
                customIcon:Flex(
                  direction: Axis.vertical,
                  children: [

                  StreamBuilder<bool>(
                  initialData: false,
                  stream:
                  walletBloc.editAddress,
                  builder: (ctx, snapshot) =>  !snapshot.data ?SizedBox():  IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AppThemeUtils.colorError,
                        ),
                        onPressed: () {
                          walletBloc.removePayment(context, wallet);
                          selectedItem(null);
                        })),
                  ],
                )))),

        lineViewWidget()
      ],
    ));
  }
}
