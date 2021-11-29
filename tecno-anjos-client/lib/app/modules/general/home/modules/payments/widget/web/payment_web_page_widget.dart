import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/card_web_with_title.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/payments/widget/mobile/payment_mobile_page_widget.dart';
import '../../payments_bloc.dart';



Widget paymentWebPageWidget(BuildContext context,PaymentsBloc paymentsBloc) {
  return CardWebWithTitle(child:  Container(
      height: MediaQuery.of(context).size.height,
      child: paymentMobilePageWidget(paymentsBloc)));
}