
import 'package:flutter_modular/flutter_modular.dart';
import 'chat_attendance_bloc.dart';
import 'chat_attendance_page.dart';
import 'core/chat_attendance_repository.dart';

class ChatAttendanceModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ChatAttendanceBloc()),
    Bind((i) => ChatAttendanceRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => ChatAttendancePage(args.data)),
      ];

  static Inject get to => Inject<ChatAttendanceModule>.of();
}
