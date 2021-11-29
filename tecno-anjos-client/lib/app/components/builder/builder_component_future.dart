import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';

Widget builderComponentFuture<T>(
    {Future<T> future, Function buildBodyFunc, bool enableLoad = true}) {
  return FutureBuilder<dynamic>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!enableLoad) {
          return buildBodyFunc(snapshot.data);
        } else if (snapshot.data == null) {
          return loadElements(context);
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return loadElements(context);
            default:
              if (snapshot.data == -1) {
                return loadElements(context);
              } else {
                return buildBodyFunc(snapshot.data);
              }
          }
        }
      });
}
