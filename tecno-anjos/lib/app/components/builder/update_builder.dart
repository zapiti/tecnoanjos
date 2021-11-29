import 'package:flutter/cupertino.dart';

Widget updateBuilder<T>(
    {Stream stream, T initialData, Function(T) builderReturn}) {
  return StreamBuilder<T>(
      stream: stream,
      initialData: initialData,
      builder: (context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          builderReturn(snapshot.data);
        });
        return SizedBox();
      });
}
