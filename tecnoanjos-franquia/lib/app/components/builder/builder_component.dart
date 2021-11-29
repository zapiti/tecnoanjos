import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/load/load_elements.dart';
import '../../components/state_view/empty_view_mobile.dart';
import '../../components/state_view/stateful_wrapper.dart';
import '../../models/page/response_paginated.dart';
import '../../utils/object/object_utils.dart';
import '../../core/utils/response_utils.dart';

Widget builderComponent<T>(
    {Stream<T> stream,
    Function buildBodyFunc,
    bool enableLoad = true,
    T defaultValue,
    String emptyMessage,
    Function tryAgain,
    VoidCallback initCallData,
    Function headerWidget}) {
  return StatefulWrapper(
      onInit: () {
        if (initCallData != null) {
          initCallData();
        }
      },
      child: StreamBuilder<dynamic>(
          stream: stream,
          initialData: defaultValue,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            var errorResponse;
            if (snapshot.data is ResponsePaginated) {
              errorResponse = ResponseUtils.getErrorBody(snapshot.data.error,
                  defaultValue: snapshot.data.error);
            }
            if (errorResponse != null) {
              return Column(
                children: [
                  headerWidget != null
                      ? headerWidget(snapshot?.data)
                      : SizedBox(),
                  Expanded(
                      child: emptyViewMobile(context,
                          emptyMessage: errorResponse,
                          tryAgain: tryAgain,
                          isError: true))
                ],
              );
            } else if (!enableLoad) {
              return buildBodyFunc(context, snapshot.data);
            } else if (snapshot.data == null) {
              return loadElements(context);
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return loadElements(context);
                default:
                  if (ObjectUtils.isEmpty(snapshot.data)) {
                    return Column(children: [
                      headerWidget != null
                          ? headerWidget(snapshot.data)
                          : SizedBox(),
                      Expanded(
                          child: emptyViewMobile(context,
                              emptyMessage: errorResponse ?? emptyMessage,
                              tryAgain: tryAgain))
                    ]);
                  } else {
                    return buildBodyFunc(context, snapshot.data);
                  }
              }
            }
          }));
}
Widget builderComponentSimple<T>(
    {Stream<T> stream,
      Function buildBodyFunc,
      T defaultValue,
      String emptyMessage,
      Function tryAgain,
      VoidCallback initCallData,
      bool enableError = true,
      bool enableLoad = true,
      bool enableEmpty = true}) {
  return StatefulWrapper(
      onInit: () {
        if (initCallData != null) {
          initCallData();
        }
      },
      child: StreamBuilder<dynamic>(
          stream: stream,
          initialData: defaultValue,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.data == null && enableLoad
                ? loadElements(context)
                : buildBodyFunc(context, snapshot.data);
          }));
}
