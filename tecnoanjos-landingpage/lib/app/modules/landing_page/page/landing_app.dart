import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navbar/navigation_drawer.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navigation_bar/navigation_bar.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/widget/page/registre_franquise.dart';

class LandingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) =>
            Scaffold(
                drawer:
                sizingInformation.deviceScreenType == DeviceScreenType.mobile
                    ? Modular.get<NavigationDrawer>()
                    : null,
                backgroundColor: Colors.white,
                body: SingleChildScrollView(child: Column(children: [
                  NavigationBar(),
                  RegistreFranquise(

                  )
                ],),)
            ));
  }
}