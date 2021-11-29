import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/models/pairs.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';
import '../title_description_checkbox.dart';

var _isOpen = false;

void showAlterGender({Function positiveCallback}) {
  if (!_isOpen) {
    _isOpen = true;
    Modular.to
        .push(PageRouteBuilder(pageBuilder: (___, _, __) => _DialogGeneric()));
  }
}

class _DialogGeneric extends StatelessWidget {
  final profileBloc = Modular.get<ProfileBloc>();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return Center(
      child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width > 450
                  ? 400
                  : MediaQuery.of(context).size.width * 0.8,
              child: Material(
                color: Colors.white,
                child: ListBody(
                  children: <Widget>[
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
                                Icons.recent_actors,
                                color: AppThemeUtils.whiteColor,
                                size: 50,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 0, bottom: 10),
                                child: Text(
                                  "Dados cadastrais",
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 200,
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              child: StreamBuilder<Pairs>(
                                  stream: profileBloc.genderList.stream,
                                  initialData: ProfileBloc.constantValues,
                                  builder: (context, snakpshot) {
                                    var pairsListGender = snakpshot.data;
                                    return getTitleDescriptionOptions(
                                        context,
                                        "Sexo",
                                        pairsListGender.first,
                                        pairsListGender.second, (listRes) {
                                      if (listRes.isEmpty) {
                                        pairsListGender.second = [];
                                        profileBloc.genderList.sink
                                            .add(pairsListGender);
                                      } else {
                                        pairsListGender.second = [
                                          listRes.first
                                        ];
                                        profileBloc.genderList.sink
                                            .add(pairsListGender);
                                      }
                                    });
                                  })),
                          lineViewWidget(),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                StreamBuilder<Pairs>(
                                    stream: profileBloc.genderList.stream,
                                    initialData: ProfileBloc.constantValues,
                                    builder: (context, snakpshot) {
                                      var pairsListGender = snakpshot.data;
                                      return Container(
                                        margin: EdgeInsets.only(
                                            right: 10,
                                            left: 10,
                                            bottom: 10,
                                            top: 5),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  AppThemeUtils.colorPrimary,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                            ),
                                            onPressed: () {
                                              if (pairsListGender
                                                      .second.length >
                                                  0) {
                                                profileBloc.editFieldProfile(
                                                    "gender",
                                                    pairsListGender
                                                        .second.first.first,
                                                    context, () {
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                            },
                                            child: Text(
                                              StringFile.Atualizar,
                                              style:
                                                  AppThemeUtils.normalBoldSize(
                                                color: AppThemeUtils.whiteColor,
                                              ),
                                            )),
                                      );
                                    }),
                                lineViewWidget(),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 10, left: 10, bottom: 10, top: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: AppThemeUtils.colorError,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          side: BorderSide(
                                              color: AppThemeUtils.colorError,
                                              width: 1)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      StringFile.Cancelar,
                                      style: AppThemeUtils.normalBoldSize(
                                        color: AppThemeUtils.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
