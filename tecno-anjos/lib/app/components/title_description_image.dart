import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

Widget titleDescriptionImage({String title, String subtitle,String imagePath}) {
  return Container(
      height: 300,
      child:  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Center(child:  Container(

        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset(
          ImagePath.imageBgLanding,

        ).image)),
        child: Image.asset( imagePath),
      )),
  Center(child:   Container(
          margin: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style:  GoogleFonts.roboto(
                color: AppThemeUtils.colorPrimaryClient, fontSize: 18,fontWeight: FontWeight.bold),
          ))),
      Container(width: 250,
          margin: EdgeInsets.only(top: 0, bottom: 10, right: 10, left: 10),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style:  GoogleFonts.roboto(
                color: AppThemeUtils.colorPrimaryClient, fontSize: 16),
          ))
    ],
  ));
}
Widget titleDescriptionImageTecno({String title, String subtitle,String imagePath}) {
  return Container(
      height: 300,
      child:Center(child:   Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child:  Container(

            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset(
                      ImagePath.imageBgLandingTecno,

                    ).image)),
            child: Image.asset(imagePath),
          )),
          // Center(child:   Container(
          //     margin: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
          //     child: Text(
          //       title,
          //       textAlign: TextAlign.center,
          //       style: AppThemeUtils.normalBoldSize(
          //           color: AppThemeUtils.whiteColor, fontSize: 18),
          //     ))),
          Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
              width: 250,
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style:  GoogleFonts.roboto(
                    color: AppThemeUtils.whiteColor, fontSize: 16),
              ))
        ],
      )));
}
