import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/payments/payments_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/payments/payments_page.dart';

import 'core/payment_repository.dart';



class PaymentsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PaymentsBloc()),
        Bind((i) => PaymentRepository()),
        Bind((i) => DrawerBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => PaymentsPage()),
//        Router(ConstantsRoutes.DETAILS_PAYMENT,
//            child: (_, args) => DetailPayment(args.data)),
      ];

  static Inject get to => Inject<PaymentsModule>.of();
}
