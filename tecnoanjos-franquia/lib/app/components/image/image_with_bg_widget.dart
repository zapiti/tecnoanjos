import 'package:flutter/material.dart';
import '../../utils/image/image_path.dart';

Widget imageWithBgWidget(String image, {double top = 0}) {
  return Container(
      margin: EdgeInsets.only(top: top),
      child: Stack(children: [

        Image.asset(
          image,
          width: 80,
          height: 80,
        )
      ]));
}
