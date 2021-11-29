import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/custom_theme.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'core/network/network_repository.dart';
import 'models/current_user.dart';

class AppBloc extends Disposable {
  static const SERVER = "SERVER_USER";
  static const FIREBASE = "FIREBASE_USER";
  var isFirstLogin = BehaviorSubject<bool>.seeded(true);

  var callRedirect = BehaviorSubject<bool>.seeded(false);

  var loadElement = BehaviorSubject<bool>.seeded(false);
  final currentUrl = BehaviorSubject<String>();

  var currentContext = BehaviorSubject<BuildContext>();

  var currentLocation = BehaviorSubject<String>();
  var currentToken = BehaviorSubject<String>();
  var notificationsCount = BehaviorSubject<String>();
  var notificationsMSGCount = BehaviorSubject<String>();

  var addAvaliations = BehaviorSubject<bool>.seeded(false);

  var openAwaitPopup = BehaviorSubject<bool>.seeded(false);

  var enablePopUp = BehaviorSubject<bool>.seeded(false);

  var dateNowWithSocket = BehaviorSubject<DateTime>.seeded(DateTime.now());

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



  var _isOnline = BehaviorSubject<bool>();
  var _containsOnboard = BehaviorSubject<bool>();
  var _themeStreamController = BehaviorSubject<CustomTheme>();
  var _isDarkEnable = BehaviorSubject<bool>();

  Stream<bool> get isOnlineStream => _isOnline.stream;

  bool get isOnline => _isOnline.stream.value;

  Sink<bool> get setOnline => _isOnline.sink;

  final _currentUser = BehaviorSubject<CurrentUser>();

  Sink<CustomTheme> get setThemeActual => _themeStreamController.sink;

  Stream<CustomTheme> get themeActualStream => _themeStreamController.stream;

  bool get darkThemeIsEnabled => _isDarkEnable.stream.value;

  static const DARKMODE = 'DARKMODE';
  static const ONBOADACTIVE = 'ONBOADACTIVE';
  static const FIRSTLOGIN = "FIRSTLOGIN";

  var _defaultTheme = ThemeData(
      primaryColor: AppThemeUtils.colorPrimary,
      //"00A4D5");
      primaryColorLight: AppThemeUtils.colorPrimaryLight,
      //"00A4D5");
      buttonColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        textTheme:
            TextTheme(headline1: TextStyle(color: AppThemeUtils.colorPrimary)),
        iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.grey[600],
          ),
          bodyText1: TextStyle(color: Colors.grey[800])),
      unselectedWidgetColor: Colors.grey[300],
      backgroundColor: Colors.grey[100]);

  CustomTheme getDefaultTheme() {
    return CustomTheme(themeData: _defaultTheme);
  }

  setTheme({bool isDarkMode}) async {
    try {
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
    }catch(e){}
  }

  @override
  void dispose() {
    _currentUser.close();
    currentUrl.close();
    callRedirect.drain();
    _containsOnboard.drain();
    openAwaitPopup.drain();
    enablePopUp.drain();
    dateNowWithSocket.drain();
    _themeStreamController?.close();
    _isDarkEnable.close();
    _isOnline.close();
    isFirstLogin.close();
    currentContext.drain();
    loadElement.close();
    currentLocation.drain();
    currentToken.drain();
    addAvaliations.drain();
    notificationsCount.drain();

    notificationsMSGCount.drain();
  }

  testConection(BuildContext context) {
    NetWorkRepository().testeConection().then((value) {
      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: AppThemeUtils.colorPrimary,
        message: "Erro ${value.error}",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: AppThemeUtils.whiteColor,
        ),
        duration: Duration(seconds: 50),
      )..show(context);
    });
  }

  setCurrent(CurrentUser currentUser) {
    _currentUser.sink.add(currentUser);
  }

  getMsgAttendance(attendance) {
    Modular.get<FirebaseClientTecnoanjo>().removeMessageView(attendance);
    notificationsMSGCount.sink.add(null);
    Modular.get<FirebaseClientTecnoanjo>()
        .getMessage(attendance)
        .listen((event) {
      var map = event.data();
      var tempTot = 0;
      if (map != null) {
        tempTot = ObjectUtils.parseToInt(map["count"]);
      }
      if (tempTot > 0) {
        notificationsMSGCount.sink.add(tempTot.toString());
      } else {
        notificationsMSGCount.sink.add(null);
      }
    });
  }

  BehaviorSubject<CurrentUser> getCurrentUserFutureValue() {
    var currentUser2 = _currentUser.stream.value;
    var user = currentUser2;
    if (currentUser2?.id == null) {
      codePreferences.getString(key: CurrentUser.KID).then((localUser) {
        if (localUser != null) {
          user = CurrentUser.fromMap(Jwt.parseJwt(localUser));
          _currentUser.sink.add(user);
        }
      });
    }
    return _currentUser;
  }

  DocumentReference firebaseReference() {
    DocumentReference documentReference = GetIt.I.get<DocumentReference>();
    return documentReference;
  }

  Future<bool> getIsFirstLogin() async {
    var isFirst = await codePreferences.getBoolean(key: FIRSTLOGIN,ifNotExists: true);
   return isFirst ?? true;
  }
 setFirstLogin(bool first) async {
  await codePreferences.set(key: FIRSTLOGIN,value: first);
  }
}
