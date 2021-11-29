
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/modules/search/search_bloc.dart';
import 'package:tecnoanjosclient/app/modules/search/search_page.dart';

class SearchModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => MySearchBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => SearchPage(args.data)),
      ];

  static Inject get to => Inject<SearchModule>.of();
}
