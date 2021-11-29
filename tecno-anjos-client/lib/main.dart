import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/app_module.dart';
import 'app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'app/utils/firebase/firebase_utils.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

const String firebaseKey = 'firebaseKey';
const String paymentUrl = 'paymentUrl';
const String googleClientId = 'googleClientId';
const String actualVersion = 'actualVersion';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
      Firebase.initializeApp().then((v) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]).then((_) {
                setupSingletons(() {
                  runApp(ModularApp(module: AppModule()));
                });

            });
          });
}

GetIt locator = GetIt.instance;

void setupSingletons(Function onSucess) async {
  locator.registerLazySingleton<MyCurrentAttendanceBloc>(
      () => MyCurrentAttendanceBloc());

  locator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  FirebaseUtils().getFirebaseApp().then((value) {
    value.get().then((event) {
      locator.registerLazySingleton<DocumentReference>(() => event.reference);
      onSucess();
    });
  });
}

class MyApp extends StatelessWidget {
  final plugin = FacebookLogin();

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(plugin: plugin),
    );
  }
}

class MyHome extends StatefulWidget {
  final FacebookLogin plugin;

  const MyHome({Key key, this.plugin}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String _sdkVersion;
  FacebookAccessToken _token;
  FacebookUserProfile _profile;
  String _email;
  String _imageUrl;

  @override
  void initState() {
    super.initState();

    _getSdkVersion();
    _updateLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _token != null && _profile != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login via Facebook example'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              if (_sdkVersion != null) Text('SDK v$_sdkVersion'),
              if (isLogin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildUserInfo(context, _profile, _token, _email),
                ),
              isLogin
                  ? OutlinedButton(
                      child: const Text('Log Out'),
                      onPressed: _onPressedLogOutButton,
                    )
                  : OutlinedButton(
                      child: const Text('Log In'),
                      onPressed: _onPressedLogInButton,
                    ),
              if (!isLogin && Platform.isAndroid)
                OutlinedButton(
                  child: const Text('Express Log In'),
                  onPressed: () => _onPressedExpressLogInButton(context),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile,
      FacebookAccessToken accessToken, String email) {
    final avatarUrl = _imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatarUrl != null)
          Center(
            child: Image.network(avatarUrl),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('User: '),
            Text(
              '${profile.firstName} ${profile.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Text('AccessToken: '),
        Text(
          accessToken.token,
          softWrap: true,
        ),
        if (email != null) Text('Email: $email'),
      ],
    );
  }

  Future<void> _onPressedLogInButton() async {
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
  }

  Future<void> _onPressedExpressLogInButton(BuildContext context) async {
    final res = await widget.plugin.expressLogin();
    if (res.status == FacebookLoginStatus.success) {
      await _updateLoginInfo();
    } else {
      await showDialog<Object>(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Can't make express log in. Try regular log in."),
        ),
      );
    }
  }

  Future<void> _onPressedLogOutButton() async {
    await widget.plugin.logOut();
    await _updateLoginInfo();
  }

  Future<void> _getSdkVersion() async {
    final sdkVesion = await widget.plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVesion;
    });
  }

  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile profile;
    String email;
    String imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }
    print(token);
    print(profile);
    print(email);
    print(imageUrl);

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }
}
