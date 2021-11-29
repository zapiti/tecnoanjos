import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/selected_address_page.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'address_page.dart';

class AddressModule extends ChildModule {
  @override
  List<Bind> get binds => [

      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => AddressPage("")),
    ModularRouter(ConstantsRoutes.SELECTEDADDRESS, child: (_, args) => AddressSearchPage("")),
      ];

  static Inject get to => Inject<AddressModule>.of();
}
