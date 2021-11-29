import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjostec/app/components/image/user_image_widget.dart';
import 'package:tecnoanjostec/app/models/pairs.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'dart:io';

class FivePage extends StatefulWidget {
  final ValueChanged<Pairs> changeButton;
  final File image;

  FivePage({this.changeButton, this.image});

  @override
  _FivePageState createState() => _FivePageState();
}

class _FivePageState extends State<FivePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        imageWithBgWidget(context, ImagePath.imageCamera),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              StringFile.lastOnboard,textAlign: TextAlign.center,
              style: AppThemeUtils.normalBoldSize(fontSize: 22),
            )),
        UserImageWidget(
            isButton: true,
            changeButton: widget.changeButton,
            image: widget.image),
      ],
    ));
  }
}
