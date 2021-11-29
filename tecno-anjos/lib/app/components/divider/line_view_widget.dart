import 'package:flutter/material.dart';

Widget lineViewWidget(
    { final Color color,
      final double width = 2000,
      final double boarder = 0,
      final double height = 1,
      final double bottom = 0,
      final double top = 0,
      final bool horizontal = true}) {
  return Container(
    margin: EdgeInsets.only(
        right: boarder, left: boarder, bottom: bottom, top: top),
    color: color ?? Colors.grey[300],
    width: horizontal ? width : 1,
    height: horizontal ? height : height,
  );
}
