import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/card_web_with_title.dart';
import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/client_wallet/page/detail_client_wallet_page.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'client_wallet_bloc.dart';

class ClientWalletPage extends StatelessWidget {
  final _blocClientWallet = Modular.get<ClientWalletBloc>();

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: bodyTecnoanjos(),
      childWeb: CardWebWithTitle(child: bodyTecnoanjos()),
    );
  }

  Widget bodyTecnoanjos() {
    return builderComponentSimple<ResponsePaginated>(
      stream: _blocClientWallet.listClientWalletStream,
      emptyMessage: StringFile.semCarteiradeCLiente,
      initCallData: () => _blocClientWallet.getListClientWallet(),
      tryAgain: () {
        _blocClientWallet.getListClientWallet();
      },
      buildBodyFunc: (context, response) {
        if ((response.content ?? []).isEmpty) {
          return SingleChildScrollView(
              child: Column(children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    imageWithBgWidget(context, ImagePath.imageAureula),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30),
                        child: Text(
                          StringFile.informeOcodigo,
                          style: AppThemeUtils.normalSize(fontSize: 20),
                          textAlign: TextAlign.center,
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      margin: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: TextField(
                        onChanged: _blocClientWallet.codTecnoanjo.add,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            labelText: StringFile.codigoDoTecnoAnjo,
                            border: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 0.3),
                            )),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<String>(
                    stream: _blocClientWallet.codTecnoanjo.stream,
                    initialData: "",
                    builder: (context, snapshot) =>
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 45,
                            margin: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: snapshot.data.isEmpty
                                      ? AppThemeUtils.lightGray
                                      : Theme
                                      .of(context)
                                      .primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                  )),
                              onPressed: snapshot.data.isEmpty
                                  ? null
                                  : () {
                                _blocClientWallet.saveCodClient(
                                    context, snapshot.data);
                              },
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                              child: Text(
                                StringFile.vincular,
                                style: TextStyle(color: Colors.white,
                                    fontSize: 16),
                              ),

                            )))
              ]));
        } else {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height - 100,
            width: MediaQuery
                .of(context)
                .size
                .width,

            child: DetailClientWalletPage(response.content.first),
          );
        }
      },
    );
  }
}
