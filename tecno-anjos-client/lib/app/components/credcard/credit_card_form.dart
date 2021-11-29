import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:credit_card_validate/credit_card_validate.dart' as cred;

import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/address/address_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/pages/address_create_widget.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import '../my_cpf_widget.dart';
import 'credit_card_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'credit_card_widget.dart' as card;

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.onNext,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.apelido,
    this.address,
    this.cpfCode,
    this.cardNumber2,
    this.expiryDate2,
    this.apelido2,
    this.cardHolderName2,
    this.cvvCode2,
    this.onPreview,
    this.isCvvFocused2})
      : super(key: key);
  final String cardNumber2;
  final String expiryDate2;
  final String apelido2;
  final String cardHolderName2;
  final String cvvCode2;
  final bool isCvvFocused2;
  final String cardNumber;
  final String expiryDate;
  final String apelido;
  final String cardHolderName;
  final String cvvCode;
  final String cpfCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;
  final MyAddress address;
  final Function onNext;
  final Function onPreview;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  // String cardNumber;
  // String apelido;
  // String expiryDate;
  // String cardHolderName;
  // String cvvCode;
  // String cpfCode;
  // String creditCardNumber = '';
  IconData brandIcon;
  final addressBloc = Modular.get<AddressBloc>();
  bool isCvvFocused = false;
  Color themeColor;
  MyAddress address;
  var maskCvv = "000";
  var hintCvv = "XXX";
  var pageBuilderIndex = BehaviorSubject<int>.seeded(0);
  var hideSubject = BehaviorSubject<bool>.seeded(false);
  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;
  var walletBloc = Modular.get<WalletBloc>();

  FocusNode cpfFocus = FocusNode();
  FocusNode numberFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode apelidoFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode cvvFocusNode = FocusNode();
  FocusNode cepFocus = FocusNode();

  String cpfError;
  String numberError;
  String nameError;
  String apelidoError;
  String dateFocusError;
  String cvvFocusNodeError;
  String addressError;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageBuilderIndex.close();
    hideSubject.close();
  }

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    walletBloc.cardNumberController?.text = widget.cardNumber ?? '';
    walletBloc.expiryDateController?.text = widget.expiryDate ?? '';
    walletBloc.apelidoController?.text =
    (widget.apelido ?? "").isEmpty ? 'Meu cartão' : (widget.apelido ?? "");
    walletBloc.cardHolderNameController?.text = widget.cardHolderName ?? '';
    walletBloc.cvvCodeController?.text = widget.cvvCode ?? '';
    walletBloc.cpfCodeController?.text = widget.cpfCode ?? '';
    address = widget.address;
    creditCardModel = CreditCardModel(
        walletBloc.cardNumberController?.text,
        walletBloc.expiryDateController?.text,
        walletBloc.cardHolderNameController?.text,
        walletBloc.cvvCodeController?.text,
        isCvvFocused,
        walletBloc.apelidoController?.text,
        address);
  }



  @override
  void initState() {
    super.initState();
    // addressBloc.getListAddress();
    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;
    walletBloc.cvvCodeController = MaskedTextController(mask: maskCvv);
    cvvFocusNode.addListener(textFieldFocusDidChange);

    walletBloc.apelidoController.addListener(() {
      //  setStateIfMounted(() {

      creditCardModel.apelido = walletBloc.apelidoController?.text;
      onCreditCardModelChange(creditCardModel);
      if ((apelidoError ?? "").isNotEmpty) {
        setState(() {
          apelidoError = null;
        });
      }

      //    });
    });

    walletBloc.cardNumberController.addListener(() {
      //   setStateIfMounted(() {

      creditCardModel.cardNumber = walletBloc.cardNumberController?.text;
      onCreditCardModelChange(creditCardModel);
      //   });

      if ((numberError ?? "").isNotEmpty) {
        setState(() {
          numberError = null;
        });
      }
    });

    walletBloc.expiryDateController.addListener(() {
      //setStateIfMounted(() {

      creditCardModel.expiryDate = walletBloc.expiryDateController?.text;
      onCreditCardModelChange(creditCardModel);
      if ((dateFocusError ?? "").isNotEmpty) {
        setState(() {
          dateFocusError = null;
        });
      }

      //    });
    });

    walletBloc.cpfCodeController.addListener(() {
      //   setStateIfMounted(() {

      creditCardModel.cpfCode = walletBloc.cpfCodeController?.text;
      onCreditCardModelChange(creditCardModel);
      if ((cpfError ?? "").isNotEmpty) {
        setState(() {
          cpfError = null;
        });
      }

      //    });
    });

    walletBloc.cardHolderNameController.addListener(() {
      //  setStateIfMounted(() {

      creditCardModel.cardHolderName =
          walletBloc.cardHolderNameController?.text;
      onCreditCardModelChange(creditCardModel);
      if ((nameError ?? "").isNotEmpty) {
        setState(() {
          nameError = null;
        });
      }

      //   });
    });

    walletBloc.cvvCodeController.addListener(() {
      updateCvv();
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme
        .of(context)
        .primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (pageBuilderIndex.stream.value != 0) {
            previusPageLogic(pageBuilderIndex.stream.value);
            return false;
          } else {
            return true;
          }
        },
        child: Form(
            child: SingleChildScrollView(child: Column(
              children: [

               kIsWeb
                        ? SizedBox()
                        : card.CreditCardWidget(
                      cardBgColor: AppThemeUtils.colorPrimary,
                      cardNumber: widget.cardNumber2,
                      expiryDate: widget.expiryDate2,
                      apelido: widget.apelido2,
                      cardHolderName: widget.cardHolderName2,
                      cvvCode: widget.cvvCode2,
                      showBackView: widget.isCvvFocused2,
                    ),
         Container(


                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: _listFields(context),
                    )),


                Container(
                    padding: EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () {
                        nextPageLogic();
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
                                "Salvar Cartão"
                                ,
                                style: AppThemeUtils.normalSize(
                                    color: AppThemeUtils.whiteColor),
                              ))),
                    ))
                //         Container(
                //           color: Colors.white,
                //             child:   StreamBuilder<int>(
                //               stream: pageBuilderIndex.stream,
                //               builder: (context, snapshot) => Row(
                //                     children: [
                //                       Expanded(
                //                           child:widget.onPreview  == null && (snapshot.data == 0) ? SizedBox(): Container(
                //                         height: 40,
                //                         margin:
                //                             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //                         child: ElevatedButton(
                //                 style:ElevatedButton.styleFrom(
                // primary:  AppThemeUtils.whiteColor),
                //                           child: Text(
                //                             StringFile.anterior,
                //                             style: AppThemeUtils.normalSize(
                //                                 color: AppThemeUtils.colorPrimary),
                //                           ),
                //                           onPressed: () {
                //
                //                           },
                //                         ),
                //                       )),
                //                       SizedBox(
                //                         width: 10,
                //                       ),
                //                       Expanded(
                //                         child: Container(
                //                             height: 40,
                //                             margin: EdgeInsets.symmetric(
                //                                 horizontal: 10, vertical: 5),
                //                             child: ElevatedButton(
                //                 style:ElevatedButton.styleFrom(
                // primary:  AppThemeUtils.colorPrimary),
                //                               child: Text(
                //                                 snapshot.data == 5
                //                                     ? StringFile.concluir
                //                                     : StringFile.proximo,
                //                                 style: AppThemeUtils.normalSize(k
                //                                     color: AppThemeUtils.whiteColor),
                //                               ),
                //                               onPressed: () {
                //                                 nextPageLogic(snapshot.data);
                //                               },
                //                             )),
                //                       )
                //                     ],
                //                   )))
              ],
            ))));
  }

  void previusPageLogic(int index) {
    Utils.fieldFocusChange(context, null, cpfFocus);
  }

  void nextPageLogic() {
    var error;
    hideSubject.sink.add(false);
    if (walletBloc.cpfCodeController?.text?.isEmpty ?? false) {
      if (walletBloc.cpfCodeController?.text?.isEmpty ?? false) {
        cpfError = StringFile.cpfobrigatorio;
        error = cpfError;
        Utils.fieldFocusChange(context, cpfFocus, cpfFocus);
      } else if (!CPF.isValid(walletBloc.cpfCodeController?.text)) {
        cpfError = StringFile.cpfFormatoInvalido;
        error = cpfError;
        Utils.fieldFocusChange(context, cpfFocus, cpfFocus);
      } else {
        cpfError = null;
        error = null;
        Utils.fieldFocusChange(context, cpfFocus, apelidoFocus);
      }
    } else if (walletBloc.cardHolderNameController.text?.isEmpty ?? false) {
      // case 1:
      //   setStateIfMounted(() {
      //     if (walletBloc.apelidoController?.text.isEmpty) {
      //       apelidoError = StringFile.apelidoEobrigatorio;
      //       error = apelidoError;
      //       Utils.fieldFocusChange(context, apelidoFocus, apelidoFocus);
      //     } else {
      //       apelidoError = null;
      //       error = null;
      //       Utils.fieldFocusChange(context, apelidoFocus, nameFocus);
      //     }
      //   });
      //   break;

      setStateIfMounted(() {
        if ((walletBloc.cardHolderNameController.text
            .toString()
            .length <
            3) ||
            walletBloc.cardHolderNameController?.text
                .toString()
                .length >
                39) {
          nameError =
          walletBloc.cardHolderNameController?.text
              .toString()
              .length > 39
              ? StringFile.cartaoMax40
              : StringFile.nameCartaoObrigatorio;
          error = nameError;
          Utils.fieldFocusChange(context, nameFocus, nameFocus);
        } else {
          nameError = null;
          error = null;
          Utils.fieldFocusChange(context, nameFocus, numberFocus);
        }
      });
    } else if (!cred.CreditCardValidator.isCreditCardValid(
        cardNumber: walletBloc.cardNumberController?.text)) {
      setStateIfMounted(() {
        if (walletBloc.cardNumberController?.text?.isEmpty ?? false) {
          numberError = StringFile.numberCartaoObrigatorio;
          error = numberError;
          Utils.fieldFocusChange(context, numberFocus, numberFocus);
        } else if (!cred.CreditCardValidator.isCreditCardValid(
            cardNumber: walletBloc.cardNumberController?.text)) {
          Map<String, dynamic> cardData = CreditCardValidator.getCard(
              walletBloc.cardNumberController.text.replaceAll(" ", " "));
          bool isValid = cardData[CreditCardValidator.isValidCard];
          if (isValid) {
            numberError = null;
            error = null;
            Utils.fieldFocusChange(context, numberFocus, dateFocus);
          } else {
            numberError = StringFile.numberCartaoInvalidario;
            error = numberError;
            Utils.fieldFocusChange(context, numberFocus, numberFocus);
          }
        } else {
          numberError = null;
          error = null;
          Utils.fieldFocusChange(context, numberFocus, dateFocus);
        }
      });
    } else if (walletBloc.expiryDateController.text?.isEmpty ?? false) {
      setStateIfMounted(() {
        var list = walletBloc?.expiryDateController?.text?.split("/");
        if (list.length < 2) {
          dateFocusError = StringFile.dataInvalida;
          error = dateFocusError;
          Utils.fieldFocusChange(context, dateFocus, dateFocus);
        } else {
          var size = ObjectUtils.parseToInt(list.first.toString());
          var size2 = ObjectUtils.parseToInt(list.last.toString());
          if (size > 12) {
            dateFocusError = StringFile.mesInvalido;
            error = dateFocusError;
            Utils.fieldFocusChange(context, dateFocus, dateFocus);
          } else {
            if (size2 < 21) {
              dateFocusError = StringFile.anoInvalido;
              error = dateFocusError;
              Utils.fieldFocusChange(context, dateFocus, dateFocus);
            } else {
              dateFocusError = null;
              Utils.fieldFocusChange(context, dateFocus, cvvFocusNode);
              if (walletBloc.cvvCodeController?.text
                  .toString()
                  .length < 3) {
                if (walletBloc.cvvCodeController?.text
                    .toString()
                    .isNotEmpty) {
                  cvvFocusNodeError = StringFile.cvvInvalido;
                  error = cvvFocusNodeError;
                }

                Utils.fieldFocusChange(context, cvvFocusNode, cvvFocusNode);
              } else {
                if (walletBloc.cvvCodeController?.text
                    .toString()
                    .length >
                    3) {
                  cvvFocusNodeError = null;
                  error = null;
                } else {
                  Utils.fieldFocusChange(context, cvvFocusNode, cepFocus);
                }
              }
            }
          }
        }
      });
    } else {
      addressError = null;
      error = null;
      widget.onNext();


      if (error == null) {
        if (
        walletBloc.cvvCodeController?.text
            .toString()
            .length < 3) {
          Utils.fieldFocusChange(context, cvvFocusNode, cvvFocusNode);
        } else {
          hideSubject.sink
              .add(walletBloc.cvvCodeController?.text?.isNotEmpty ?? false);

        }
      }
    }
  }

  List<Widget> _listFields(BuildContext context) {
    return <Widget>[
      MyCpfWidget(
          controller: walletBloc.cpfCodeController,
          msgError: cpfError,
          actionNext: () {
            nextPageLogic();
          }),
      // Container(
      //   padding: const EdgeInsets.symmetric(vertical: 0.0),
      //   margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      //   child: TextField(
      //     inputFormatters: [
      //       LengthLimitingTextInputFormatter(30),
      //     ],
      //     controller:  walletBloc.apelidoController,
      //     focusNode: apelidoFocus,
      //     cursorColor: widget.cursorColor ?? themeColor,
      //     style: TextStyle(
      //       color: widget?.textColor,
      //     ),
      //     onSubmitted: (tex) {
      //       nextPageLogic(1);
      //     },
      //     decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      //         border: const OutlineInputBorder(),
      //         labelText: StringFile.apelidoParaCartao,
      //         hintText: StringFile.meuCartao,
      //         errorText: apelidoError),
      //     keyboardType: TextInputType?.text,
      //     textInputAction: TextInputAction.done,
      //   ),
      // ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        child: TextField(
          controller: walletBloc.cardHolderNameController,
          focusNode: nameFocus,
          onSubmitted: (tex) {
            nextPageLogic();
          },
          cursorColor: widget.cursorColor ?? themeColor,
          style: TextStyle(
            color: widget?.textColor,
          ),
          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              border: OutlineInputBorder(),

              labelText: StringFile.nomeNoCartao,
              errorText: nameError),


          inputFormatters: [
            LengthLimitingTextInputFormatter(40),
          ],
          keyboardType: TextInputType?.text,
          textInputAction: TextInputAction.done,
        ),
      ),
      Container(

        padding: const EdgeInsets.symmetric(vertical: 0.0),
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(80),
                  ],
                  controller: walletBloc.cardNumberController,
                  focusNode: numberFocus,
                  cursorColor: widget.cursorColor ?? themeColor,
                  onSubmitted: (tex) {
                    nextPageLogic();
                  },
                  onChanged: (String str) {
                    updateCardNumber(str);
                  },
                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      border: const OutlineInputBorder(),

                      errorText: numberError,
                      labelText: StringFile.numeroDoCartao,
                      hintText: 'xxxx xxxx xxxx xxxx',
                      suffixIcon: brandIcon != null
                          ? Container(
                          width: 50,
                          height: 45,
                          child: Center(
                              child: FaIcon(
                                brandIcon,
                                size: 28,
                                color: AppThemeUtils.colorPrimary,
                              )))
                          : null),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                )),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: TextField(
                      focusNode: dateFocus,
                      onSubmitted: (tex) {
                        nextPageLogic();
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(80),
                      ],
                      controller: walletBloc.expiryDateController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      onChanged: (text) {
                        // if (text.length >= 5) {
                        //   Utils.fieldFocusChange(context, dateFocus, cvvFocusNode);
                        // }
                      },
                      style: TextStyle(
                        color: widget?.textColor,
                      ),
                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          border: const OutlineInputBorder(),

                          errorText: dateFocusError,
                          labelText: StringFile.dataValidade,
                          hintText: 'MM/AA'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                      onSubmitted: (tex) {
                        nextPageLogic();
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(80),
                      ],
                      focusNode: cvvFocusNode,
                      controller: walletBloc.cvvCodeController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      style: TextStyle(
                        color: widget?.textColor,
                      ),
                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        border: const OutlineInputBorder(),

                        errorText: cvvFocusNodeError,
                        labelText: 'CVV',
                        hintText: hintCvv,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onChanged: (String text) {
                        if (hintCvv.length == 4 &&
                            text.length == 4 &&
                            (walletBloc?.textAddressController?.text?.isEmpty ??
                                false)) {
                          updateCvv();
                          //   updateAddress(context);
                        } else if (hintCvv.length == 3 &&
                            text.length == 3 &&
                            (walletBloc?.textAddressController?.text?.isEmpty ??
                                false)) {
                          updateCvv();
                          // updateAddress(context);
                        } else {
                          updateCvv();
                        }
                        if ((cvvFocusNodeError ?? "").isNotEmpty) {
                          setState(() {
                            cvvFocusNodeError = null;
                          });
                        }
                      },
                    ))
              ])),
      AddressCreateWidget(
          fileTitleEndereco: "Endereço de cobrança",
          selectedItem: (address) {
            var myPaymentCred =
                walletBloc.myPaymentEdit.stream.value ?? Wallet();
            myPaymentCred.myAddress = address;
            walletBloc.myPaymentEdit.sink.add(myPaymentCred);
          })
      // StreamBuilder<bool>(
      //     stream: addressBloc.hideListAddress,
      //     builder: (context, snapshot) => snapshot.data == null
      //         ? loadElements(context)
      //         : !snapshot.data
      //             ? InkWell(
      //                 onTap: () {
      //                   updateAddress(context, "");
      //                 },
      //                 child: Container(
      //                   padding: const EdgeInsets.symmetric(vertical: 0.0),
      //                   margin:
      //                       const EdgeInsets.only(left: 16, top: 10, right: 16),
      //                   child: TextField(
      //                     controller: walletBloc?.textAddressController,
      //                     cursorColor: widget.cursorColor ?? themeColor,
      //                     style: TextStyle(
      //                       color: widget?.textColor,
      //                     ),
      //                     enabled: false,
      //                     decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      //                         border: const OutlineInputBorder(),
      //                         labelText: StringFile.enderecoCobranca,
      //                         errorText: addressError),
      //                     inputFormatters: [
      //                       LengthLimitingTextInputFormatter(40),
      //                     ],
      //                     keyboardType: TextInputType?.text,
      //                     textInputAction: TextInputAction.done,
      //                   ),
      //                 ))
      //             : Container(
      //                 padding: const EdgeInsets.symmetric(vertical: 0.0),
      //                 margin:
      //                     const EdgeInsets.only(left: 16, top: 10, right: 16),
      //                 child: TextField(
      //                   controller: walletBloc.cepController,
      //                   onSubmitted: (tex) {
      //                     nextPageLogic(5);
      //                   },
      //                   cursorColor: widget.cursorColor ?? themeColor,
      //                   style: TextStyle(
      //                     color: widget?.textColor,
      //                   ),
      //                   focusNode: cepFocus,
      //                   onChanged: (ex) {
      //                     if (Utils.removeMask(ex).length >= 8) {
      //                       walletBloc.cepController.clear();
      //
      //                       updateAddress(context, Utils.removeMask(ex));
      //                     }
      //                   },
      //                   decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      //                       border: const OutlineInputBorder(),
      //                       labelText: StringFile.cepCobranca,
      //                       errorText: addressError),
      //                   inputFormatters: [
      //                     LengthLimitingTextInputFormatter(40),
      //                   ],
      //                   keyboardType: TextInputType.number,
      //                   textInputAction: TextInputAction.done,
      //                 ),
      //               )),
    ];
  }

  void updateAddress(BuildContext context, String cep) {
    Utils.goToAddress(context, cep).then((addr) {
      if (addr != null) {
        setStateIfMounted(() {
          address = addr;
          creditCardModel.address = address;
          walletBloc?.textAddressController?.text =
          "(${addr.title ?? ""}) ${Utils.addressFormatMyData(addr)} ";
          onCreditCardModelChange(creditCardModel);
        });
        widget.onNext();
      }
    });
  }

  void updateCvv() {
    setStateIfMounted(() {
      walletBloc.cvvCodeController?.text = walletBloc.cvvCodeController?.text;
      creditCardModel.cvvCode = walletBloc.cvvCodeController?.text;
      onCreditCardModelChange(creditCardModel);
    });
  }

  void updateCardNumber(String str) {
    Map<String, dynamic> cardData =
    CreditCardValidator.getCard(str.replaceAll(" ", ""));
    String cardType = cardData[CreditCardValidator.cardType];
    String brand2 =
    cred.CreditCardValidator?.identifyCardBrand(str.replaceAll(" ", ""));

    String brand = brand2 ?? cardType;
    IconData ccBrandIcon;
    if (brand != null) {
      walletBloc.apelidoController.text = "Meu $brand"
          .toUpperCase()
          .replaceAll("UNKNOWN", "CARTÃO")
          .replaceAll("NULL", "CARTÃO")
          .replaceAll("_", "");
      if (brand.toLowerCase().contains('visa')) {
        ccBrandIcon = FontAwesomeIcons.ccVisa;
      } else if (brand.toLowerCase().contains('master')) {
        ccBrandIcon = FontAwesomeIcons.ccMastercard;
      } else if (brand.toLowerCase().contains('american')) {
        ccBrandIcon = FontAwesomeIcons.ccAmex;
      } else if (brand.toLowerCase().contains('discover')) {
        ccBrandIcon = FontAwesomeIcons.ccDiscover;
      } else if (brand.toLowerCase().contains('diners')) {
        ccBrandIcon = FontAwesomeIcons.ccDinersClub;
      } else if (brand.toLowerCase().contains('jcb')) {
        ccBrandIcon = FontAwesomeIcons.ccJcb;
      }
    }

    setStateIfMounted(() {
      walletBloc.cardNumberController?.text = str;

      if (brand.toLowerCase().contains('american') || brand.toLowerCase().contains('amex')) {
        hintCvv = "XXXX";
        maskCvv = "0000";
      } else {
        hintCvv = "XXX";
        maskCvv = "000";
      }
      walletBloc.cvvCodeController = MaskedTextController(
          mask: maskCvv, text: walletBloc.cvvCodeController?.text);
      brandIcon = ccBrandIcon;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
