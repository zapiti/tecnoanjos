import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjostec/app/utils/request/dio/api_client.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  static const SERVICELOGIN = "/api/login/doLogin";
  static const LOGIN = "AUTH_REPOSITORY";
  static const SERVICELOGOUT = "/api/login/logout";

  static const SERVICERECOVERY = '/api/profile/user/requestResetPassword';
  static const SERVICERECOVERYRESET = '/api/profile/user/resetPassword';
  static const SERVICELOGINWITHTOKEN = "/api/login/loginWithToken/";


  Future<ResponsePaginated> getLogin(
      {String username, String password, bool test = false}) async {
    var _requestManager = Modular.get<RequestCore>();
    var body = await _getLoginBody(
        username: username, password: password, test: test);

    var result = await _requestManager.requestWithTokenToForm(LOGIN,
        serviceName: SERVICELOGIN,
        body: body,
        funcFromMap: (data) {
          if (data != null) {
            var appbloc = Modular.get<AppBloc>();

            if (data != null && !test) {
              var token = data["token"];
              var currentUser = CurrentUser.fromMap(Jwt.parseJwt(token));
              appbloc.setCurrent(currentUser);
              appbloc.currentToken.sink.add(token);
              setTokenUser(token);
            }
          }
          return data;
        },
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<String> getToken() async {
    var userKid =
    await codePreferences.getString(key: CurrentUser.KID, ifNotExists: null);
    return userKid == "null" ? null : userKid;
  }

  Future<CurrentUser> getUser() async {
    var user = await codePreferences.getString(key: CurrentUser.USERLOG);
    if (user == null) {
      return null;
    } else {
      Map userMap = jsonDecode(user);
      var currentUser = CurrentUser.fromMap(userMap);
      return currentUser;
    }
  }


  Future<String> getRefreshToken() async {
    var userKid = await codePreferences.getString(
        key: CurrentUser.REFRESH, ifNotExists: null);
    return userKid == "null" ? null : userKid;
  }


  Future<String> setTokenUser(String token) async {
    return await codePreferences.set(key: CurrentUser.KID, value: token);
  }

  Future<Map<String, String>> _getLoginBody(
      {String username, String password, bool test = false}) async {
    var asignature = (kIsWeb || test) ? "Web" : await SmsAutoFill()
        .getAppSignature;
    if (!(kIsWeb)) {
      if (!test) {
        await SmsAutoFill().listenForCode;
      }
    }
    return {
      'phone': username ?? "",
      'password': password ?? "",
      'client': 'TECNO', "signature": asignature
    };
  }

  Future<ResponsePaginated> getLogout() async {
    try {
      var _requestManager = Modular.get<RequestCore>();
      var result = await _requestManager.requestWithTokenToForm(
          LOGIN,
          serviceName: SERVICELOGOUT,
          body: {},
          funcFromMap: (data) => data,
          typeRequest: TYPEREQUEST.GET,
          isObject: false);

      return ResponsePaginated();
    } catch (e) {

      return ResponsePaginated();
    }
  }

  Future<ResponsePaginated> recoveryPass(String phone, String email) async {
    var _requestManager = Modular.get<RequestCore>();
    var asignature = kIsWeb ? "Web" : await SmsAutoFill().getAppSignature;
    if (!kIsWeb) {
      await SmsAutoFill().listenForCode;
    }
    var result = await _requestManager.requestWithTokenToForm(LOGIN,
        serviceName: SERVICERECOVERY,
        body: {
          "email": email ?? "",
          "telephone": Utils.removeMask(phone ?? ""),
          "signature": asignature
        },
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> recoveryPassMyPass(String token,
      String pass) async {
    var _requestManager = Modular.get<RequestCore>();

    var result = await _requestManager.requestWithTokenToForm(LOGIN,
        serviceName: SERVICERECOVERYRESET,
        body: {
          "token": token,
          "password": pass,
        },
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> getLoginWithToken(String username, String password,
      {String pin, bool test = false}) async {
    var _requestManager = Modular.get<RequestCore>();
    var body = await _getLoginBody(
        username: username, password: password, test: test);

    var result = await _requestManager.requestWithTokenToForm(LOGIN,
        serviceName: SERVICELOGINWITHTOKEN + pin,
        body: body,
        funcFromMap: (value) {
          if (value != null && !test) {
            var appbloc = Modular.get<AppBloc>();
            var currentUser = CurrentUser.fromMap(Jwt.parseJwt(value["token"]));
            appbloc.currentToken.sink.add(value["token"]);
            appbloc.setCurrent(currentUser);
            setTokenUser(value["token"]);
          }
          return value;
        },
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }
}
