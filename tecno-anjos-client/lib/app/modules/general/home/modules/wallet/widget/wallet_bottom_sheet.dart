import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/widget/wallet_builder.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'mobile/card_wallet_page.dart';

Future<void> showBottomSheetWallet(
    BuildContext context, Function(Wallet) selectedItem) async {
  return showModalBottomSheet(
    isScrollControlled: true,enableDrag: false,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) => _WalletBottomSheet(
      selectedItem: selectedItem,
    ),
  );
}

class _WalletBottomSheet extends StatefulWidget {
  final Function(Wallet) selectedItem;

  _WalletBottomSheet({this.selectedItem});

  @override
  _WalletBottomSheetState createState() => _WalletBottomSheetState();
}

class _WalletBottomSheetState extends State<_WalletBottomSheet> {
  var walletBloc = Modular.get<WalletBloc>();
  bool registreCard = false;
  final tempTextEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletBloc.getListWallet();
  }

  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height:  registreCard
                      ? 56:0,),
              AppBar(
                title: Text(
                  "FORMA DE PAGAMENTO",
                  style: AppThemeUtils.normalSize(
                      color: AppThemeUtils.colorPrimary, fontSize: 20),
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
              ),
              Container(
                  height: registreCard
                      ? null
                      : MediaQuery.of(context).size.height * 0.4,
                  child: registreCard
                      ? CardWalletPage(
                          null,
                          onSave: (wallet) {
                            Navigator.of(context).pop();
                            widget.selectedItem(wallet);
                          },
                          hideBottom: true,
                          onPreview: () {},
                        )
                      : builderComponent<ResponsePaginated>(
                          stream: walletBloc.listWalletInfo.stream,
                          emptyMessage: StringFile.semCartaoCadastrado,
                          initCallData: () => {},
                          // tryAgain: () {
                          //   walletBloc.getListWallet();
                          // },
                          onEmptyAction: () {

                            widget.selectedItem(null);
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                registreCard = true;
                              });
                            });
                          },
                          buildBodyFunc: (context, response) {
                            return WalletBuilder().buildBodyWallet(
                                context,
                                response,
                                walletBloc,
                                null,
                                false,
                                true, selectedItem: (wallet) {
                                  // if(tempTextEditingController.text.isEmpty){
                                  //   tempTextEditingController.text = wallet.toString();
                                  // }else{
                                  //   if(wallet.toString() != tempTextEditingController.text){
                                      Navigator.of(context).pop();
                                      widget.selectedItem(wallet);
                                  //   }
                                  //
                                  // }

                            });
                          })),
              registreCard
                  ? SizedBox()
                  : StreamBuilder(stream: walletBloc.listWalletInfo.stream,builder: (context,snapshot)=> snapshot.data == null ?SizedBox(): Container(
                      padding: EdgeInsets.all(15),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!registreCard) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                registreCard = true;
                              });
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: AppThemeUtils.colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: AppThemeUtils.colorError))),
                        child: Container(
                            height: 45,
                            child: Center(
                                child: Text(
                              registreCard
                                  ? "Salvar Cartão"
                                  : "Adicionar Cartão",
                              style: AppThemeUtils.normalSize(
                                  color: AppThemeUtils.whiteColor),
                            ))),
                      ))),SizedBox(height:   MediaQuery.of(context).viewInsets.bottom + 20,)
            ])));
  }
}
