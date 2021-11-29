import 'dart:convert';

import 'package:tecnoanjos_franquia/app/models/current_user.dart';
import 'package:tecnoanjos_franquia/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'models/custom_theme.dart';

import 'modules/login/models/auth/user_entity.dart';

class AppBloc extends Disposable {
  static const SERVER = "SERVER_USER";
  static const FIREBASE = "FIREBASE_USER";

  var openAwaitPopup = BehaviorSubject<bool>.seeded(false);

  var isFirstLogin = BehaviorSubject<bool>.seeded(false);

  var dateNowWithSocket = BehaviorSubject<DateTime>.seeded(DateTime.now());

  var notificationsCount = BehaviorSubject<String>();
  var notificationsMSGCount = BehaviorSubject<String>();

  var currentContext = BehaviorSubject<BuildContext>();
  var _isOnline = BehaviorSubject<bool>();
  var _containsOnboard = BehaviorSubject<bool>();
  var _themeStreamController = BehaviorSubject<CustomTheme>();
  var _isDarkEnable = BehaviorSubject<bool>();
  var loadElement = BehaviorSubject<bool>.seeded(false);
  var currentLocation = BehaviorSubject<String>();

  // final currentTimeZoneSubject = BehaviorSubject<String>();
  var addAvaliations = BehaviorSubject<bool>.seeded(false);

  var firstOnboardSubject = BehaviorSubject<bool>.seeded(false);

  var secondOnboardSubject = BehaviorSubject<bool>.seeded(false);

  var thirdOnboardSubject = BehaviorSubject<bool>.seeded(false);

  get isOnlineStream => _isOnline.stream;

  bool get isOnline => _isOnline.stream.value;

  Sink<bool> get setOnline => _isOnline.sink;

  final _currentUser = BehaviorSubject<CurrentUser>();
  final currentUrl = BehaviorSubject<String>();

  Sink<CustomTheme> get setThemeActual => _themeStreamController.sink;

  get themeActualStream => _themeStreamController.stream;

  bool get darkThemeIsEnabled => _isDarkEnable.stream.value;

  static const DARKMODE = 'DARKMODE';
  static const ONBOADACTIVE = 'ONBOADACTIVE';

  static const FIRSTONBOARD = 'FIRSTONBOARD';
  static const SECONDONBOARD = 'SECONDONBOARD';
  static const THIRDONBOARD = 'THIRDONBOARD';
  static const IDCURRENT = "IDCURRENT";

