import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/components/card/card_web_widget.dart';

import 'package:tecnoanjos_franquia/app/modules/payment/widget/table/payment_table.dart';


class PaymentWidget extends StatefulWidget {
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return CardWebWidget(title: "Pagamentos",
      child: PaymentTable(),
    );
  }
}
