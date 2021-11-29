import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/modules/general/login/models/auth/user_entity.dart';
import 'package:tecnoanjosclient/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjosclient/main.dart';
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

  FirebaseFirestore db = GetIt.I.get<FirebaseFirestore>();

  static const VERSAOATUAL = "VERSAO";

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
    // var error =
    //     ObjectUtils.parseToMap(result, defaultValue: defaultValue) ?? result;
    //
    // final bodyFinal = {
    //   "ServiceError": "$service => ${error.toString()}",
    //   "TokenUser": token,
    //   "Body": body,
    //   "Result": result.toString()
    // };
    //
    // String nameScream2 = nameScream.replaceAll("/", "_");
    // String tipo2 = tipo.replaceAll("/", "_");
    // String nameService2 = nameService.replaceAll("/", "_");
    // var _dateTime = await MyDateUtils.getTrueTime();
    //
    // await db
    //     .collection(CHAMADAS)
    //     .doc(CLIENTE)
    //     .collection(REQUISICES)
    //     .doc(nameScream2)
    //     .collection(nameService2)
    //     .doc(sucess)
    //     .collection(tipo2)
    //     .doc(MyDateUtils.parseDateTimeFormat(_dateTime, _dateTime,
    //         format: "dd-MM-yyyy HH:mm:ss"))
    //     .set({"body": object, "bodyFinal": bodyFinal});
  }

  Future<String> getServerHomologWeb(String devUrl) async {
    final appBloc = Modular.get<AppBloc>();
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
      var localUser = await codePreferences.getString(key: UserEntity.KID);
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
}
