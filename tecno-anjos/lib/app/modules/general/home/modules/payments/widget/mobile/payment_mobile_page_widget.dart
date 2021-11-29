import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/payments_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/widget/payment_builder.dart';

Widget paymentMobilePageWidget(PaymentsBloc paymentBloc) {
  return PaymentBuilder().buildBodyPayment(paymentBloc);
}
