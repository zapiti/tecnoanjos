import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'image_path.dart';

Widget titleDrawerWidget(BuildContext context) {
  return Container(
    child: Column(
      children: <Widget>[
        Container(
          child: getLogoIcon(),
          margin: EdgeInsets.only(bottom: 5),
        ),

      ],
    ),
  );
}

Widget getLogoIcon({double width: 250, double height: 130}) {
  return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(
        ImagePath.imageLogo,
      ).image)));
}
