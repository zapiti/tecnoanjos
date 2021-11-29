import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Widget emptyViewMobile(BuildContext context,
    {String emptyMessage,
      VoidCallback tentarNovamente,
      bool isError = false,
      double height = 130.0,
      double heightImage = 50,
      double size, String tryAgainText }) {
  return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 30,),
          Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Image.asset(
                isError ? ImagePath.imageError : ImagePath.imageEmpty,
                height: 150,
                width: 150,

              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              emptyMessage ?? StringFile.semdados,
              maxLines: 6, textAlign: TextAlign.center,

              style: AppThemeUtils.normalSize(
                  color: isError
                      ? AppThemeUtils.colorError
                      : AppThemeUtils.colorPrimaryClient),
            ),
          ),
          SizedBox(height: 15,),
          tentarNovamente != null
              ? ElevatedButton(

              onPressed: tentarNovamente,
              child: Text(
                tryAgainText ?? StringFile.Atualizar,
                style: AppThemeUtils.normalSize(
                    color: AppThemeUtils.whiteColor),
              ), style: ElevatedButton.styleFrom(primary: AppThemeUtils.colorPrimaryClient,


              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Theme
                      .of(context)
                      .primaryColor))))
              : SizedBox(),
        ],
      )));
}

