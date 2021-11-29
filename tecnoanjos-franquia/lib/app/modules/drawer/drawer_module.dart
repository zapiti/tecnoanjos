import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../modules/drawer/drawer_bloc.dart';
import '../../modules/drawer/drawer_page.dart';

class DrawerModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        new Bind((i) => new DrawerBloc()),
      ];

  @override
  List<ModularRoute> get routes => [];



  @override
  // TODO: implement view
  Widget get view => new DrawerPage();
}
