import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/default_page/default_page_bloc.dart';


class DefaultPageModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => DefaultPageBloc()),
      ];

  @override
  List<ModularRouter> get routers => [];

  static Inject get to => Inject<DefaultPageModule>.of();
}
