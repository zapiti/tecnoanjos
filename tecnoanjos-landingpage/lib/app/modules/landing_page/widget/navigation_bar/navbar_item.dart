import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';


class NavBarItem extends StatelessWidget {
  final String title;
  final String navigationPath;
  final bool replace;
  final Widget customButtom;
  final VoidCallback onClick;
  final Color customColor;
  const NavBarItem(this.title, this.navigationPath,{this.replace = true,this.customButtom,  this.onClick,this.customColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick == null ?() {
//        if(replace){
//          AttendanceUtils.pushReplacementNamed(context,navigationPath);
//        }else{
//          AttendanceUtils.pushNamed(context,navigationPath);
//        }


      }:onClick,
      child:customButtom ?? Text(
        title,
        style: GoogleFonts.roboto(fontSize: 18,color:customColor?? AppThemeUtils.whiteColor),
      ),
    );
  }
}
