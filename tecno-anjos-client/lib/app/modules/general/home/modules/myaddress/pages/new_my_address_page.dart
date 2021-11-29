


import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/pages/widget/new_my_address_mobile_widget.dart';


class NewAddressPage extends StatefulWidget {
  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
        childMobile: NewAddressMobileWidget(hasScroll: true,),
        childWeb: NewAddressMobileWidget(hasScroll: true,));
  }
}