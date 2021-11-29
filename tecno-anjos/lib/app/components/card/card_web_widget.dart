import 'package:flutter/material.dart';

Widget cardWebWidget(
    BuildContext context,
    {Color color,
    double width,
    double height,
    @required child,
    double horizontal = 15,
    double vertical = 15,
    double elevation = 10,
    Color shadow = Colors.grey}) {
  return  Material(
    elevation: elevation,
    shadowColor: shadow,
    borderRadius: BorderRadius.circular(4),
    color: color ?? Theme.of(context).cardColor,
    child: Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    ),
  );
}
