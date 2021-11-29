import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/components/card_web_with_title.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/address/address_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/address/widget/mobile/address_mobile_page_widget.dart';


Widget addressWebPageWidget(
    BuildContext context, AddressBloc addressBloc, bool hidePrefix,String cep) {
  return CardWebWithTitle(child:  Container(
      height: MediaQuery.of(context).size.height,
      child: AddressMobileContentWidget(addressBloc, hidePrefix,(v){},cep: cep,)));
}

