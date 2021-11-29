import 'dart:io';

import 'package:flavor/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../main.dart';
import '../app_bloc.dart';
import 'load/load_elements.dart';

class LoadViewElement extends StatelessWidget {
  final appBloc = Modular.get<AppBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: appBloc.loadElement.stream,
      initialData: false,
      builder: (context, snapshot) => AbsorbPointer(
          absorbing: snapshot.data,
          child: Stack(children: [
            SizedBox(),
            Container(
                child: snapshot.data
                    ? Stack(
                        children: [
                          Container(
                            color: AppThemeUtils.colorPrimary,
                            height: MediaQuery.of(context).size.height,
                          ),
                          kIsWeb
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    loadElements(context,
                                        color: AppThemeUtils.whiteColor),
                                    Text(
                                      "Carregando...",
                                      style: AppThemeUtils.normalBoldSize(
                                          color: AppThemeUtils.whiteColor),
                                    )
                                  ],
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView(
                                    children: [
                                      Image.asset(
                                        ImagePath.loadElement,
                                      ),
                                    ],
                                  ))
                        ],
                      )
                    : SizedBox()),
            FutureBuilder<String>(
              future: appBloc.serverInterno(),
              builder: (context, snapshotServer) => snapshotServer.data == null
                  ? SizedBox()
                  : SizedBox(
                      child: FutureBuilder<String>(
                          future: appBloc.serverFirebase(),
                          builder: (context, snapshotFirebase) => Material(
                              child: SafeArea(
                                  child: Text(
                                      "${snapshotServer.data ?? ""} (${snapshotFirebase.data ?? ""})")))),
                    ),
            ),
            Flavor.I.getString(firebaseKey) == "PRODUCTION"
                ? SizedBox()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      child: Container(
                          width: MediaQuery.of(context).size.width,padding: EdgeInsets.only(bottom: Platform.isIOS ? 15 : 0),
                          color: AppThemeUtils.colorPrimary,
                          child: Text(
                            "${Flavor.I.getString(firebaseKey)} ${Flavor.I.getString(actualVersion)}",
                            textAlign: TextAlign.center,
                            style: AppThemeUtils.normalSize(
                                fontSize: 12, color: AppThemeUtils.whiteColor),
                          )),
                    ))
          ])),
    );
  }
}
