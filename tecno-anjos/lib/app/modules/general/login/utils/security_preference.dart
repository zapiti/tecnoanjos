import 'package:flutter/foundation.dart';

import 'package:tecnoanjostec/app/models/current_user.dart';

import 'package:tecnoanjostec/app/utils/preferences/cd_preferences.dart';


class SecurityPreference {
  static void clean() {
    if(!kIsWeb){

    }

  }

  static void save({String username, String password}) async {


      await codePreferences.set(key: CurrentUser.USER, value: (username ?? "").trim());
      await codePreferences.set(key: CurrentUser.PASS, value: (password ?? "").trim());

  }


  static Future<CurrentUser> getUser() async {
    var user = CurrentUser();

      user.username =
      await codePreferences.getString(key: CurrentUser.USER);
      user.password =
      await codePreferences.getString(key: CurrentUser.PASS);

    return user;
  }


}
