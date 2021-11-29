import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/permission/permission_utils.dart';

class Menu {
  String title;
  IconData icon;
  String route;
  String menuTitle;
  bool hide;

  Menu({this.title, this.icon, this.route, this.menuTitle, this.hide});

  static List<Menu> getListWithPermission(CurrentUser currentUser) {
    return _meusMenus
        .where((element) =>
            PermissionUtils.checkPermission(element.route, currentUser) && !element.hide)
        .toList();
  }
}

final List<Menu> _meusMenus = [
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.INFORMATIVO),
      icon: MaterialCommunityIcons.information,
      route: ConstantsRoutes.INFORMATIVO,
      hide: !kIsWeb),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.FINANCEIRO),
      icon: MaterialCommunityIcons.finance,
      route: ConstantsRoutes.FINANCEIRO,
      hide: !kIsWeb),
  Menu(
      title: "Início",
      icon: MaterialCommunityIcons.home_outline,
      menuTitle: kIsWeb ? "Geral" : null,
      route: ConstantsRoutes.HOMEPAGE,
      hide: false),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.MEUPERFIL),
      icon: MaterialCommunityIcons.account_outline,
      route: ConstantsRoutes.MEUPERFIL,
      hide: false),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.AVALIACOES),
      icon: MaterialCommunityIcons.clipboard_check_outline,
      route: ConstantsRoutes.AVALIACOES,
      hide: false),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.MEUSATENDIMENTOS),
      icon: MaterialCommunityIcons.wrench_outline,
      route: ConstantsRoutes.MEUSATENDIMENTOS,
      hide: false),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.MEUSPAGAMENTOS),
      icon: MaterialCommunityIcons.cash_multiple,
      route: ConstantsRoutes.MEUSPAGAMENTOS,
      hide: false),
  // Menu(
  //     title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.CARTEIRA_CLIENTES),
  //     icon: MaterialCommunityIcons.history,
  //     route: ConstantsRoutes.CARTEIRA_CLIENTES,
  //     hide: false),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.SUGESTIONS),
      icon: Icons.record_voice_over_outlined,
      route: ConstantsRoutes.SUGESTIONS,
      hide: false),

  Menu(
      title: ConstantsRoutes.getNameByRoute(
          ConstantsRoutes.CENTRALDEAJUDA),
      icon: MaterialCommunityIcons.help_circle_outline,
      route: ConstantsRoutes.CENTRALDEAJUDA,
      hide: false),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.FAQ),
      icon: MaterialCommunityIcons.comment_question_outline,
      route: ConstantsRoutes.FAQ,
      hide: false),
  Menu(
      title: ConstantsRoutes.getNameByRoute(ConstantsRoutes.CONFIGURACOES),
      icon: MaterialCommunityIcons.settings_outline,
      route: ConstantsRoutes.CONFIGURACOES,
      hide: false),
];
