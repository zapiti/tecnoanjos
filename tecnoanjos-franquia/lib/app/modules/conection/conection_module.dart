import 'conection_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'conection_page.dart';

class ConectionModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => ConectionBloc()),
      ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute,
            child: (_, args) => ConectionPage(args.data)),
      ];


}
