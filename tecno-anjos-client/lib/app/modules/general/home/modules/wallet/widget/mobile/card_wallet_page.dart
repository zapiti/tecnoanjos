import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/credcard/credit_card_form.dart';
import 'package:tecnoanjosclient/app/components/credcard/credit_card_model.dart';

import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/my_address_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'package:tecnoanjosclient/app/utils/utils.dart';

class CardWalletPage extends StatefulWidget {
 final Wallet wallet;
 final Function(Wallet) onSave;
 final Function onPreview;
 final bool hideBottom;

  CardWalletPage(this.wallet, {this.onSave,this.onPreview,this.hideBottom = false});

  @override
  _CardWalletPageState createState() => _CardWalletPageState();
}

class _CardWalletPageState extends State<CardWalletPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String apelido = '';
  String cpfCode = '';

  bool isCvvFocused = false;
  bool hideCardView = true;
  var walletBloc = Modular.get<WalletBloc>();
  var myAddressBloc = Modular.get<MyAddressBloc>();
  List<String> _listPaymentTitle = [];
  Wallet wallet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hideCardView = true;
    if (_listPaymentTitle.isEmpty) {
      hideCardView = false;
    }

    atulizedata();
  }

  void atulizedata() {
    wallet = walletBloc.myPaymentEdit.stream.value;
    if (wallet != null) {
      if ((wallet.year ?? "") != "") {
        expiryDate = "${wallet.month}/${wallet.year}";
      }
      cardHolderName = wallet.holderName ?? "";
      cvvCode = wallet.verificationValue ?? "";
      apelido = wallet.description ?? "";
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    walletBloc.saveNameWallet(creditCardModel.apelido);
    var tempWallet = walletBloc.myPaymentEdit.stream.value;
    if(mounted)
    setState(() {

        cardNumber = creditCardModel.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
        apelido = creditCardModel.apelido;

        cpfCode = creditCardModel.cpfCode;

        tempWallet?.number = cardNumber;
        tempWallet.verificationValue = cvvCode;
        tempWallet.holderName = cardHolderName;

        if (expiryDate.contains("/")) {
          try {
            var list = expiryDate.split("/");
            tempWallet.month = list.first;
            tempWallet.year = list.last;
          } catch (e) {}
        }
        tempWallet.holderCpf = Utils.removeMask(cpfCode);
        tempWallet.myAddress = myAddressBloc.selectedAddress.stream.value;
        tempWallet.description = apelido;

      walletBloc.myPaymentEdit.sink.add(tempWallet);
    });
  }

  @override
  Widget build(BuildContext context) {
    atulizedata();
    return Container(

        margin: EdgeInsets.symmetric(horizontal: 10),
        child:

            CreditCardForm(
              apelido: apelido,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardNumber2:  cardNumber,
              expiryDate2 :    expiryDate ,
              apelido2 :  apelido,
              cardHolderName2:  cardHolderName ,
              cvvCode2 : cvvCode ,
              isCvvFocused2 : isCvvFocused,onPreview:widget. onPreview,
              onNext: () {
                FocusScope.of(context).requestFocus(FocusNode());
                saveForm(context);
              },
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              address: myAddressBloc.selectedAddress.stream.value,
              onCreditCardModelChange: onCreditCardModelChange,
            )




        // Container(
        //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //     child: Text(
        //       'Adicione uma forma de pagamento.',
        //       style: AppThemeUtils.normalBoldSize(fontSize: 20),
        //     )),
        // _listPaymentTitle.isEmpty
        //     ? SizedBox()
        //     : Column(
        //         children: _listPaymentTitle
        //             .map<Widget>((e) => Card(
        //                     child: titleDescriptionBigMobileWidget(
        //                   context,
        //                   action: () {
        //                     setState(() {
        //                       //editar
        //                     });
        //                   },
        //                   iconData:
        //                       MaterialCommunityIcons.cash_multiple,
        //                   title: 'Forma de pagamento',
        //                   description: e,
        //                 )))
        //             .toList(),
        //       ),
        // hideCardView
        //     ? Card(
        //         child: titleDescriptionBigMobileWidget(context,
        //             action: () {
        //         setState(() {
        //           hideCardView = false;
        //         });
        //       },
        //             iconData: MaterialCommunityIcons.cash_usd,
        //             title: 'Forma de pagamento',
        //             description: "Adicione uma forma de pagamento",
        //             customIcon: Icon(
        //               Icons.add,
        //               color: AppThemeUtils.colorPrimary,
        //             )))
        //     : SizedBox(),
        // kIsWeb
        //     ? SizedBox()
        //     : CreditCardWidget(
        //         height: 170,
        //         cardNumber: cardNumber,
        //         cardBgColor: AppThemeUtils.colorPrimary,
        //         expiryDate: expiryDate,
        //         cardHolderName: cardHolderName,
        //         cvvCode: cvvCode,
        //         showBackView: isCvvFocused,
        //       ),
        // hideCardView
        //     ? SizedBox()
        //     : CreditCardForm(
        //         apelido: apelido,
        //         cardNumber: cardNumber,
        //         expiryDate: expiryDate,onNext: (){
        //   FocusScope.of(context).requestFocus(FocusNode());
        //   saveForm(context);
        //
        // },
        //         cardHolderName: cardHolderName,
        //         cvvCode: cvvCode,
        //         address: address,
        //         onCreditCardModelChange: onCreditCardModelChange,
        //       ),
        // hideCardView
        //     ? SizedBox()
        //     : Container(
        //         width: MediaQuery.of(context).size.width,
        //         height: 45,
        //         margin:
        //             EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        //         child: ElevatedButton(
        //           color: Theme.of(context).primaryColor,
        //           onPressed: () {
        //             //   var profileBloc = Modular.get<ProfileBloc>();
        //             //  profileBloc.verifyNeedCpf(context, (value) {
        //
        //             saveForm(context);
        //
        //             //   });
        //           },
        //           //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
        //           child: AutoSizeText(
        //             'SALVAR FORMA DE PAGAMENTO',
        //             maxLines: 1,
        //             maxFontSize: 16,
        //             style: TextStyle(color: Colors.white, fontSize: 16),
        //           ),
        //           shape: RoundedRectangleBorder(
        //               borderRadius:
        //                   BorderRadius.all(Radius.circular(4)),
        //               borderSide: BorderSide.none),
        //         )),

        );
  }

  void saveForm(BuildContext context) {
    //   var profileBloc = Modular.get<ProfileBloc>();
    //  profileBloc.verifyNeedCpf(context, (value) {

    var profileBloc = Modular.get<ProfileBloc>();
    profileBloc.verifyNeedCpf(context, (containsCpf) async {
      if (containsCpf != null) {
        walletBloc.createNewAddress(context, (wallet) {
          walletBloc.saveNameWallet("");
          var tempWallet = Wallet();
          if(mounted)
          setState(() {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              cardNumber = "";
              expiryDate = "";
              cardHolderName = "";
              cvvCode = "";

              apelido = "";

              cpfCode = "";

              tempWallet?.number = cardNumber;
              tempWallet.verificationValue = cvvCode;
              tempWallet.holderName = cardHolderName;

              if (expiryDate.contains("/")) {
                try {
                  var list = expiryDate.split("/");
                  tempWallet.month = list.first;
                  tempWallet.year = list.last;
                } catch (e) {}
              }
              tempWallet.holderCpf = Utils.removeMask(cpfCode);
              tempWallet.myAddress = myAddressBloc.selectedAddress.stream.value;
              tempWallet.description = apelido;
            });
            walletBloc.myPaymentEdit.sink.add(Wallet());
            walletBloc.myPayment.sink.add(Wallet());
            widget.onSave(wallet);
          });
        });
      } else {
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: StringFile.cpfobrigatorio,
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.ok);
      }
    });

    //   });
  }
}
