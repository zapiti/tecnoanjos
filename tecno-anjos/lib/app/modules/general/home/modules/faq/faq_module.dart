import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/faq/core/faq_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/faq/faq_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/faq/faq_page.dart';

class FaqModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => FaqBloc()),
        Bind((i) => FaqRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => FaqPage()),
      ];

  static Inject get to => Inject<FaqModule>.of();
}
