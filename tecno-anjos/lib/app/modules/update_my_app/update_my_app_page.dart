

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class UpdateMyAppPage extends StatefulWidget {
  final String title;

  const UpdateMyAppPage({Key key, this.title = "UpdateMyApp"})
      : super(key: key);

  @override
  _UpdateMyAppPageState createState() => _UpdateMyAppPageState();
}

class _UpdateMyAppPageState extends State<UpdateMyAppPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Modular.get<FirebaseClientTecnoanjo>().getActualVersion(),
        builder: (ctx, snapshot) => snapshot?.data == null
            ? SizedBox()
            : "${snapshot?.data?.data() == null ? Flavor.I.getString(actualVersion) : snapshot?.data?.data()[Flavor.I.getString(firebaseKey)]['tecnico'] ?? ""}" ==
            Flavor.I.getString(actualVersion)
            ? SizedBox()
            : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(""),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme:
              IconThemeData(color: AppThemeUtils.colorPrimary),
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset(
                                  ImagePath.icUpload,
                                  height: 200,
                                ),
                                Flavor.I.getString(firebaseKey) == "PRODUCTION"
                                    ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 30),
                                    child: Text(
                                      "Seu aplicativo ainda não esta pronto para uso clique no botão abaixo e baixe a versão de homologação"
                                      ,style: AppThemeUtils.normalBoldSize(),textAlign: TextAlign.center,))
                                    : Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 30),
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: "",
                                          style: AppThemeUtils.normalSize(
                                              color: AppThemeUtils.black,
                                              fontSize: 18),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                "Seu aplicativo esta desatualizada, versão atual",
                                                style: AppThemeUtils
                                                    .normalSize(
                                                    fontSize: 18)),
                                            TextSpan(
                                                text:
                                                " ${Flavor.I.getString(actualVersion)} ",
                                                style: AppThemeUtils
                                                    .normalBoldSize(
                                                    fontSize: 18,
                                                    color: AppThemeUtils
                                                        .colorPrimary)),
                                            TextSpan(
                                                text: "versão mais recente",
                                                style: AppThemeUtils
                                                    .normalSize(
                                                    fontSize: 18)),
                                            TextSpan(
                                                text:
                                                " ${snapshot?.data?.data() == null ? "indisponível" : snapshot?.data?.data()[Flavor.I.getString(firebaseKey)]['tecnico'] ?? ""} ",
                                                style: AppThemeUtils
                                                    .normalBoldSize(
                                                    fontSize: 18,
                                                    color: AppThemeUtils
                                                        .colorPrimary)),
                                            TextSpan(
                                                text:
                                                "para que você tenha melhor experiência  toque no botão abaixo e atualize o aplicativo.",
                                                style: AppThemeUtils
                                                    .normalSize(
                                                    fontSize: 18)),
                                          ],
                                        ))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            padding: EdgeInsets.all(20),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  _launchURL(snapshot?.data
                                                      ?.data()[
                                                  Flavor.I.getString(
                                                      firebaseKey)][Platform.isIOS ? "urlIosTec":'urlTec']);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: AppThemeUtils
                                                        .colorPrimary,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                        side: BorderSide(
                                                            color: AppThemeUtils
                                                                .colorPrimary))),
                                                child: Container(
                                                    height: 45,
                                                    child: Center(
                                                        child: Text(
                                                          "Atualizar agora",
                                                          style: AppThemeUtils
                                                              .normalSize(
                                                              color: AppThemeUtils
                                                                  .whiteColor),
                                                        )))))),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ])))
                ])));
  }
}

_launchURL(url) async {
  // const url =
  //     'https://play.google.com/store/apps/details?id=br.com.awscode.tecnoanjostec';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
