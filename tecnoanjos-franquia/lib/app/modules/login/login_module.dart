
import 'package:flutter_modular/flutter_modular.dart';
import '../../modules/login/login_page.dart';

class LoginModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
   ChildRoute(Modular.initialRoute, child: (_, args) => LoginPage()),

      ];


}
