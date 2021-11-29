import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';

Widget imageWithBgWidget(BuildContext context, String image,
    {double top = 10, double height}) {
  return Container(
      margin: EdgeInsets.only(top: top),
      width: double.infinity,
      child: Center(
          child: Stack(children: [
        Center(
            child: Container(
                margin: EdgeInsets.only(right: 30),
                child: Image.asset(ImagePath.bgCircle,
                    width: (height ?? 80) * 1.2))),
        Center(
            child: Image.asset(
          image,
          width: height ?? 80,
        ))
      ])));
}
