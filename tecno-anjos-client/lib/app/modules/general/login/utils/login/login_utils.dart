import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';

class LoginUtils {
  static String convertResponseToString(String response) {
    return response == "Bad credentials"
        ? "Usuário e/ou senha inválidos!"
        : response == "User is disabled"
            ? "Usuário desabilitado!"
            : "Falha interna no servidor: ${response ?? "sem descrição"} ";
  }

  static Future<CurrentUser> loginWithFaceBook() async {
    try {
      final facebookLogin = FacebookLogin();
      facebookLogin.logOut();
      final FacebookLoginResult facebookLoginResult =
          await facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

      if (facebookLoginResult.accessToken.token == null) {
        return null;
      }
      final graphResponse = await Dio().get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');

      if (graphResponse == null) {
        return null;
      } else {
        debugPrint(graphResponse.data);
        final result = jsonDecode(graphResponse.data);
        return CurrentUser(
            name: result["name"]?.toString(),
            email: result["email"]?.toString(),
            telephone: result["phone"]?.toString(),
            token: facebookLoginResult.accessToken.token);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<CurrentUser> loginWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
        'email',
        "https://www.googleapis.com/auth/userinfo.profile"
      ],);
      await _googleSignIn.signOut();


      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      _googleSignIn.currentUser.clearAuthCache();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      if (_googleSignIn.currentUser == null) {
        return null;
      } else {
        debugPrint(
            "${_googleSignIn?.currentUser?.displayName} ${_googleSignIn?.currentUser?.email} ${googleSignInAuthentication?.accessToken} ${_googleSignIn?.currentUser?.id}");
        return CurrentUser(
            name: _googleSignIn?.currentUser?.displayName,
            email: _googleSignIn?.currentUser?.email,
            token: googleSignInAuthentication.idToken);
      }
    } catch (e) {
      return null;
    }
  }
}
