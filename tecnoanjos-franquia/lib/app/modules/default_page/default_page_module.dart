import 'package:flutter_modular/flutter_modular.dart';
import '../../modules/default_page/default_page_bloc.dart';
import '../../modules/default_page/default_page_widget.dart';

class DefaultPageModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => DefaultPageBloc()),
      ];

  @override
  List<ModularRoute> get routes => [

      ];


}
