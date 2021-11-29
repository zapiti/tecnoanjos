import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/dialog/type_popup.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';

import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import '../title_description_checkbox.dart';

void showAlterGender(BuildContext myContext,
    {Function positiveCallback,
      TextEditingController controller,
      TextEditingController controllerNamed}) {
  TypePopup.show(child: _DialogGeneric(myContext, controller, controllerNamed));
}

class _DialogGeneric extends StatelessWidget {
  final profileBloc = Modular.get<ProfileBloc>();
  final BuildContext myContext;
  final TextEditingController controller;
  final TextEditingController controllerNamed;

  _DialogGeneric(this.myContext, this.controller, this.controllerNamed);

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
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: ListBody(children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(color: Colors.white, width: 0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                        color: AppThemeUtils.colorPrimary,
                                        border: Border.all(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20))),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5, left: 0),
                                          child: Icon(
                                            MaterialCommunityIcons
                                                .file_document_edit,
                                            color: AppThemeUtils.whiteColor,
                                            size: 30,
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            child: Text(
                                              StringFile.dadosCadastrais,
                                              style:
                                              AppThemeUtils.normalBoldSize(
                                                  color: AppThemeUtils
                                                      .whiteColor,
                                                  fontSize: 20),
                                            )),
                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.only(top: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(10),
                                          child: StreamBuilder<Pairs>(
                                              stream:
                                              profileBloc.genderList.stream,
                                              initialData:
                                              ProfileBloc.constantValues,
                                              builder: (context, snakpshot) {
                                                var pairsListGender =
                                                    snakpshot.data;
                                                return getTitleDescriptionOptions(
                                                    context,
                                                    StringFile.sexo,
                                                    pairsListGender.first,
                                                    pairsListGender.second,
                                                        (listRes) {
                                                      if (listRes.isEmpty) {
                                                        pairsListGender.second =
                                                        [];
                                                        profileBloc.genderList
                                                            .sink
                                                            .add(
                                                            pairsListGender);
                                                      } else {
                                                        pairsListGender.second =
                                                        [
                                                          listRes.first
                                                        ];
                                                        profileBloc.genderList
                                                            .sink
                                                            .add(
                                                            pairsListGender);
                                                      }
                                                    });
                                              })),
                                      lineViewWidget(),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: Center(
                                                    child: Container(
                                                        height: 45,
                                                        width: 200,
                                                        margin: EdgeInsets.only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 10,
                                                            top: 5),
                                                        child: Container(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                primary: AppThemeUtils
                                                                    .darkGrey,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            8)),
                                                                    side: BorderSide(
                                                                        color: AppThemeUtils
                                                                            .darkGrey,
                                                                        width: 1))),

                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              StringFile
                                                                  .cancelar,
                                                              style: AppThemeUtils
                                                                  .normalBoldSize(
                                                                color: AppThemeUtils
                                                                    .whiteColor,
                                                              ),
                                                            ),

                                                          ),
                                                        )))),
                                            Expanded(
                                                child: Center(
                                                    child: Container(
                                                        height: 45,
                                                        width: 200,
                                                        margin: EdgeInsets.only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 10,
                                                            top: 5),
                                                        child: StreamBuilder<
                                                            Pairs>(
                                                            stream: profileBloc
                                                                .genderList
                                                                .stream,
                                                            initialData: ProfileBloc
                                                                .constantValues,
                                                            builder: (context,
                                                                snakpshot) {
                                                              var pairsListGender =
                                                                  snakpshot
                                                                      .data;
                                                              return ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                    primary: AppThemeUtils
                                                                        .colorPrimary,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                            Radius
                                                                                .circular(
                                                                                8)))),

                                                                onPressed: () {
                                                                  if (controller !=
                                                                      null) {
                                                                    controller
                                                                        .text =
                                                                        pairsListGender
                                                                            .second
                                                                            .first
                                                                            .first;
                                                                    if (controllerNamed !=
                                                                        null) {
                                                                      controllerNamed
                                                                          .text =
                                                                          Utils
                                                                              .genderType(
                                                                              pairsListGender
                                                                                  .second
                                                                                  .first
                                                                                  .first);
                                                                    }
                                                                    if (pairsListGender
                                                                        .second
                                                                        .first
                                                                        .first ==
                                                                        null) {
                                                                      controllerNamed
                                                                          .clear();
                                                                      controller
                                                                          .clear();
                                                                    }

                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  } else {
                                                                    if (pairsListGender
                                                                        .second
                                                                        .length >
                                                                        0) {
                                                                      profileBloc
                                                                          .editFieldProfile(
                                                                          "gender",
                                                                          pairsListGender
                                                                              .second
                                                                              .first
                                                                              .first,
                                                                          myContext,
                                                                              () {
                                                                            Navigator
                                                                                .pop(
                                                                                myContext);
                                                                          });
                                                                    }
                                                                  }
                                                                },
                                                                child: Text(
                                                                  StringFile
                                                                      .confirmar,
                                                                  style: AppThemeUtils
                                                                      .normalBoldSize(
                                                                    color: AppThemeUtils
                                                                        .whiteColor,
                                                                  ),
                                                                ),

                                                              );
                                                            })))),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]))))));
  }
}
