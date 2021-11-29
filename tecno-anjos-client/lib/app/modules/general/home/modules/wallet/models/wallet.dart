
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/payments/models/payment.dart';

import 'package:tecnoanjosclient/app/utils/utils.dart';

class Wallet {
  String number;
  String verificationValue;
  String holderName;
  String month;
  String year;
  String description;
  String id;
  String brand;
  MyAddress myAddress;
  String holderCpf;
  String cvvExpDate;
  bool main;
  String pagarmeCardId;

  Wallet({this.number,
    this.verificationValue,
    this.month,
    this.myAddress,
    this.holderCpf,
    this.cvvExpDate, this.pagarmeCardId,
    this.year, this.main,
    this.description,
    this.id,
    this.holderName,
    this.brand});

  Map<String, dynamic> toMap() {
    return this.id == null
        ? {
      "description": this.description,
      "card": {
        "number": this.number?.replaceAll(" ", ""),
        "verification_value": this.verificationValue,
        "name": this.holderName,
        "cpf": Utils.removeMask(this.holderCpf),
        "month": this.month,
        "year": this.year,
      },
      "address": {"addressId": myAddress?.id}
    }
        : {
      "id": this.id,
      "description": this.description,
      "setAsDefault": true,
      "card": {
        "number": this.number?.replaceAll(" ", ""),
        "verification_value": this.verificationValue,
        "name": this.holderName,
        "cpf": Utils.removeMask(this.holderCpf),
        "month": this.month,
        "year": this.year
      },
      "address": {"addressId": myAddress?.id}
    };
  }

  factory Wallet.fromMap(dynamic map) {
    if (null == map) return null;


    return Wallet(
        brand: map['brand']?.toString(),
        number: "••••" + map['lastDigits']?.toString(),
        verificationValue: map['verification_value']?.toString(),
        cvvExpDate: map['cvvExpDate']?.toString(),
        holderName: map['holderName']?.toString(),
        month: map['expirtationDate']
            ?.toString()
            ?.split("/")
            ?.first
            ?.toString(),
        year: map['expirtationDate']
            ?.toString()
            ?.split("/")
            ?.last
            ?.toString(),
        description: map['description']?.toString(),
        pagarmeCardId: map['pagarmeCardId']?.toString(),
        id: map['id']?.toString(),
        main: map["main"] as bool);
  }

  static Wallet fromMapPayment(Payment paymentMethod) {
    return Wallet(id: paymentMethod?.paymentMethodId,pagarmeCardId:  paymentMethod?.paymentMethodId);
  }

  toMapCreate() {
    return {
      "description": description,
      "cardNumber": Utils.removeMask(number),
      "cvv": verificationValue,
      "holderName": holderName,
      "holderCpf": holderCpf,
      "expirationDate": month + year,
      "main": main ?? true,
      "address": myAddress.toMap()
    };
  }
}
