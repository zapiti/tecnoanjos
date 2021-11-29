import 'attendance_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'attendance_page.dart';

class AttendanceModule extends Module {
  @override
  List<Bind> get binds => [
    Bind((i) => AttendanceBloc())
      ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute,
            child: (_, args) => AttendancePage()),
      ];


}
