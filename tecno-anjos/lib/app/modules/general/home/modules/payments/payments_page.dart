import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/payments_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/widget/mobile/payment_mobile_page_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/widget/web/payment_web_page_widget.dart';


class PaymentsPage extends StatelessWidget {
  final _paymentBloc = Modular.get<PaymentsBloc>();

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: paymentMobilePageWidget(_paymentBloc),
      childWeb: paymentWebPageWidget(context,_paymentBloc),
    );
  }
}
