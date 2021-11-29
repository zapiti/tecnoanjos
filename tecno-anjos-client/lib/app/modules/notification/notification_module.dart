import 'package:flutter_modular/flutter_modular.dart';

import 'notification_bloc.dart';
import 'notification_page.dart';

class NotificationModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => NotificationBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => NotificationPage()),
      ];

  static Inject get to => Inject<NotificationModule>.of();
}
