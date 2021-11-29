import 'package:flutter_modular/flutter_modular.dart';

import 'client_wallet_bloc.dart';
import 'client_wallet_page.dart';
import 'core/client_wallet_repository.dart';

class ClientWalletModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ClientWalletBloc()),
        Bind((i) => ClientWalletRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => ClientWalletPage()),
      ];

  static Inject get to => Inject<ClientWalletModule>.of();
}
