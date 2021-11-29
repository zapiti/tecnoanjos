import 'package:flutter/material.dart';



import 'navigation_bar_mobile.dart';
import 'navigation_bar_tablet_desktop.dart';

class NavigationBar extends StatelessWidget {
  final bool inverseColor ;
  const NavigationBar({Key key, this.inverseColor  = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  return LayoutBuilder(builder: (context, constraint) {
    if (constraint.maxWidth > 800) {
      return NavigationBarTabletDesktop(inverseColor);
    } else {
      return NavigationBarMobile(inverseColor);
    }
  });
  }
}


  //   return ScreenTypeLayout(
  //     mobile: NavigationBarMobile(),
  //
  //     tablet: NavigationBarTabletDesktop(),
  //   );
  // }f

