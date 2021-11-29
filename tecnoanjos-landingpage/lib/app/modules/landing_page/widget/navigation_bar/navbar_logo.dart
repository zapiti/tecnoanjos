import 'package:flutter/material.dart';

import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';

class NavBarLogo extends StatelessWidget {
 final bool inverseColor;
  const NavBarLogo(this.inverseColor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: SizedBox(
      height: 150,

      child: Image.asset(inverseColor ? ImagePath.inverseImageTitleTecno :ImagePath.imageTitleTecno,height: 80,width: 230,),
    )
      ,) ;
  }
}
