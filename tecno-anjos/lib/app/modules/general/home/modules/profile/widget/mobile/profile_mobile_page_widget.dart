import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

import '../../profile_bloc.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/profile/widget/profile_builder.dart';

Widget profileMobilePageWidget(BuildContext context, ProfileBloc userBloc) {
  return  SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Column(
                children: <Widget>[
                  builderComponent<ResponsePaginated>(
                    stream: userBloc.userProfile.stream,
                    initCallData: () => userBloc.getUserData(context),
                    buildBodyFunc: (context, data) =>
                        profileBuilder(context, data.content, userBloc),
                  ),
                ],
              )));
}
