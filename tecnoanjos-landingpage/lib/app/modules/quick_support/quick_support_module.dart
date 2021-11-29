import 'quick_support_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'quick_support_page.dart';

class QuickSupportModule extends ChildModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => QuickSupportPage()),
      ];

  static Inject get to => Inject<QuickSupportModule>.of();
}
