import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/divider/line_view_widget.dart';

import 'image_path.dart';

Widget titleDrawerWidget(BuildContext context) {
  return Container(
    child: Column(
      children: <Widget>[
        Container(
          child: getLogoIcon(),
          margin: EdgeInsets.only(bottom: 5),
        ),
        lineViewWidget(color: Theme.of(context).primaryColor, height: 5)
      ],
    ),
  );
}

Widget getLogoIcon({double height}) {
  return Container(
      width: 500,
      height: height ?? 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(
        ImagePath.imageLogo,fit: BoxFit.fill,
      ).image)));
}