  var _defaultTheme = ThemeData(
      primaryColor: AppThemeUtils.colorPrimary,
      primaryColorLight: AppThemeUtils.colorPrimary,
      buttonColor: AppThemeUtils.whiteColor,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.grey[600],
          ),
          bodyText1: TextStyle(color: Colors.grey[800])),
      unselectedWidgetColor: Colors.grey[300],
      backgroundColor: Colors.grey[100]);

  Future<String> serverFirebase({String value}) async {
    if (value != null) {
      var firebaseServer =
      await codePreferences.set(key: FIREBASE, value: value);
      return firebaseServer;
    } else {
      var firebaseServer = await codePreferences.getString(key: FIREBASE);
      return firebaseServer;
    }
  }

  Future<String> serverInterno({String value}) async {
    if (value != null) {
      var firebaseServer = await codePreferences.set(key: SERVER, value: value);
      return firebaseServer;
    } else {
      var firebaseServer = await codePreferences.getString(key: SERVER);
      return firebaseServer;
    }
  }

  CustomTheme getDefaultTheme() {
    return CustomTheme(themeData: _defaultTheme);
  }

  setTheme({bool isDarkMode}) async {
    if (isDarkMode == null) {
      var isDark = await codePreferences.getBoolean(key: DARKMODE);
      _isDarkEnable.sink.add(isDark ?? false);
      if (isDark == null) {
        await codePreferences.set(key: DARKMODE, value: false);
        setThemeActual.add(CustomTheme(themeData: _defaultTheme));
      } else {
        var customTheme = CustomTheme(
          themeData: isDark ? ThemeData.dark() : _defaultTheme,
        );
        setThemeActual.add(customTheme);
      }
    } else {
      _isDarkEnable.sink.add(isDarkMode);
      await codePreferences.set(key: DARKMODE, value: isDarkMode);
      var customTheme = CustomTheme(
        themeData: isDarkMode ? ThemeData.dark() : _defaultTheme,
      );
      setThemeActual.add(customTheme);
    }
  }

  @override
  void dispose() {
    _currentUser.close();
    dateNowWithSocket.drain();
    openAwaitPopup.drain();
    isFirstLogin.drain();
    currentUrl.drain();
    _containsOnboard.drain();
    _themeStreamController?.close();
    _isDarkEnable.close();
    loadElement.drain();
    currentContext.drain();
    addAvaliations.drain();
    //currentTimeZoneSubject.drain();
    _isOnline.close();
    currentLocation.close();
    notificationsCount.close();
    notificationsMSGCount.close();
    firstOnboardSubject.close();
    secondOnboardSubject.close();
    thirdOnboardSubject.close();
  }

  setCurrent(CurrentUser currentUser) {
    if (currentUser == null) {
      _currentUser.sink.add(null);
    } else {
      final actualCurrent = _currentUser.stream.value ?? currentUser;
      actualCurrent.name = currentUser?.name;
      _currentUser.sink.add(actualCurrent);
    }
  }

  BehaviorSubject<CurrentUser> getCurrentUserFutureValue() {
    var currentUser2 = _currentUser.stream.value;
    var user = currentUser2;
    if (currentUser2?.id == null) {
      codePreferences.getString(key: UserEntity.KID).then((localUser) {
        if (localUser != null) {
          user = CurrentUser.fromMap(Jwt.parseJwt(localUser));
          _currentUser.sink.add(user);
        }
      });
    }

    return _currentUser;
  }



  setFirstOnboard(bool value, {bool firstOnly = false}) async {
    if (firstOnly) {
      await codePreferences.set(key: FIRSTONBOARD, value: value);
    } else {
      await codePreferences.set(key: ONBOADACTIVE, value: value);
    }
  }



  getFirstOnboard(Function onSuccess) async {

    codePreferences
        .getBoolean(key: ONBOADACTIVE, ifNotExists: false)
        .then((value) {
      if (value) {
        codePreferences
            .getBoolean(key: FIRSTONBOARD, ifNotExists: true)
            .then((value1) {
          if (value1) {
            onSuccess();
          }
        });
      }
    });
    // firstOnboardSubject.sink.add(true);
    // if(!kIsWeb) {
    //   var mainOnboard =
    //   await codePreferences.getBoolean(key: ONBOADACTIVE, ifNotExists: true);
    //   if (mainOnboard) {
    //     var firstOnboard = await codePreferences.getBoolean(
    //         key: FIRSTONBOARD, ifNotExists: true);
    //
    //     firstOnboardSubject.sink.add(firstOnboard);
    //   } else {
    //     firstOnboardSubject.sink.add(false);
    //   }
    // }
  }

  getSecondOnBoard(Function onSuccess) async {
    codePreferences
        .getBoolean(key: ONBOADACTIVE, ifNotExists: false)
        .then((value) {
      if (value) {
        onSuccess();
      }
    });

    // if(!kIsWeb) {
    //   var firstOnboard =
    //   await codePreferences.getBoolean(key: ONBOADACTIVE, ifNotExists: true);
    //   if (firstOnboard) {
    //     var secondOnboard = await codePreferences.getBoolean(
    //         key: SECONDONBOARD, ifNotExists: true);
    //     secondOnboardSubject.sink.add(secondOnboard);
    //   } else {
    //      secondOnboardSubject.sink.add(true);
    //   }
    // }
  }

  void setSecondOnboard(bool value) {
    codePreferences.set(key: ONBOADACTIVE, value: value);
  }

  Future<String> getCurrentAttendanceId() async {
    var current = await codePreferences.getString(key: IDCURRENT);
    return current;
  }

  Future<String> setCurrentID(String id) async {
    var current = await codePreferences.set(key: IDCURRENT, value: id);
    return current;
  }

}
