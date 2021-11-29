import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/address_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/core/address_repository.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/page/await_page.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/page/select_services_page.dart';

import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'calling_page.dart';

class CallingModule extends ChildModule {
  @override
  List<Bind> get binds => [



        Bind((i) => AddressBloc()),
        Bind((i) => AddressRepository()),


      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute,
            child: (_, args) => SelectServicesPage()),
    ModularRouter(ConstantsRoutes.CREATEATTENDANCE,
        child: (_, args) => CallingPage(args.data)),
    ModularRouter(ConstantsRoutes.ATENDIMENTO_AWAIT,
            child: (_, args) => AwaitPage(args.data)),
      ];

  static Inject get to => Inject<CallingModule>.of();
}
