import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:tecnoanjostec/app/app_bloc.dart';

import 'app/app_module.dart';
import 'app/configuration/aws_configuration.dart';


import 'app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';



import 'app/utils/firebase/firebase_utils.dart';
import 'package:tecnoanjostec/app/utils/preferences/cd_preferences.dart';

//
const String firebaseKey = 'firebaseKey';
const String paymentUrl = 'paymentUrl';
const String actualVersion = 'actualVersion';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init((options) {
    options.dsn = AwsConfiguration.SENTRYKEY;
    // use breadcrumb tracking of WidgetsBindingObserver
    // options.useFlutterBreadcrumbTracking();
    // use breadcrumb tracking of platform Sentry SDKs
    options.useNativeBreadcrumbTracking();
  },
      // Init your App.
      appRunner: () =>
    Firebase.initializeApp().then((_) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        storage.ready.then((_) {
          setupSingletons(null, () {
            runApp(ModularApp(module: AppModule()));
          });
        });
      });
    }));
}

GetIt locator = GetIt.instance;

void setupSingletons(AppBloc appBloc, Function onSuccess) async {
  locator.registerLazySingleton<MyCurrentAttendanceBloc>(
      () => MyCurrentAttendanceBloc());
  locator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  FirebaseUtils().getFirebaseApp().then((value) {
    value.get().then((event) {
      locator.registerLazySingleton<DocumentReference>(() => event.reference);
      onSuccess();
    });
  });
}
