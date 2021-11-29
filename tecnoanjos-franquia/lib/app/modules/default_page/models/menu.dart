import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/image/image_path.dart';
import 'package:tecnoanjos_franquia/app/utils/permission_utils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Menu {
  String title;
  IconData icon;
  String route;

  bool hide;

  Menu({this.title, this.icon, this.route, this.hide});

  static List<Menu> getListWithPermission() {
    return _menuItems.where((element) => element.hide).toList();
  }
}

List<Menu> _menuItems = [


  // Menu(
  //     title:
  //     ConstantsRoutes.getNameByRoute(ConstantsRoutes.HOME),
  //     icon: MaterialCommunityIcons.monitor_dashboard,
  //     route: ConstantsRoutes.HOME,
  //     hide: PermissionUtils.checkPermission(
  //         ConstantsRoutes.HOME)),

  Menu(
      title:
      ConstantsRoutes.getNameByRoute(ConstantsRoutes.TECNICOS),
      icon: MaterialCommunityIcons.account_group,
      route: ConstantsRoutes.TECNICOS,
      hide: PermissionUtils.checkPermission(
          ConstantsRoutes.TECNICOS)),

  Menu(
      title:
      ConstantsRoutes.getNameByRoute(ConstantsRoutes.ATTENDANCE),
      icon: MaterialCommunityIcons.finance,
      route: ConstantsRoutes.ATTENDANCE,
      hide: PermissionUtils.checkPermission(
          ConstantsRoutes.ATTENDANCE)),

  Menu(
      title:
      ConstantsRoutes.getNameByRoute(ConstantsRoutes.PAGAMENTO),
      icon: MaterialCommunityIcons.cash,
      route: ConstantsRoutes.PAGAMENTO,
      hide: PermissionUtils.checkPermission(
          ConstantsRoutes.PAGAMENTO)),



];
