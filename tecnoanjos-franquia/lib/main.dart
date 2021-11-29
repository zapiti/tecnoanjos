
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjos_franquia/app/app_widget.dart';

import 'app/app_module.dart';
import 'app/utils/preferences/local_storage.dart';


const String firebaseKey = 'firebaseKey';
const String paymentUrl = 'paymentUrl';
const String actualVersion = 'actualVersion';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();


            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]).then((_) {
              storage.ready.then((user) {

                  runApp(ModularApp(module: AppModule(),child:AppWidget()));
                });

            });

}

