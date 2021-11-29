import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';

Widget imageWithBgWidget(BuildContext context, String image,
    {double top = 0, double height}) {
  return Container(
      margin: EdgeInsets.only(top: top),
      width: double.infinity,
      child: Center(child:  Stack(children: [
        Image.asset(
            ImagePath.bgCircle,
            width: height ??
                50,height: height ??
            50,),
        Image.asset(
          image,
          width: height ??
              50,height: height ??
            50,
        )
      ])));
}
