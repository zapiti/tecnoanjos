import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/utils/preferences/cd_preferences.dart';
import '../../../main.dart';
import '../../app_bloc.dart';


class FirebaseUtils {
  static const SERVERFIREBASE = "SERVERS";
  static const SERVER_USER = "SERVER_USER";
  static const SERVER_DEFAULT = "SERVER_DEFAULT";

  static const server = 'server';
  static const nameServer = 'name';
  static const CHAMADAS = "CHAMADAS";
  static const CLIENTE = "CLIENTE";
  static const REQUISICES = "REQUISICES";
  static const TEAM_VIEW_URL = "TEAM_VIEW_URL";
  static const VERSAOATUAL =  "VERSAO";

  FirebaseFirestore db = GetIt.I.get<FirebaseFirestore>();

  Future<DocumentReference> getFirebaseApp() async {
    var production = await getNameServerHomologWeb();
    return getDockToFirebase(db, production);
  }

  reportErrorToPage(
      String nameScream,
      dynamic object,
      String tipo,
      String nameService,
      String sucess,
      String service,
      String token,
      dynamic body,
      result,
      {defaultValue}) async {

  }

  Future<String> getServerHomologWeb(String devUrl) async {
    var appBloc = Modular.get<AppBloc>();
    var production = await appBloc.serverInterno();
    if (production == null) {
      if (devUrl != null && devUrl != "") {
        var value = await db.collection(SERVER_USER).doc(devUrl ?? "").get();
        if (value.data().toString().contains(server)) {
          return value.data()[server];
        } else {
          return await callDefaultProduction();
        }
      } else {
        return await callDefaultProduction();
      }
    } else {
      return production;
    }
  }

  Future callDefaultProduction() async {
    try {
      var value = await db.collection(SERVER_DEFAULT).doc(Flavor.I.getString(firebaseKey)).get();
      if (value.data().toString().contains(server)) {
        return value.data()[server];
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  Future<String> getNameServerHomologWeb() async {
    var production = AppBloc()?.serverFirebase();
    if (production == null) {
      var user = CurrentUser();
      var localUser = await codePreferences.getString(key: CurrentUser.KID);
      if (localUser != null) {
        user = CurrentUser.fromMap(Jwt.parseJwt(localUser));
      }
      var devUrl = user?.telephone ?? user?.name ?? user?.id?.toString();
      if (devUrl != null && devUrl != "") {
        var value = await db.collection(SERVER_USER).doc(devUrl ?? "").get();
        if (value.data().toString().contains(nameServer)) {
          return value.data()[nameServer];
        } else {
          return await _callNameServer();
        }
      } else {
        return await _callNameServer();
      }
    } else {
      return production;
    }
  }

  Future _callNameServer() async {
    try {
      var value = await db.collection(SERVER_DEFAULT).doc(Flavor.I.getString(firebaseKey)).get();
      if (value.data().toString().contains(nameServer)) {
        return value.data()[nameServer];
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  DocumentReference getDockToFirebase(FirebaseFirestore db, String production) {
    return db.collection(SERVERFIREBASE).doc(production ?? Flavor.I.getString(firebaseKey));
  }

  // Future<RemoteConfig> setupRemoteConfig() async {
  //   if (!kIsWeb) {
  //     try {
  //       final RemoteConfig remoteConfig = await RemoteConfig.instance;
  //
  //       remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
  //       await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  //       await remoteConfig.activateFetched();
  //       return remoteConfig;
  //     } catch (ex) {
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }
}
