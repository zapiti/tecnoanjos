import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tecno_anjos_landing/app/configuration/aws_configuration.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/landing_page_page.dart';
import 'package:tecno_anjos_landing/app/routes/constants_routes.dart';
import 'package:tecno_anjos_landing/app/utils/response/response_utils.dart';


import 'package:tecno_anjos_landing/app/utils/string/string_file.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';

import 'navbar_item.dart';
import 'navbar_logo.dart';

class NavigationBarTabletDesktop extends StatelessWidget {
  final bool inverseColor;

  const NavigationBarTabletDesktop(this.inverseColor, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,

      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(inverseColor),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              NavBarItem(
                ConstantsRoutes.getNameByRoute(ConstantsRoutes.BE_A_CLIENTE),
                ConstantsRoutes.CALL_A_BE_CLIENTE, onClick: () {
                ResponseUtils.launchURL(AwsConfiguration.URL_TO_CLIENTE);
              },
                customColor: inverseColor
                    ? AppThemeUtils.colorPrimary
                    : null,),
              SizedBox(
                width: 40,
              ),
              NavBarItem(
                ConstantsRoutes.getNameByRoute(ConstantsRoutes.BE_A_TECNO),
                ConstantsRoutes.CALLBE_A_TECNO, onClick: () {
                if (ModalRoute.of(context).settings.name !=
                    ConstantsRoutes.LANDING_PAGE) {
                  Modular.to.pushReplacementNamed(
                      ConstantsRoutes.LANDING_PAGE,
                      arguments: true);
                }else{
                  scrollToBottom();
                }
              },
                customColor: inverseColor
                    ? AppThemeUtils.colorPrimary
                    : null,),
              SizedBox(
                width: 50,
              ),
              // NavBarItem(
              //   ConstantsRoutes.getNameByRoute(ConstantsRoutes.LOGIN_LANDING),
              //   ConstantsRoutes.CALLLOGIN_LANDING,
              //   replace: false,
              //   customButtom: RaisedButton(
              //     color: inverseColor
              //         ? AppThemeUtils.colorPrimary
              //         : AppThemeUtils.whiteColor,
              //     onPressed: () {
              //
              //     },
              //     child: Text(
              //       StringFile.Login,
              //       style: GoogleFonts.roboto(
              //           color: inverseColor
              //               ? AppThemeUtils.whiteColor
              //               : AppThemeUtils.colorPrimary, fontSize: 16),
              //     ),
              //     shape: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(3)),
              //         borderSide: BorderSide.none),
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
