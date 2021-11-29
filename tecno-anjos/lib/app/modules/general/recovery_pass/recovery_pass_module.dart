
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/recovery_pass/recovery_pass_bloc.dart';
import 'recovery_pass_page.dart';

class RecoveryPassModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => RecoveryPassBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => RecoveryPassPage()),
      ];

  static Inject get to => Inject<RecoveryPassModule>.of();
}
