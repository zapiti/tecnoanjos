import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/card_web_with_title.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/drawer/widget/build_headerList_drawer.dart';
import '../../profile_bloc.dart';



import '../profile_builder.dart';

Widget profileWebPageWidget(BuildContext context, ProfileBloc userBloc) {
  return CardWebWithTitle(
      child: Container(
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Column(
            children: <Widget>[
              builderComponent<ResponsePaginated>(
                stream: userBloc.userProfile.stream,
                initCallData: () => userBloc.getUserData(context),
                buildBodyFunc: (context, data) => profileBuilder(
                    context, data.content, userBloc,
                    header: buildHeaderListDrawer(
                        userBloc, context, MediaQuery.of(context).size.width,
                        forceShowInfo: true)),
              ),
            ],
          )));
}
