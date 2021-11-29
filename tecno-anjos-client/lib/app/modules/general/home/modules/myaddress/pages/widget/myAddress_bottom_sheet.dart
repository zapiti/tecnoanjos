import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/mobile/my_address_mobile_widget.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../my_address_bloc.dart';


Future<void> showBottomSheetMyAddress(
    BuildContext context, Function(MyAddress) selectedItem) async {
  return showModalBottomSheet(
    isScrollControlled: true,
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
  final Function(MyAddress) selectedItem;

  _WalletBottomSheet({this.selectedItem});

  @override
  _WalletBottomSheetState createState() => _WalletBottomSheetState();
}

class _WalletBottomSheetState extends State<_WalletBottomSheet> {
  var walletBloc = Modular.get<WalletBloc>();
  bool registreCard = false;
  final tempTextEditingController = TextEditingController();
  var myAddressBloc = Modular.get<MyAddressBloc>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletBloc.getListWallet();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          widget.selectedItem(null);
          return true;
        },
        child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
                children: [
              AppBar(
                title: Text(
                  "ENDEREÇO ",
                  style: AppThemeUtils.normalSize(
                      color: AppThemeUtils.colorPrimary, fontSize: 20),
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
              ),
                  StreamBuilder<List<MyAddress>>(
                      stream: myAddressBloc.listAddressForm,
                      builder: (context, snapshot) => Container(
                        height: (snapshot.data  ?? []).isEmpty ? MediaQuery.of(context).size.height * 0.8 :   MediaQuery.of(context).size.height * 0.5,
                        child:
                            snapshot.data == null
                                ? loadElements(context)
                                : snapshot.data.isEmpty
                                ?  SingleChildScrollView(child:  MyAddressMobileWidget(
                      isSimpleNotDismissable:false,
                      dismissaAllOnsave: true,
                      selectedItem: widget.selectedItem)): MyAddressMobileWidget(
                                isSimpleNotDismissable:true,
                                dismissaAllOnsave: true,
                                selectedItem: widget.selectedItem)))
              // Container(
              //     height: registreCard
              //         ? MediaQuery.of(context).size.height * 0.9
              //         : MediaQuery.of(context).size.height * 0.4,
              //     child:
              //
              //     registreCard
              //         ? CardWalletPage(
              //             null,
              //             onSave: (wallet) {
              //               widget.selectedItem(wallet);
              //             },
              //             hideBottom: true,
              //             onPreview: () {},
              //           )
              //         : builderComponent<ResponsePaginated>(
              //             stream: walletBloc.listWalletInfo.stream,
              //             emptyMessage: StringFile.semCartaoCadastrado,
              //             initCallData: () => walletBloc.getListWallet(),
              //             // tryAgain: () {
              //             //   walletBloc.getListWallet();
              //             // },
              //             onEmptyAction: () {
              //               SchedulerBinding.instance.addPostFrameCallback((_) {
              //                 setState(() {
              //                   registreCard = true;
              //                 });
              //               });
              //             },
              //             buildBodyFunc: (context, response) {
              //               return WalletBuilder().buildBodyWallet(
              //                   context,
              //                   response,
              //                   walletBloc,
              //                   null,
              //                   false,
              //                   false, selectedItem: (wallet) {
              //                     if(tempTextEditingController.text.isEmpty){
              //                       tempTextEditingController.text = wallet.toString();
              //                     }else{
              //                       if(wallet.toString() != tempTextEditingController.text){
              //                         Navigator.of(context).pop();
              //                         widget.selectedItem(wallet);
              //                       }
              //
              //                     }
              //
              //               });
              //             })),
              // registreCard
              //     ? SizedBox()
              //     : Container(
              //         padding: EdgeInsets.all(15),
              //         child: ElevatedButton(
              //           onPressed: () {
              //             if (!registreCard) {
              //               SchedulerBinding.instance.addPostFrameCallback((_) {
              //                 setState(() {
              //                   registreCard = true;
              //                 });
              //               });
              //             }
              //           },
              //           style: ElevatedButton.styleFrom(
              //               primary: AppThemeUtils.colorPrimary,
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(10.0),
              //                   side: BorderSide(
              //                       color: AppThemeUtils.colorError))),
              //           child: Container(
              //               height: 45,
              //               child: Center(
              //                   child: Text(
              //                 registreCard
              //                     ? "Salvar Endereço"
              //                     : "Adicionar Endereço",
              //                 style: AppThemeUtils.normalSize(
              //                     color: AppThemeUtils.whiteColor),
              //               ))),
              //         ))
            ])));
  }
}
