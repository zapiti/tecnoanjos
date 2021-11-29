import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjos_franquia/app/modules/payment/widget/payment_widget.dart';

class PaymentPage extends StatefulWidget {


  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: PaymentWidget(),
      childWeb: PaymentWidget(),
    );
  }
}
