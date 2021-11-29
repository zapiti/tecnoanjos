import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecno_anjos_landing/app/configuration/aws_configuration.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/landing_page_bloc.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/landing_page_page.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navigation_bar/navbar_logo.dart';
import 'package:tecno_anjos_landing/app/routes/constants_routes.dart';
import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/response/response_utils.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_file.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_landingpage_file.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';

import 'divider/line_view_widget.dart';

Widget buildBottomTecno(BuildContext context) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 320, maxHeight: 350),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment(0, 0),
            color: AppThemeUtils.colorPrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(children: [
                          NavBarLogo(false),
                          Container(
                              width: 200,

                              child:Text(
                                StringLandingPageFile.bottomLandingPage,
                                textAlign: TextAlign.start,
                                style:
                                AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
                              ))
                        ],)
                     ,
                        Expanded(
                            child:    Container(
                                margin: EdgeInsets.only(top: 80),
                                child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(ImagePath.twt),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(ImagePath.facebook),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(ImagePath.linkeding),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(ImagePath.instagran),     SizedBox(
                              width: 10,
                            ),
                          ],
                        )))
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child:    Container()),
                        SizedBox(
                          width: 15,
                        ),
                        FlatButton(
                            onPressed: () {
                              ResponseUtils.launchURL(
                                  AwsConfiguration.URL_TO_CLIENTE);
                            },
                            child: Text(
                              StringLandingPageFile.sejaCliente,
                              textAlign: TextAlign.center,
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.whiteColor),
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        FlatButton(
                            onPressed: () {
                              if (ModalRoute.of(context).settings.name !=
                                  ConstantsRoutes.LANDING_PAGE) {
                                Modular.to.pushReplacementNamed(
                                    ConstantsRoutes.LANDING_PAGE,
                                    arguments: true);
                              }else{
                                scrollToBottom();
                              }
                            },
                            child: Text(
                             StringLandingPageFile.sejaFranquiado,
                              textAlign: TextAlign.center,
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.whiteColor),
                            ))
                      ],
                    )),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric( horizontal: 30),
          child:  lineViewWidget(color: AppThemeUtils.whiteColor)),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                      StringLandingPageFile.mark,
                      textAlign: TextAlign.center,
                      style: AppThemeUtils.normalSize(
                          color: AppThemeUtils.whiteColor),
                    ))
              ],
            ),
          )));
}
