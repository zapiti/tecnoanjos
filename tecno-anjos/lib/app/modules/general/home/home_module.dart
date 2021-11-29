import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_page.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/core/start_called_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/home_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/home_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/core/receiver_called_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/receiver_called/receiver_called_bloc.dart';



import 'modules/attendance/core/attendance_repository.dart';
import 'modules/profile/core/profile_repository.dart';
import 'modules/profile/profile_bloc.dart';


class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => DrawerPage()),
        Bind((i) => HomeBloc()),
        Bind((i) => DrawerBloc()),
        Bind((i) => new ProfileBloc()),
        Bind((i) => new ProfileRepository()),
        Bind((i) => new ReceiverCalledBloc()),
        Bind((i) => new ReceiverCalledRepository()),

        Bind((i) => StartCalledRepository()),

        Bind((i) => AttendanceRepository()),

      ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),

      ];

  static Inject get to => Inject<HomeModule>.of();
}
