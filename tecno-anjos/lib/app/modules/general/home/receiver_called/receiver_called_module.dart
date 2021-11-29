import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/receiver_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/receiver_called_page.dart';
import 'core/receiver_called_repository.dart';

class ReceiverCalledModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ReceiverCalledBloc()),
        Bind((i) => ReceiverCalledRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => ReceiverCalledPage()),
      ];

  static Inject get to => Inject<ReceiverCalledModule>.of();
}
