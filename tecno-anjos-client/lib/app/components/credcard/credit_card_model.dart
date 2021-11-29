
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';

class CreditCardModel {
  String cpfCode;

  MyAddress address;

  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName,
      this.cvvCode, this.isCvvFocused, this.apelido,this.address);

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String apelido = '';
  bool isCvvFocused = false;
}
