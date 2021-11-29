import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_page.dart';

class DrawerModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        new Bind((i) => new DrawerBloc()),

      ];

  @override
  List<ModularRouter> get routers => [];

  static Inject get to => Inject<DrawerModule>.of();

  @override
  // TODO: implement view
  Widget get view => new DrawerPage();
}
