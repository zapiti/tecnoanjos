import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/load/load_elements.dart';
import 'package:tecnoanjostec/app/components/state_view/empty_view_mobile.dart';
import 'package:tecnoanjostec/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/response/response_utils.dart';

Widget builderComponent<T>(
    {Stream<T> stream,
    Function(BuildContext,T) buildBodyFunc,
    bool enableLoad = true,
    T defaultValue,
    String emptyMessage,
    Function tentarNovamente,
    VoidCallback initCallData,
    bool enableError = true,
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
            var errorResponse;
            if (snapshot.data is ResponsePaginated) {
              errorResponse = ResponseUtils.getErrorBody(null,null,null,snapshot.data.error,
                  defaultValue: snapshot.data.error);
            }
            if (errorResponse != null) {
              return emptyViewMobile(context,
                  emptyMessage: errorResponse,
                  tentarNovamente: tentarNovamente,
                  isError: true);
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
                  if (ObjectUtils.isEmpty(snapshot.data) &&
                      enableEmpty &&
                      enableLoad) {
                    return emptyViewMobile(context,
                        emptyMessage: errorResponse ?? emptyMessage,
                        tentarNovamente: tentarNovamente);
                  } else {
                    return AnimatedSwitcher(
                        duration: Duration(milliseconds: 400),
            child: buildBodyFunc(context, snapshot.data));
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
            return AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
            child:snapshot.data == null && enableLoad
                ? loadElements(context)
                : buildBodyFunc(context, snapshot.data));
          }));
}
