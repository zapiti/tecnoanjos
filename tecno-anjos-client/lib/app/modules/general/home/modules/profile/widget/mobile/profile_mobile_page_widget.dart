import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';

import '../../profile_bloc.dart';


import '../profile_builder.dart';

Widget profileMobilePageWidget(ProfileBloc userBloc) {

  return SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Column(
                children: <Widget>[
                  builderComponent<ResponsePaginated>(
                    stream: userBloc.userProfile.stream,
                    initCallData: () => userBloc.getUserData(),
                    buildBodyFunc: (context, data) =>
                        profileBuilder(context, data.content, userBloc),
                  ),
                ],
              )));
}
