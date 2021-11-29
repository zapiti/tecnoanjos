import 'package:tecnoanjostec/app/modules/general/finance/core/finance_repository.dart';

import 'finance_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'finance_page.dart';

class FinanceModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => FinanceBloc()),
    Bind((i) => FinanceRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => FinancePage()),
      ];

  static Inject get to => Inject<FinanceModule>.of();
}
