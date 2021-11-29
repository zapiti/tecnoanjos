import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../payments_bloc.dart';
import '../payment_builder.dart';

Widget paymentMobilePageWidget(PaymentsBloc paymentBloc) {
  return PaymentBuilder().buildBodyPayment(paymentBloc);
}
