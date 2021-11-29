import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../address_bloc.dart';

class AddressItemListWidget extends StatelessWidget {
  final MyAddress address;

  final TabController tabController;
  final bool hidePrefix;
  final Function selectedItem;
  final Function actionEdit;

  AddressItemListWidget(this.address, this.tabController, this.hidePrefix,
      {this.selectedItem, this.actionEdit});

  final addressBloc = Modular.get<AddressBloc>();

  @override
  Widget build(BuildContext context) {
    if (!hidePrefix && addressBloc?.myAddress?.stream?.value?.id == null) {
      addressBloc.myAddress.sink.add(address);
      selectedItem(address);
    }
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: titleDescriptionBigMobileWidget(context,
                title: address.title == null
                    ? "--"
                    : address.title == ""
                        ? "--"
                        : address.title ?? "--",
                padding: 0,
                description: Utils.addressFormatMyData(address),
                maxLine: 1, action: () {
              addressBloc.myAddress.sink.add(address);
              selectedItem(address);
            },
                prefix: hidePrefix
                    ? null
                    : StreamBuilder<MyAddress>(
                        initialData: MyAddress(),
                        stream: addressBloc.myAddress.stream,
                        builder: (context, snapshot) => Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: snapshot?.data?.id == address?.id
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppThemeUtils.colorPrimary,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.grey[300],
                                  ))),
                customIcon: Flex(
                  direction: Axis.vertical,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: AppThemeUtils.greenGC,
                        ),
                        onPressed: () {
                          if (actionEdit != null) {
                            actionEdit();
                          }
                          addressBloc.myAddress.add(address);
                          tabController?.animateTo(1);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AppThemeUtils.colorError,
                        ),
                        onPressed: () {
                          addressBloc.removeAddress(context, address);
//                          addressBloc.deleteAddress(context, address, () {
//
//                          });
                        }),
                  ],
                ))),
        lineViewWidget()
      ],
    ));
  }
}
