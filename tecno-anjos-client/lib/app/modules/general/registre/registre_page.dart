import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/login/bloc/login_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/registre/registre_bloc.dart';


import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../../app_bloc.dart';
import 'widget/pass/pass_registre_page.dart';

class RegistrePage extends StatefulWidget {
  @override
  _RegistrePageState createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  var index = 0;
  final appBloc = Modular.get<AppBloc>();
  var loginBloc = Modular.get<LoginBloc>();
  var registreBloc = Modular.get<RegistreBloc>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    appBloc.currentContext.sink.add(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(StringFile.bemvindoATecnoANjo,style: AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
        ),
        body: WillPopScope(
            onWillPop: () async {
              if (index == 0) {
                registreBloc.controllerTelefone.clear();
                registreBloc.controllerEmail.clear();
                registreBloc.controllerConfirmTelefone.clear();
                registreBloc.controllerEmail.clear();
                //    registreBloc.tempRegisterUser.sink.add(RegistreUser());
                return true;
              } else {
                setState(() {
                  index -= 1;
                });
                return false;
              }
            },
            child: Material(
                child: Container(
                    color: Colors.white,
                    child: PassRegistrePage(() {
                      registreBloc.changeAction(context);
                    },bottom:   Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    margin: EdgeInsets.symmetric(
                        horizontal: 25, vertical: 0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        onPressed: () {
                          registreBloc.changeAction(
                              context);
                        },
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                        child: Text(
                          "Cadastrar",
                          style: TextStyle(
                              color: Colors.white, fontSize: 16),
                        ))),)))));
  }

  Widget bottomChangeView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index >= 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]),
        ),
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index >= 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]),
        ),
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index >= 2
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]),
        ),
        // Container(
        //   width: 12,
        //   height: 12,
        //   margin: EdgeInsets.all(3),
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: index >= 3
        //           ? Theme.of(context).primaryColor
        //           : Colors.grey[300]),
      ],
    );
  }


}
