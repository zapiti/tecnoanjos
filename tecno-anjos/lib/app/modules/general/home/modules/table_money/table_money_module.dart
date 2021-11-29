import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/core/table_payment_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/table_money_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/table_money/table_money_page.dart';

class TableMoneyModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => TableMoneyBloc()),
        Bind((i) => TablePaymentRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => TableMoneyPage()),
      ];

  static Inject get to => Inject<TableMoneyModule>.of();
}
