import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Future<void> showBottomSheetPayment(
    {BuildContext context,
    String title,
    String description,
    String subTitle}) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) => _PaymentBottomSheet(
      title: title,
      description: description,
      subTitle: subTitle,
    ),
  );
}

class _PaymentBottomSheet extends StatefulWidget {
  final String title;
  final String description;
  final String subTitle;

  _PaymentBottomSheet({this.title, this.description, this.subTitle});

  @override
  __PaymentBottomSheetState createState() => __PaymentBottomSheetState();
}

class __PaymentBottomSheetState extends State<_PaymentBottomSheet> {
  var walletBloc = Modular.get<WalletBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletBloc.getOneWallet();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
            children: [
          Container(
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Text(
              widget.title ?? "",
              style: AppThemeUtils.normalBoldSize(
                  fontSize: 20, color: AppThemeUtils.colorPrimary),
            ),
            padding: EdgeInsets.all(10),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              widget.description ?? "",
              style: AppThemeUtils.normalSize(),
            ),
            padding: EdgeInsets.all(10),
          ),
          lineViewWidget(),
          StreamBuilder<Wallet>(
            stream: walletBloc.oneWalletSubject,
            builder: (context, snapshot) => titleDescriptionBigMobileWidget(
                context,
                iconData: Icons.credit_card,
                title: snapshot.data?.description ?? "Não possui cartão?",
                description: snapshot.data?.number ?? "Adicione um novo cartão",
                customIcon: ElevatedButton(
                  onPressed: () {
                    Modular.to.pushReplacementNamed(ConstantsRoutes.CARTEIRA);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: AppThemeUtils.colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          side: BorderSide(color: AppThemeUtils.whiteColor))),
                  child: Container(
                      height: 45,
                      child: Center(
                          child: Text(
                        snapshot.data?.id == null
                            ? StringFile.adicionar
                            : StringFile.trocar,
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.whiteColor),
                      ))),
                )),
          ),
          lineViewWidget(),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              widget.subTitle ?? "",
              style: AppThemeUtils.normalSize(fontSize: 14),
            ),
            padding: EdgeInsets.all(10),
          ),
          Container(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    primary: AppThemeUtils.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: AppThemeUtils.colorError))),
                child: Container(
                    height: 45,
                    child: Center(
                        child: Text(
                      StringFile.contratar,
                      style: AppThemeUtils.normalSize(
                          color: AppThemeUtils.whiteColor),
                    ))),
              ))
        ]));
  }
}
