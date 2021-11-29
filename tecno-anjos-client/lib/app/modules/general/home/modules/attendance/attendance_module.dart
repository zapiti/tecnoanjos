import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/page/detail_attendance_page.dart';

import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'attendance_page.dart';



class AttendanceModule extends ChildModule {
  @override
  List<Bind> get binds => [

        Bind((i) => DrawerBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => AttendancePage()),
    ModularRouter(ConstantsRoutes.DETAILS_ATTENDANCE,
            child: (_, args) => DetailAttendancePage(args.data)),
      ];

  static Inject get to => Inject<AttendanceModule>.of();
}
