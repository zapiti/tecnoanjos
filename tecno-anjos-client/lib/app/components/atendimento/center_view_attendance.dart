import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class CenterViewAttendance extends StatelessWidget {
  final String image;
  final String title;
  final Widget subtitle;

  CenterViewAttendance({this.image, this.subtitle, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          image == null
              ? SizedBox()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
          image == null
              ? SizedBox()
              : Container(
                  height: 180,
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset(image)),
          title == null
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        // text: appbar.getCurrentUserValue().name ?? "",
                        text: "",
                        style: AppThemeUtils.normalBoldSize(
                            fontSize: 24,
                            color: Theme.of(context).textTheme.bodyText1.color),
                        children: <TextSpan>[
                          TextSpan(
                            text: title ?? "",
                            style: AppThemeUtils.normalSize(fontSize: 20),
                          ),
                        ],
                      ))),
          subtitle ?? SizedBox(),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 30,
          ),
        ]));
  }
}
