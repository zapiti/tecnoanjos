import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/pages/widget/myAddress_bottom_sheet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/pages/widget/new_my_address_mobile_widget.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../my_address_bloc.dart';


class AddressCreateWidget extends StatefulWidget {
  final Function(MyAddress) selectedItem;
  final String fileTitleEndereco;

  AddressCreateWidget({this.selectedItem,this.fileTitleEndereco});

  @override
  _AddressCreateWidgetState createState() => _AddressCreateWidgetState();
}

class _AddressCreateWidgetState extends State<AddressCreateWidget> {
  var myAddressBloc = Modular.get<MyAddressBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.selectedItem(myAddressBloc.selectedAddress.stream.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:  StreamBuilder<MyAddress>(
                stream: myAddressBloc.selectedAddress,
                builder: (context, snapshot) => snapshot.data == null
                    ?  ProgressHUD(
                            child: NewAddressMobileWidget(
                                isSimpleNotDismissable: true,hasScroll: true,hideSave:true,
                                selectedItem: widget.selectedItem))
                    : BaseListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: AppThemeUtils.colorPrimary,
                        ),
                        title: 'Local',myTitle: widget.fileTitleEndereco,
                        subtitle: snapshot.data?.myAddress ??
                            "Adicione um endereço para continuar",
                        trailing: GestureDetector(
                          child: Text(
                            snapshot.data?.postal == null
                                ? "Adicionar"
                                : 'Trocar',
                            style: TextStyle(
                              color: AppThemeUtils.colorPrimary,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {

                            showBottomSheetMyAddress(context,
                                    (address) {
                                      widget.selectedItem(address);

                                });

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => MyAddressPage(
                            //           back: true, dismissaAllOnsave: true,)),
                            // ).then((value) {
                            //
                            // });
                          },
                        ),
                      )));
  }
}

class BaseListTile extends StatelessWidget {
  final String myTitle;
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;

  BaseListTile({
    this.title,
    this.subtitle,
    this.leading,this.myTitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
            child: Text(
              myTitle ??  "Endereço principal",
              style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.colorPrimary, fontSize: 16),
            )),
        Card(
            child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: leading,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: AppThemeUtils.normalSize(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                      ),
                      Text(
                        subtitle,
                        style: AppThemeUtils.normalSize(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: trailing,
              )
            ],
          ),
        ))
      ],
    );
  }
}
