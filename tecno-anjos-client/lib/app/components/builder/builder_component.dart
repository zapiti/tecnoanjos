import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/components/state_view/empty_view_mobile.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/response/response_utils.dart';

Widget builderComponent<T>(
    {Stream<T> stream,
      Function(BuildContext, T) buildBodyFunc,
      bool enableLoad = true,
      T defaultValue,
      String emptyMessage,
      Widget emptyWidget,
      Function tryAgain,
      VoidCallback initCallData,
      Function headerWidget,  Function onEmptyAction, String buttomText}) {
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
              errorResponse = ResponseUtils.getErrorBody(snapshot.data.error,null,null,null,
                  defaultValue: snapshot.data.error);
            }
            if (errorResponse != null) {
              if(onEmptyAction != null){
                onEmptyAction();
              }
              return emptyWidget?? emptyViewMobile(context,
                  emptyMessage: errorResponse,
                  tentarNovamente: tryAgain,buttomText:buttomText,
                  isError: true

              );
            } else if (!enableLoad) {
              return buildBodyFunc(context, snapshot.data);
            } else if (snapshot.data == null && emptyWidget == null) {
              return loadElements(context);
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return loadElements(context);
                default:
                  if (ObjectUtils.isEmpty(snapshot.data)) {
                    if(onEmptyAction != null){
                      onEmptyAction();
                    }
                    return emptyWidget?? emptyViewMobile(context,
                        emptyMessage: errorResponse ?? emptyMessage,buttomText:buttomText,
                        tentarNovamente: tryAgain
                    );
                  } else {
                    return buildBodyFunc(context, snapshot.data);
                  }
              }
            }
          }));
}
Widget builderComponentSimple<T>(
    {Stream<T> stream,
      Function(BuildContext, T) buildBodyFunc,
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

