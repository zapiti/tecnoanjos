import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/widget/mobile/address_mobile_page_widget.dart';

import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'address_bloc.dart';

class AddressSearchPage extends StatelessWidget {
  final AddressBloc addressBloc = Modular.get<AddressBloc>();
  final String cep;
  AddressSearchPage(this.cep);

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: Scaffold(
          appBar: AppBar(
            title:
                Text(ConstantsRoutes.getNameByRoute(ConstantsRoutes.ENDERECOS)),
            centerTitle: true,
          ),
          body: addressMobilePageWidget(addressBloc, false,cep:cep,
              addressSave: (addressSave) {
            Navigator.pop(context, addressSave);
          }, selectedItem: (addressSave) {})),
      enableBar: false,
      childWeb: Scaffold(
          appBar: AppBar(
            title:
                Text(ConstantsRoutes.getNameByRoute(ConstantsRoutes.ENDERECOS)),
            centerTitle: true,
          ),
          body: addressMobilePageWidget(addressBloc, false,cep:cep,
              addressSave: (addressSave) {
            Navigator.pop(context, addressSave);
          }, selectedItem: (addressSave) {})),
    );
  }
}
