import 'payment_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'payment_page.dart';

class PaymentModule extends Module {
  @override
  List<Bind> get binds => [
      Bind((i) => PaymentBloc())
      ];

  @override
  List<ModularRoute> get routes => [
       ChildRoute(Modular.initialRoute, child: (_, args) => PaymentPage()),
      ];


}
