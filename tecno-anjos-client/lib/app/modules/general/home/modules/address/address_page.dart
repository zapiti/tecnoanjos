import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/widget/mobile/address_mobile_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/widget/web/address_web_page_widget.dart';

import 'address_bloc.dart';

class AddressPage extends StatelessWidget {
  final AddressBloc addressBloc = Modular.get<AddressBloc>();
  final String cep;

  AddressPage(this.cep);

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: addressMobilePageWidget(addressBloc, true, cep: cep),
      childWeb: addressWebPageWidget(context, addressBloc, true, cep),
    );
  }
}
