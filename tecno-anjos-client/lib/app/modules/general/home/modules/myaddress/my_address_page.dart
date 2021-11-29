import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';

import 'mobile/my_address_mobile_widget.dart';
import 'my_address_bloc.dart';

class MyAddressPage extends StatefulWidget {
  final bool back;
  final bool dismissaAllOnsave;
  final bool removeBar;
  final Function(MyAddress) selectedItem;

  MyAddressPage(
      {this.back = false,
      this.dismissaAllOnsave: false,
      this.selectedItem,
      this.removeBar = true});

  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  var myAddressBloc = Modular.get<MyAddressBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.selectedItem != null) {
      widget.selectedItem(myAddressBloc.selectedAddress.stream.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
        enableBack: widget.back,
        enableBar: widget.removeBar,
        childMobile: MyAddressMobileWidget(
            isSimpleNotDismissable: widget.back,
            dismissaAllOnsave: widget.dismissaAllOnsave,
            selectedItem: widget.selectedItem),
        childWeb: MyAddressMobileWidget(
            isSimpleNotDismissable: widget.back,
            dismissaAllOnsave: widget.dismissaAllOnsave,
            selectedItem: widget.selectedItem));
  }
}
