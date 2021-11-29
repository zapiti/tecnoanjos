import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/card_web_with_title.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/payments_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/widget/mobile/payment_mobile_page_widget.dart';


Widget paymentWebPageWidget(BuildContext context,PaymentsBloc paymentsBloc) {
  return CardWebWithTitle(child:  Container(
      height: MediaQuery.of(context).size.height,
      child: paymentMobilePageWidget(paymentsBloc)));
}