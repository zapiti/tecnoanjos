import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecno_anjos_landing/app/components/divider/line_view_widget.dart';
import 'package:tecno_anjos_landing/app/components/semicircle/semi_circle.dart';
import 'package:tecno_anjos_landing/app/configuration/aws_configuration.dart';

import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navigation_bar/navbar_logo.dart';

import 'package:tecno_anjos_landing/app/routes/constants_routes.dart';

import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/response/response_utils.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';

import '../../landing_page_page.dart';
import 'navigation_drawer_header.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child:Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 16),
        ],
      ),
      child: Scaffold(body: SingleChildScrollView(child:  Column(
        children: <Widget>[
          Stack(
            children: [
              Image.asset(
                ImagePath.imageHeaderLandingPage,

                width: MediaQuery.of(context).size.width,
              ),
              Container(height: 180, child: Center(child: NavBarLogo(false))),
            ],
          ),
          DrawerButton(
              active: ModalRoute.of(context)
                  .settings
                  .name
                   == ConstantsRoutes.LANDING_PAGE,
              context: context,
              color: AppThemeUtils.colorPrimary,
              title:
                  ConstantsRoutes.getNameByRoute(ConstantsRoutes.LANDING_PAGE),
              iconData: Icons.cloud,
              menutitle:null,
              onPressed: () {
           //       Navigator.of(context).pop();


              }),
          DrawerButton(
              active: ModalRoute.of(context)
                  .settings
                  .name
                  .contains(ConstantsRoutes.BE_A_CLIENTE),
              context: context,
              title:
              ConstantsRoutes.getNameByRoute(ConstantsRoutes.BE_A_CLIENTE),
              iconData: Icons.phone_android,
              menutitle:null,
              color: AppThemeUtils.colorPrimary,
              onPressed: () {
            //      Navigator.of(context).pop();
                ResponseUtils.launchURL(AwsConfiguration.URL_TO_CLIENTE);

                //    AttendanceUtils.pushReplacementNamed(context,ConstantsRoutes.BE_A_CLIENTE);
              }),
          DrawerButton(
              active: ModalRoute.of(context)
                  .settings
                  .name
                  .contains(ConstantsRoutes.BE_A_TECNO),
              context: context,
              title:
              ConstantsRoutes.getNameByRoute(ConstantsRoutes.BE_A_TECNO),
              iconData: Icons.phone_android,
              menutitle:null,
              color: AppThemeUtils.colorPrimary,
              onPressed: () {
            //      Navigator.of(context).pop();
            //    AttendanceUtils.pushNamed(context,ConstantsRoutes.CALLBE_A_TECNO);


              }),
          DrawerButton(
              active: ModalRoute.of(context)
                  .settings
                  .name
                  .contains(ConstantsRoutes.LOGIN_LANDING),
              context: context,
              title:
              ConstantsRoutes.getNameByRoute(ConstantsRoutes.LOGIN_LANDING),
              iconData: Icons.phonelink_lock,
              color: AppThemeUtils.colorPrimary,
              menutitle:null,
              onPressed: () {
              //    Navigator.of(context).pop();


              }),

        ],
      ))),
    ));
  }
}
class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
    @required this.active,
    @required this.context,
    @required this.title,
    @required this.iconData,
    @required this.onPressed,
    this.color,
    this.menutitle,
  }) : super(key: key);

  final bool active;
  final BuildContext context;
  final VoidCallback onPressed;
  final String title;
  final IconData iconData;
  final Color color;
  final String menutitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:  MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        menutitle == null
            ? SizedBox()
            : Container(
          margin: EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Text(
            menutitle,
            maxLines: 1,
            style: AppThemeUtils.normalSize(),
          ),
        ),
        menutitle == null ? SizedBox() : lineViewWidget(top: 5, bottom: 15),
        semiCircleWidget(
            48, active ? (color ?? Theme.of(context).primaryColor) : Colors.transparent,
            child: FlatButton(
              onPressed: onPressed,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12, right: 22),
                  child: Row(children: [
                    Icon(
                      iconData,
                      size: 24,
                      color: active
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      title,
                      style: AppThemeUtils.normalSize(
                          color: active
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyText1.color),
                    ),
                  ]),
                ),
              ),
            ))
      ],
    );
  }
}

