import 'package:flutter_modular/flutter_modular.dart';

import 'chat/chat_perspective.dart';

class ChatTecnoClientModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => ChatPerspective(args.data)),
      ];

  static Inject get to => Inject<ChatTecnoClientModule>.of();
}
