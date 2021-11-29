import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/client_wallet/client_wallet_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/client_wallet/models/client_wallet.dart';

import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class MakeAvaliationPage extends StatefulWidget {
  final Attendance attendance;

  MakeAvaliationPage(this.attendance);

  @override
  _MakeAvaliationPageState createState() => _MakeAvaliationPageState();
}

class _MakeAvaliationPageState extends State<MakeAvaliationPage> {

  double hatting;
  String resenha;


  var startBloc = Modular.get<StartCalledBloc>();

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: bodyAvaliation(context),
      childWeb: bodyAvaliation(context),
      enableBar: false,
    );
  }

  Scaffold bodyAvaliation(BuildContext context) {
    return Scaffold(
        backgroundColor: AppThemeUtils.whiteColor,
        appBar: AppBar(
          title: Text(
            StringFile.avalieAtendimento,
            style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .viewInsets
                                    .bottom),
                            child: Material(
                              color: Colors.white,
                              child: ListBody(
                                children: <Widget>[
                                  Center(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5,
                                              left: 5,
                                              right: 5,
                                              bottom: 5),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(100.0),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[200],
                                                child: Image.network(
                                                  (widget.attendance?.userTecno
                                                      ?.pathImage ??
                                                      ""),
                                                  fit: BoxFit.fill,

                                                ),
                                              )))),
                                  Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.all(15),
                                      child: Center(
                                          child: Text(
                                            widget.attendance?.userTecno
                                                ?.name ?? "",
                                            style: AppThemeUtils.normalBoldSize(
                                                fontSize: 20,
                                                color: AppThemeUtils
                                                    .colorPrimary),
                                          ))),
                                  Container(
                                      width: double.infinity,
                                      child: Center(
                                          child: RatingBar(
                                            initialRating: 5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            ratingWidget: RatingWidget(
                                                full: Icon(
                                                  Icons.star,
                                                  color: AppThemeUtils
                                                      .colorPrimary,
                                                ),
                                                half: Icon(
                                                  Icons.star,
                                                  color: AppThemeUtils
                                                      .colorPrimary,
                                                ),
                                                empty: Icon(
                                                  Icons.star_border,
                                                  color: AppThemeUtils
                                                      .colorPrimary,
                                                )),
                                            onRatingUpdate: (rating) {
                                              hatting = (rating);
                                            },
                                          ))),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: TextField(
                                            keyboardType: TextInputType.text,
                                            onChanged: (text) {
                                              resenha = text;
                                            },
                                            decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                hintText: StringFile
                                                    .comoFoiSeuAtendimento,
                                                border: const OutlineInputBorder(
                                                  borderRadius: const BorderRadius
                                                      .all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.3),
                                                )),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                  Container(
                      height: 45,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin:
                      EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppThemeUtils.colorPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))), elevation: 0),

                          onPressed: () {
                            startBloc.evalueteAction(context,
                                hatting ?? 5.0, resenha ?? "",
                                widget.attendance);
                            Navigator.pop(context);
                          },
                          child: Text(
                            StringFile.enviarAvaliacao,
                            style: AppThemeUtils.normalBoldSize(
                              color: AppThemeUtils.whiteColor,
                            ),
                          ))),

                  bodyFavorite(widget.attendance)
                ])));
  }


}

bodyFavorite(Attendance attendance) {
  final _blocClientWallet = Modular.get<ClientWalletBloc>();
  return builderComponentSimple<ResponsePaginated>(
      stream: _blocClientWallet.listClientWalletStream,
      enableLoad: false,
      emptyMessage: StringFile.semCarteiradeCLiente,
      initCallData: () => _blocClientWallet.getListClientWallet(),
      tryAgain: () {
        _blocClientWallet.getListClientWallet();
      },
      buildBodyFunc: (context, response) {
        if ((response?.content ?? []).isEmpty) {
          return response?.content == null ? SizedBox() : Column(children: [
            Text("Gostou do atendimento?\nFavorite já seu Tecnoanjo",
              style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.colorPrimary),
              textAlign: TextAlign.center,),
            Container(
              height: 45,
              margin: EdgeInsets.only(
                  right: 20, left: 20, bottom: 0, top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: AppThemeUtils.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(
                            color: AppThemeUtils.whiteColor, width: 1))),

                onPressed: () {
                  _blocClientWallet.saveCodClient(
                      context, attendance.userTecno.tagTechnician);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppThemeUtils.whiteColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      StringFile.favoritar,
                      style: AppThemeUtils.normalBoldSize(
                          color: AppThemeUtils.whiteColor,
                          fontSize: 14),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            )
          ],);
        } else {
          var listFavorite = ObjectUtils.parseToObjectList<ClientWallet>(
              response?.content);
          ClientWallet clientWallet = listFavorite.first;
          return Column(children: [
            clientWallet?.id == attendance.userTecno?.id ? Icon(
              Icons.star, color: AppThemeUtils.colorPrimary,) : SizedBox(),
            Text(clientWallet?.id == attendance.userTecno?.id
                ? "Seu Tecnoanjo favorito"
                : "Você já possúi um Tecnoanjo favorito,"
                "\nDeseja substituir-lo pelo Tecnoanjo ",
              style: AppThemeUtils.normalSize(
                  color: AppThemeUtils.colorPrimary),
              textAlign: TextAlign.center,),
            clientWallet?.id == attendance.userTecno?.id ? SizedBox() : Text(
              "${attendance.userTecno?.name}?",
              style: AppThemeUtils.normalBoldSize(),),
            clientWallet?.id == attendance.userTecno?.id ? SizedBox() : Container(
              height: 45,
              margin: EdgeInsets.only(
                  right: 20, left: 20, bottom: 20, top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: AppThemeUtils.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(
                            color: AppThemeUtils.whiteColor, width: 1))),

                onPressed: () {
                  showLoading(true);
                  _blocClientWallet.removeTecno(context, clientWallet, () {
                    showLoading(false);
                    _blocClientWallet.saveCodClient(
                        context, attendance.userTecno.tagTechnician);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppThemeUtils.whiteColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      StringFile.favoritar,
                      style: AppThemeUtils.normalBoldSize(
                          color: AppThemeUtils.whiteColor,
                          fontSize: 14),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            )
          ],);
        }
      });
}