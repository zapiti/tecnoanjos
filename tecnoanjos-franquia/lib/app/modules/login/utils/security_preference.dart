import 'package:tecnoanjos_franquia/app/modules/login/models/auth/user_entity.dart';
import 'package:tecnoanjos_franquia/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjos_franquia/app/utils/preferences/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';


class SecurityPreference {
  static void clean() {
    if(!kIsWeb){
      // final storage = new FlutterSecureStorage();
      // storage.deleteAll();
    }

  }

  static void save({String username, String password}) async {
    // if(!kIsWeb) {
    //   final storage = new FlutterSecureStorage();
    //   await storage.write(key: UserEntity.USER, value: (username ?? "").trim());
    //   await storage.write(key: UserEntity.PASS, value: (password ?? "").trim());
    // }else{

      await codePreferences.set(key: UserEntity.USER, value: (username ?? "").trim());
      await codePreferences.set(key: UserEntity.PASS, value: (password ?? "").trim());
  //  }
  }
  static void saveInternal({String username, String password}) async {
    if (!kIsWeb) {
      // final storage = new FlutterSecureStorage();
      // await storage.write(
      //     key: UserEntity.INTERNALUSER, value: (username ?? "").trim());
      // await storage.write(
      //     key: UserEntity.INTERNALPASS, value: (password ?? "").trim());
    } else {

      await  codePreferences.set(
          key: UserEntity.INTERNALUSER, value: (username ?? "").trim());
      await  codePreferences.set(
          key: UserEntity.INTERNALPASS, value: (password ?? "").trim());
    }
  }

  static Future<UserEntity> getUser() async {
    var user = UserEntity();
    if(!kIsWeb) {
      // final storage = new FlutterSecureStorage();
      // user.username = await storage.read(key: UserEntity.USER);
      // user.password = await storage.read(key: UserEntity.PASS);
    }else{

      user.username =
      await codePreferences.getString(key: UserEntity.USER);
      user.password =
      await codePreferences.getString(key: UserEntity.PASS);
    }
    return user;
  }

  static Future<UserEntity> getUserInternal() async {
    var user = UserEntity();
    if (!kIsWeb) {
      // final storage = new FlutterSecureStorage();
      // user.username = await storage.read(key: UserEntity.INTERNALUSER);
      // user.password = await storage.read(key: UserEntity.INTERNALPASS);
    } else {

      user.username =
      await codePreferences.getString(key: UserEntity.INTERNALUSER);
      user.password =
      await codePreferences.getString(key: UserEntity.INTERNALPASS);
    }
    return user;
  }




}
