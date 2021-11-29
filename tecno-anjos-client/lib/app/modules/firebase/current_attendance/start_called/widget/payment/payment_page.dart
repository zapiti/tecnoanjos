import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/listcard/list_car_options.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'item_new_payment_form.dart';

class PaymentPage extends StatelessWidget {
  final walletBloc = Modular.get<WalletBloc>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(
      children: [
        Container(
          color: AppThemeUtils.colorPrimary,
          width: MediaQuery.of(context).size.width,
          height: 140,
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 60,
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'VALOR TOTAL',
                        overflow: TextOverflow.ellipsis,
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.whiteColor),
                      ),
                      Text(
                        "R\$325,00",
                        style: AppThemeUtils.normalBoldSize(
                            color: AppThemeUtils.whiteColor, fontSize: 30),
                      ),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                  child: Card(child: itemNewPaymentForm())),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'OPÇÕES',
                    overflow: TextOverflow.ellipsis,
                    style: AppThemeUtils.normalSize(
                        color: AppThemeUtils.colorPrimary),
                  )),
              listCarOptions(walletBloc)
            ]),
      ],
    ));
  }

  Future resultAction(BuildContext context) async {
//      var result = await Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (BuildContext context) => ChangeDateDiaries(),
//              fullscreenDialog: true));
//      if (result != null) {
//        _controllerChoose.text = result;
//      }
  }
}
