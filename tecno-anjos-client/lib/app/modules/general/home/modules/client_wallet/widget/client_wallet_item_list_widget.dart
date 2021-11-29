
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/client_wallet/models/client_wallet.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ClientWalletItemListWidget extends StatefulWidget {
  final ClientWallet clientWallet;

  ClientWalletItemListWidget(this.clientWallet);

  @override
  _ClientWalletItemListWidgetState createState() =>
      _ClientWalletItemListWidgetState();
}

class _ClientWalletItemListWidgetState
    extends State<ClientWalletItemListWidget> {
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Container(
            margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 50,
                  height: 45,
                  color: Colors.grey[200],
                  child: Image.network((widget.clientWallet.imagemUrl ?? ""),fit: BoxFit.fill,

                    // placeholder: (context, url) =>
                    //     new CircularProgressIndicator(),
                    // errorWidget: (context, url, error) => new Icon(Icons.error_outline),
                  ),
                ))),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleDescriptionBigMobileWidget(
              context,
              title: widget.clientWallet.name,
              padding: 20,
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Text(
                StringFile.telefone,
                style: AppThemeUtils.normalSize(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Text(
                widget.clientWallet.telephone ?? "",
                style: AppThemeUtils.normalSize(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Text(
               StringFile.email,
                style: AppThemeUtils.normalSize(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Text(
                widget.clientWallet.email ?? "--",
                style: AppThemeUtils.normalSize(),
              ),
            ),
            lineViewWidget()
          ],
        ))
      ],
    ));
  }
}
