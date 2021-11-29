import 'package:tecnoanjos_franquia/app/components/simple_drop_menu.dart';
import 'package:tecnoanjos_franquia/app/components/tectfields/custom_textfield.dart';
import 'package:tecnoanjos_franquia/app/models/current_server.dart';

import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjos_franquia/app/components/page/default_tab_page.dart';

import 'package:tecnoanjos_franquia/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjos_franquia/app/modules/login/utils/security_preference.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/utils/image/image_path.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../app_module.dart';
import '../../components/load/load_elements.dart';
import '../../modules/login/bloc/login_bloc.dart';
import '../../utils/image/image_logo_widget.dart';
import '../../utils/theme/app_theme_utils.dart';

class LoginPage extends StatelessWidget {
  final bloc = Modular.get<LoginBloc>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: StreamBuilder(
              stream: bloc.isLoad,
              initialData: false,
              builder: (context, snapshot) {
                var _isLoadRequest = snapshot.data;
                return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 80, bottom: 30, right: 30, left: 30),
                                  height: 200,
                                  child: Center(child: getLogoIcon())),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 400,
                                color: Colors.transparent,
                                child: Center(
                                    child: Container(
                                  width: 400,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.only(
                                      bottom: 0, right: 15, left: 15, top: 15),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  child: Container(
                                                      color: AppThemeUtils
                                                          .whiteColor,
                                                      child: TextField(
                                                        enabled:
                                                            !_isLoadRequest,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: bloc
                                                            .loginUserController,
                                                        decoration:
                                                            InputDecoration(
                                                                labelText:
                                                                    "Usuário",
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .person_outline,
                                                                  size: 18,
                                                                  color: AppThemeUtils
                                                                      .colorPrimary,
                                                                ),
                                                                border:
                                                                    const OutlineInputBorder(
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          28.0)),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          0.3),
                                                                )),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12),
                                                    child: StreamBuilder<bool>(
                                                        stream: bloc
                                                            .showPass.stream,
                                                        initialData: false,
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    dynamic>
                                                                snapshot) {
                                                          return Container(
                                                              color: AppThemeUtils
                                                                  .whiteColor,
                                                              child: TextField(
                                                                  enabled:
                                                                      !_isLoadRequest,
                                                                  obscureText:
                                                                      snapshot
                                                                          .data,
                                                                  controller: bloc
                                                                      .loginPassController,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  onSubmitted:
                                                                      (text) {
                                                                    bloc.getLogin(
                                                                        context);
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                          labelText:
                                                                              "Senha",
                                                                          prefixIcon:
                                                                              Icon(
                                                                            Icons.lock_open,
                                                                            size:
                                                                                18,
                                                                            color:
                                                                                AppThemeUtils.colorPrimary,
                                                                          ),
                                                                          suffixIcon:
                                                                              IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              snapshot.data ? Icons.visibility : Icons.visibility_off,
                                                                              color: AppThemeUtils.colorPrimaryDark,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              bloc.showPass.sink.add(!snapshot.data);
                                                                            },
                                                                          ),
                                                                          border:
                                                                              const OutlineInputBorder(
                                                                            borderRadius:
                                                                                const BorderRadius.all(Radius.circular(28.0)),
                                                                            borderSide:
                                                                                BorderSide(color: Colors.grey, width: 0.3),
                                                                          ))));
                                                        })),
                                                // _isLoadRequest
                                                //     ? SizedBox()
                                                //     : Container(
                                                //         margin: EdgeInsets.only(top: 10, right: 10),
                                                //         child: Row(
                                                //           children: <Widget>[
                                                //             StreamBuilder(
                                                //                 stream: bloc.savePass.stream,
                                                //                 initialData: true,
                                                //                 builder: (context, snapshot) {
                                                //                   return Checkbox(
                                                //                     value: snapshot.data,
                                                //                     activeColor: Colors.grey[300],
                                                //                     checkColor:
                                                //                         Theme.of(context).primaryColor,
                                                //                     onChanged: (bool) =>
                                                //                         bloc.savePass.sink.add(bool),
                                                //                   );
                                                //                 }),
                                                //             Text(
                                                //               'Lembrar acesso',
                                                //               style: TextStyle(
                                                //                   fontSize: 14, color: Color(0xffA4A4A4)),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       ),
                                                SizedBox(height: 10),
                                                Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: _isLoadRequest
                                                      ? loadElements(context,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10))
                                                      : RaisedButton(
                                                          color: AppThemeUtils
                                                              .colorPrimary,
                                                          onPressed: () {
                                                            bloc.getLogin(
                                                                context);
                                                          },
                                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                                          child: Text(
                                                            'Entrar',
                                                            style: TextStyle(
                                                                color: AppThemeUtils
                                                                    .whiteColor,
                                                                fontSize: 16),
                                                          ),
                                                          shape: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          28)),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                        ),
                                                ),
                                                SizedBox(height: 25),
                                                // Container(
                                                //     margin:
                                                //         EdgeInsets.symmetric(
                                                //             horizontal: 30),
                                                //     alignment:
                                                //         Alignment.centerRight,
                                                //     child: FlatButton(
                                                //         onPressed: () {
                                                //           Modular.to.pushNamed(
                                                //               ConstantsRoutes
                                                //                   .RECOVERYPASS);
                                                //         },
                                                //         child: Text(
                                                //           "Esqueceu sua senha?",
                                                //           style: AppThemeUtils
                                                //               .smallSize(),
                                                //         ))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              )
                            ])));
              },
            )),
          )
        ]));
  }
}
