import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_page.dart';


class WalletModule extends ChildModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => WalletPage()),
      ];

  static Inject get to => Inject<WalletModule>.of();
}
