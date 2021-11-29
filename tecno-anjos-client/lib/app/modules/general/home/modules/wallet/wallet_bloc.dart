import 'dart:math';

import 'package:credit_card_validate/credit_card_validate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';

import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/my_address_bloc.dart';

import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import 'core/wallet_repository.dart';
import 'models/wallet.dart';

class WalletBloc extends Disposable {
  var listWalletInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempWallet = List<Wallet>.from([]);
  var oneWalletSubject = BehaviorSubject<Wallet>();
  var _repository = Modular.get<WalletRepository>();
  var myAddressBloc = Modular.get<MyAddressBloc>();
  var myPayment = BehaviorSubject<Wallet>.seeded(Wallet());
  var myPaymentEdit = BehaviorSubject<Wallet>.seeded(Wallet());
  final TextEditingController textAddressController = TextEditingController();
  var pageBuilderIndex = BehaviorSubject<int>.seeded(0);
  var editAddress = BehaviorSubject<bool>.seeded(false);


  final TextEditingController apelidoController =
      TextEditingController(text: "Meu cartão");
  final MaskedTextController cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController expiryDateController =
      MaskedTextController(mask: '00/00');

  FocusNode cpfFocus = FocusNode();
  FocusNode numberFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode apelidoFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode cvvFocusNode = FocusNode();
  FocusNode cepFocus = FocusNode();

  final TextEditingController cepController =
      MaskedTextController(mask: Utils.geMaskCep());

  final TextEditingController cardHolderNameController =
      TextEditingController();
  TextEditingController cvvCodeController;

  var controller = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );
  final TextEditingController cpfCodeController =
      MaskedTextController(mask: Utils.cpfCnpj(""));
  var hideListWallet = BehaviorSubject<bool>();



  void saveNameWallet(String nameCard) {
    var calling = myPayment.stream.value ?? Wallet();
    calling?.description = nameCard;
    myPayment.sink.add(calling);
  }

  getListWallet({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      listWalletInfo.sink.add(null);
      _listTempWallet.clear();
    }
    var result = await _repository.getListWallet(page: page);

    var listTemp = List<Wallet>.from([]);
    if (result.error == null) {
      listTemp.addAll(ObjectUtils.parseToObjectList<Wallet>(result.content));


      _listTempWallet.addAll(listTemp);
      _listTempWallet = _listTempWallet.toSet().toList();
      if (page != 0) {
        result.content = (_listTempWallet);
      }
      if (listTemp.length > 0) {
        hideListWallet.sink.add(false);
      } else {
        hideListWallet.sink.add(true);
      }
      await Future.delayed(
          Duration(milliseconds: 100), () => listWalletInfo.sink.add(result));
    }else{
      listWalletInfo.sink.add(ResponsePaginated());
    }
  }

  Future<void> createNewAddress(
      BuildContext context, Function(Wallet) onSave) async {
    var myPaymentCred = myPaymentEdit.stream.value ?? Wallet();
    if (myPaymentCred.myAddress == null &&
        myAddressBloc.selectedAddress.stream.value == null) {
      myAddressBloc.saveAddress(context, true, (p1) async {
        if (pi != null) {
          myPaymentCred.myAddress = p1;
          await _saveWallet(myPaymentCred, context, onSave);
        }
      });
    } else {
      myPaymentCred.myAddress = myAddressBloc.selectedAddress.stream.value;
      await _saveWallet(myPaymentCred, context, onSave);
    }
  }

  Future _saveWallet(
      Wallet myPaymentCred, BuildContext context,Function onSave) async {
    var error;
    if (myPaymentCred.myAddress == null) {
      error = StringFile.enderecoNaoPodeSerVazio;
    }
    if ((myPaymentCred.holderCpf ?? "").isEmpty) {
      error = StringFile.cpfobrigatorio;
    }
    if ((myPaymentCred.holderName ?? "").isEmpty) {
      error = StringFile.nomeNaoPodeSerVazio;
    }
    if ((myPaymentCred.verificationValue ?? "").isEmpty) {
      error = StringFile.codigoCvvNaoPodeSerVazio;
    }

    if (error != null) {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "$error",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    } else {
      if (CreditCardValidator.isCreditCardValid(
          cardNumber: myPaymentCred.number ?? "")) {
        showLoading(true);
        var result = await _repository.savePaymentForm(myPaymentCred);
        showLoading(false);
        if (result.error == null) {
          AmplitudeUtil.createEvent(AmplitudeUtil.sucessoAoSAlvarFormaDePagamento);
          myPayment.sink.add(Wallet());
          myPaymentEdit.sink.add(Wallet());

          if (onSave != null) {
            onSave(result.content);
          }
          getListWallet();
        } else {
          AmplitudeUtil.createEvent(AmplitudeUtil.falhaAoSalvarFormaDePagamento);
          showGenericDialog(
              context: context,
              title: StringFile.opps,
              description: "${result.error}",
              iconData: Icons.error_outline,
              positiveCallback: () {},
              positiveText: StringFile.ok);
        }
      } else {
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: StringFile.numberCartaoInvalidario,
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.ok);
      }
    }
  }

  void previusPageLogic(int index, BuildContext context) {

    switch (index) {
      case 0:
        Utils.fieldFocusChange(context, null, cpfFocus);
        break;
      case 1:
        Utils.fieldFocusChange(context, null, cpfFocus);

        break;
      // case 2:
      //   Utils.fieldFocusChange(context, nameFocus, apelidoFocus);
      //
      //   break;
      case 2:
        Utils.fieldFocusChange(context, numberFocus, nameFocus);

        break;
      case 3:
        Utils.fieldFocusChange(context, cvvFocusNode, numberFocus);

        break;
      case 4:
        Utils.fieldFocusChange(context, cvvFocusNode, cvvFocusNode);
        break;
    }

    controller.previousPage(
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  // void editPayment(BuildContext context, onSave) async {
  // showLoading(true);
  // var result = await _repository.editPaymentForm(myPaymentEdit.stream.value);
  // showLoading(false);
  // if (result.error == null) {
  //   myPayment.sink.add(null);
  //   myPaymentEdit.sink.add(Wallet());
  //   getListWallet();
  //   if (onSave != null) {
  //     onSave();
  //   }
  // } else {
  //   showGenericDialog(context:context,
  //       title: StringFile.opps,
  //       description: "Falha ao salvar forma de pagamento ${result.error}",
  //       iconData: Icons.error_outline,
  //       positiveCallback: () {},
  //       positiveText: StringFile.ok);
  // }
  // }

  Future<void> removePayment(BuildContext context, Wallet wallet) async {
    showLoading(true);
    var result = await _repository.deleteWallet(wallet);
    showLoading(false);
    if (result.error == null) {
      myPayment.sink.add(Wallet());
      getListWallet();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  void deleteWallet(
      BuildContext context, Wallet wallet, VoidCallback positive) {
    showGenericDialog(
        context: context,
        title: StringFile.aviso,
        description: StringFile.desejaDelatarPagamento,
        iconData: Icons.error_outline,
        positiveCallback: () {
          positive();
        },
        negativeCallback: () {},
        positiveText: StringFile.ok);
  }

  @override
  void dispose() {
    listWalletInfo?.drain();
    myPayment?.drain();
    pageBuilderIndex?.drain();
    myPaymentEdit.drain();
    hideListWallet.drain();
    _listTempWallet.clear();
    oneWalletSubject.drain();
    editAddress.drain();
  }

  Future<void> getOneWallet() async {
    var result = await _repository.getOneWallet();
    oneWalletSubject.sink.add(result);
  }
}
