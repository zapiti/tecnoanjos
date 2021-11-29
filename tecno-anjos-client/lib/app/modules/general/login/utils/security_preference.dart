import 'package:flutter/foundation.dart';
import 'package:tecnoanjosclient/app/modules/general/login/models/auth/user_entity.dart';
import 'package:tecnoanjosclient/app/utils/preferences/cd_preferences.dart';


class SecurityPreference {
  static void clean() {
    if(!kIsWeb){

    }

  }

  static void save({String username, String password}) async {


      await codePreferences.set(key: UserEntity.USER, value: (username ?? ""));
      await codePreferences.set(key: UserEntity.PASS, value: (password ?? ""));

  }


  static Future<UserEntity> getUser() async {
    var user = UserEntity();


      user.username =
      await codePreferences.getString(key: UserEntity.USER);
      user.password =
      await codePreferences.getString(key:  UserEntity.PASS);

    return user;
  }


}
