import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/components/rounded_check.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';

class OpetionsItemListWidget extends StatelessWidget {
  final Wallet wallet;
  OpetionsItemListWidget(this.wallet);


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: titleDescriptionBigMobileWidget(
              context,
              title: wallet?.description ?? "",
              padding: 10,
              iconData: Icons.credit_card,
              description: wallet.number,
              maxLine: 1,
              action: () {},
              customIcon: Container(
                child: RoundedCheck(),
                width: 30,
                height: 30,
              ),
            )),
        lineViewWidget()
      ],
    ));
  }
}
