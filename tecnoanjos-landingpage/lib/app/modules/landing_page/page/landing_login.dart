import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:tecno_anjos_landing/app/components/build_bottom_landing_page.dart';


import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navbar/navigation_drawer.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navigation_bar/navigation_bar.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_file.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_landingpage_file.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';

import '../landing_page_bloc.dart';


class LandingLogin extends StatelessWidget {
  var bloc = Modular.get<LandingPageBloc>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 2048,
            ),
            child:  LayoutBuilder(builder: (context, constraint) {
              return Scaffold(
                  drawer: constraint.maxWidth <= 800
                      ? Modular.get<NavigationDrawer>()
                      : null,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        NavigationBar(inverseColor: true),
                        Center(
                          child: Container(
                            width: 400,
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: Text(
                                      StringLandingPageFile.vamosComecar,
                                      style: AppThemeUtils.normalBoldSize(
                                          fontSize: 25),
                                    )),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: Text(
                                    StringLandingPageFile.digitePraEntra,
                                      style: AppThemeUtils.normalSize(
                                          fontSize: 16),
                                    )),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  margin: EdgeInsets.symmetric(vertical: 12),
                                  child: TextField(inputFormatters: [
                                                        LengthLimitingTextInputFormatter(80),],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: StringLandingPageFile.celularEmail,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.3),
                                        )),
                                    onChanged: bloc.userNameValue.add,
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: StreamBuilder<bool>(
                                        stream: bloc.showPass.stream,
                                        initialData: false,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshotHide) {
                                          return TextField(inputFormatters: [
                                                        LengthLimitingTextInputFormatter(80),],
                                              obscureText: snapshotHide.data,
                                              onChanged: bloc.passwordValue.add,
                                              textAlign: TextAlign.start,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  labelText: StringFile.senha,
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      snapshotHide.data
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: AppThemeUtils
                                                          .colorPrimary,
                                                    ),
                                                    onPressed: () {
                                                      bloc.showPass
                                                          .add(!snapshotHide.data);
                                                    },
                                                  ),
                                                  border:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.3),
                                                  )));
                                        })),
                                SizedBox(height: 25),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: RaisedButton(
                                    color: AppThemeUtils.colorPrimary,
                                    onPressed: () {
                                      bloc.login(context);
                                    },
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                    child: Container(
                                        margin: EdgeInsets.all(20),
                                        child: Text(
                                          StringFile.entrar,
                                          style: GoogleFonts.roboto(
                                              color: AppThemeUtils.colorPrimary,
                                              fontSize: 16),
                                        )),
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                                SizedBox(height: 50),

                              ],
                            ),
                          ),
                        ),    buildBottomTecno(context),
                      ],
                    ),
                  ));
            })));
  }
}
