import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import '../../app_bloc.dart';
import '../custom_drop_menu.dart';


void showChangeUrlDialog(BuildContext _context,
    {ValueChanged<String> positiveCallback}) {
  showDialog(
    context: _context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return _ChangeUrlDialog(
        positiveCallback: positiveCallback,
      );
    },
  );
}

class _ChangeUrlDialog extends StatelessWidget {
  final ValueChanged<String> positiveCallback;
  final serverFirebase = TextEditingController();
  final serverInterno = TextEditingController();
  final appBloc = Modular.get<AppBloc>();

  _ChangeUrlDialog({
    this.positiveCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width > 450
                    ? 400
                    : MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: Material(
                    color: Colors.white,
                    child: ListBody(children: <Widget>[
                      Container(
                          color: AppThemeUtils.colorPrimary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 0),
                                child: Icon(
                                  Icons.cleaning_services,
                                  color: AppThemeUtils.whiteColor,
                                  size: 50,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 0, bottom: 10),
                                  child: Text(
                                    "Servidores e talz",
                                    style: AppThemeUtils.normalBoldSize(
                                        color: AppThemeUtils.whiteColor,
                                        fontSize: 22),
                                  )),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Colors.white, width: 1),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: CustomDropMenuWidget(
                                  title: "Servidor do firebase",
                                  listElements: [
                                    Pairs("DEVELOPMENT", "DEVELOPMENT"),
                                    Pairs("HOMOLOGATION", "HOMOLOGATION"),
                                    Pairs("PRODUCTION", "PRODUCTION")
                                  ],
                                  controller: serverFirebase,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: CustomDropMenuWidget(
                                  title: "Servidor de requisição ",
                                  listElements: [
                                    Pairs("http://3.231.220.12:3000",
                                        "DEVELOPMENT"),
                                    Pairs("http://3.94.99.113:3000",
                                        "HOMOLOGATION"),
                                    Pairs("http://3.236.80.183:3000",
                                        "PRODUCTION")
                                  ],
                                  controller: serverInterno,
                                ),
                              ),
                              Container(
                                height: 60,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          width: 100,
                                          height: 45,
                                          margin: EdgeInsets.all(10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: AppThemeUtils
                                                    .colorError,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(5)))),

                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Cancelar',
                                              style: AppThemeUtils.normalSize(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        child: Container(
                                          width: 100,
                                          height: 45,
                                          margin: EdgeInsets.all(10),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Theme
                                                    .of(context)
                                                    .primaryColor,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(5))),),
                                              onPressed: () {
                                                Navigator.pop(context);

                                                bool _validURL =
                                                    Uri
                                                        .parse(
                                                        serverInterno.text)
                                                        .isAbsolute;
                                                if (_validURL ||
                                                    serverInterno.text != "") {
                                                  if (serverInterno.text !=
                                                      "") {
                                                    appBloc.serverInterno(
                                                        value: serverInterno
                                                            .text);
                                                  } else {
                                                    appBloc.serverInterno(
                                                        value: serverInterno
                                                            .text);
                                                  }
                                                  if (serverFirebase.text !=
                                                      "") {
                                                    appBloc.serverFirebase(
                                                        value: serverFirebase
                                                            .text);
                                                  } else {
                                                    appBloc.serverFirebase(
                                                        value: null);
                                                  }
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text(
                                                'Confirmar',
                                                style: AppThemeUtils.normalSize(
                                                    color: Colors.white),
                                              )
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          )),
                    ])))));
  }
}
