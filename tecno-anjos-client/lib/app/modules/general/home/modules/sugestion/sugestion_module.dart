import 'package:tecnoanjosclient/app/modules/general/home/modules/sugestion/repository/sugestion_repository.dart';
import 'sugestion_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'sugestion_page.dart';

class SugestionModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => SugestionBloc()),
    Bind((i) => SugestionRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => SugestionPage()),
      ];

  static Inject get to => Inject<SugestionModule>.of();
}
