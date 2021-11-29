import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/client_wallet/models/client_wallet.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../client_wallet_bloc.dart';

class DetailClientWalletPage extends StatelessWidget {
  final ClientWallet clientWallet;
  final clientWalletBloc = Modular.get<ClientWalletBloc>();

  DetailClientWalletPage(this.clientWallet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.all(15),
                              child: Text(
                                StringFile.seuTecnoAnjoFavorito,
                                style: AppThemeUtils.normalBoldSize(),
                              )),
                          Container(
                              margin: EdgeInsets.only(
                                  top: 5, left: 5, right: 5, bottom: 5),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        (clientWallet.imagemUrl ?? ""),
                                        fit: BoxFit.fill,

                                        width: 150,
                                        height: 150,
                                        // placeholder: (context, url) =>
                                        //     new CircularProgressIndicator(),
                                        // errorWidget: (context, url, error) =>
                                        //     new Icon(Icons.error_outline),
                                      )))),
                          Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                clientWallet.name ?? "",
                                style: AppThemeUtils.normalBoldSize(),
                              )),
                          lineViewWidget(),
                          // titleDescriptionBigMobileWidget(
                          //   context,
                          //   title: 'E-mail',
                          //   description: clientWallet?.email?.toString() ?? "--",
                          // ),
                          // titleDescriptionBigMobileWidget(
                          //   context,
                          //   title: 'Telefone',
                          //   description: clientWallet?.telephone?.toString() ?? "--",
                          // ),
                          titleDescriptionBigMobileWidget(
                            context,
                            title: 'TAG',
                            description: clientWallet?.tagTechnician
                                ?.toString() ?? "--",
                          ),
                        ],
                      ))),
              lineViewWidget(),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: AppThemeUtils.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        )),
                    onPressed: () {
                      clientWalletBloc.removeTecno(
                          context, clientWallet, () {});
                    },
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                    child: Text(
                      StringFile.desvicular,
                      style:
                      TextStyle(color: AppThemeUtils.colorError, fontSize: 16),
                    ),

                  ))
            ]));
  }
}
