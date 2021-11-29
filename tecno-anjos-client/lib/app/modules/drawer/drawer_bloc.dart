import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';


import 'models/home/home.dart';

class DrawerBloc extends Disposable {
  var homeDataStream = BehaviorSubject<Home>.seeded(
      Home(selectedHome: ConstantsRoutes.HOMEPAGE));

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    homeDataStream.drain();
  }

}
