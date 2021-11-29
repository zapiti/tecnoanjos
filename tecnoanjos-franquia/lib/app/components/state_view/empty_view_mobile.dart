import 'package:flutter/material.dart';

import '../../utils/image/image_path.dart';
import '../../utils/theme/app_theme_utils.dart';

Widget emptyViewMobile(BuildContext context,
    {String emptyMessage,
    VoidCallback tryAgain,
    bool isError = false,
    double height = 130.0,
    double heightImage = 50,
    double size}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Image.asset(
                isError ? ImagePath.imageError : ImagePath.imageEmpty,
                height: heightImage,
                width: heightImage ?? 50,
                scale: 0.3,
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              emptyMessage ?? "Sem dados",
              maxLines: 6,textAlign: TextAlign.center,
              style: AppThemeUtils.normalSize(
                  color: isError
                      ? AppThemeUtils.colorError
                      : Theme.of(context).textTheme.bodyText1.color),
            ),
          ),
          tryAgain != null
              ? FlatButton(
                  onPressed: tryAgain,
                  child: Text(
                    "Tentar Novamente",
                    style: AppThemeUtils.normalSize(
                        color: Theme.of(context).primaryColor),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)))
              : SizedBox(),
        ],
      ));
}
