import 'package:tecnoanjos_franquia/app/modules/search/search_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjos_franquia/app/modules/search/search_page.dart';

class SearchModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => MySearchBloc()),
      ];

  @override
  List<ModularRoute> get routes => [
   ChildRoute(Modular.initialRoute, child: (_, args) => SearchPage(args.data)),
      ];


}
