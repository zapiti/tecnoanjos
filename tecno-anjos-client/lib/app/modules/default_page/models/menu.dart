import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

class Menu {
  String title;
  IconData icon;
  String route;

  bool hide = false;

  String menuTitle;

  Menu({this.title, this.icon, this.route,this.hide = false});

  static List<Menu> getListWithPermission(CurrentUser currentUser) {
    return _meusMenus
        .where((element) => !element.hide)
        .toList();
  }
}

List<Menu> _meusMenus = [
  // Menu(
  //     title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.TESTE),
  //     icon: MaterialCommunityIcons.ear_hearing,
  //     route: ConstantsRoutes.TESTE),


  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.HOMEPAGE),
      icon: MaterialCommunityIcons.home_outline,
      route: ConstantsRoutes.HOMEPAGE),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.MEUPERFIL),
      icon: MaterialCommunityIcons.account_outline,
      route: ConstantsRoutes.MEUPERFIL),

  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.MEUSATENDIMENTOS),
      icon: MaterialCommunityIcons.wrench_outline,
      route: ConstantsRoutes.MEUSATENDIMENTOS),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.CARTEIRA),
      icon: MaterialCommunityIcons.wallet_outline,
      route: ConstantsRoutes.CARTEIRA),

  // Menu(
  //     title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.PLAINS),
  //     icon: MaterialCommunityIcons.cloud_print_outline,
  //     route: ConstantsRoutes.PLAINS),

  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.AVALIACOES),
      icon: MaterialCommunityIcons.clipboard_check_outline,
      route: ConstantsRoutes.AVALIACOES),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.CARTEIRA_CLIENTES),
      icon: MaterialCommunityIcons.account_heart_outline,
      route: ConstantsRoutes.CARTEIRA_CLIENTES),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.MEUSPAGAMENTOS),
      icon: MaterialCommunityIcons.cash_multiple,
      route: ConstantsRoutes.MEUSPAGAMENTOS),

  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.ENDERECOS),
      icon: MaterialCommunityIcons.map_check_outline,
      route: ConstantsRoutes.ENDERECOS),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.SUGESTIONS),
      icon: Icons.record_voice_over_outlined,
      route: ConstantsRoutes.SUGESTIONS),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.FAQ),
      icon: MaterialCommunityIcons.comment_question_outline,
      route: ConstantsRoutes.FAQ),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.CONFIGURACOES),
      icon: MaterialCommunityIcons.settings_outline,
      route: ConstantsRoutes.CONFIGURACOES),
];
