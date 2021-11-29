import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:string_validator/string_validator.dart';
import 'package:tecnoanjos_franquia/app/configuration/code_configuration.dart';
import 'package:tecnoanjos_franquia/app/core/dio/api_client.dart';
import 'package:tecnoanjos_franquia/app/core/request_core.dart';
import 'package:tecnoanjos_franquia/app/models/current_user.dart';
import 'package:tecnoanjos_franquia/app/models/page/response_paginated.dart';

import 'package:tecnoanjos_franquia/app/modules/login/models/auth/user_entity.dart';
import 'package:tecnoanjos_franquia/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';
import '../../../app_bloc.dart';

import 'package:http/http.dart' as http;

class AuthRepository {
  static const SERVICELOGIN = "/api/login/doLogin";
  static const LOGIN = "AUTH_REPOSITORY";

  static const SERVICELOGOUT = "/api/login/logout";
  static const SERVICERECOVERY = '/api/profile/user/requestResetPassword';

  static const SERVICERECOVERYRESET = '/api/profile/user/resetPassword';

  static const SERVICELOGINWITHTOKEN = "/api/login/loginWithToken/";

  Future<ResponsePaginated> getLogin({String username, String password}) async {
    var _requestManager = Modular.get<RequestCore>();
    var body = await _getLoginBody(username: username, password: password);

    var result = await _requestManager.requestWithTokenToForm(
      typeResponse: TYPERESPONSE.OBJECT,
      serviceName: SERVICELOGIN,
      body: body,
      funcFromMap: (value) {
        if (value != null) {
          if (value["token"] != null) {
            final appBloc = Modular.get<AppBloc>();
            var currentUser = CurrentUser.fromMap(Jwt.parseJwt(value["token"]));
            appBloc.setFirstOnboard(currentUser?.isFirstLogin ?? false);

            appBloc.setCurrent(currentUser);
            _setTokenUser(value["token"]);
            _setRefreshTokenUser(value["refreshToken"]);
          }
        }
        return value;
      },
      typeRequest: TYPEREQUEST.POST,
    );
    return result;
  }

  Future<String> getToken() async {
    var userKid =
        await codePreferences.getString(key: UserEntity.KID, ifNotExists: null);
    return userKid == "null" ? null : userKid;
  }

  Future<String> getRefreshToken() async {
    var userKid = await codePreferences.getString(
        key: UserEntity.REFRESH, ifNotExists: null);
    return userKid == "null" ? null : userKid;
  }

  Future<String> _setRefreshTokenUser(String token) async {
    return await codePreferences.set(key: UserEntity.REFRESH, value: token);
  }

  Future<String> _setTokenUser(String token) async {
    return await codePreferences.set(key: UserEntity.KID, value: token);
  }

  Future<Map<String, String>> _getLoginBody(
      {String username, String password}) async {
    var asignature = "Web";

    bool valido = isEmail(username);
    debugPrint("email valido $valido");
    return
      valido ? {
            'email': username ?? "",
            'password': password ?? "",
            'client': "FRANCHISE",
            "signature": asignature ?? ""
          }
        : {
            'phone': username ?? "",
            'password': password ?? "",
            'client': "FRANCHISE",
            "signature": asignature ?? ""
          };
  }

  Future<ResponsePaginated> getLogout() async {
    var _authToken = Modular.get<AuthRepository>();

    var token = await _authToken.getToken();
    var url = CodeConfiguration.baseUrl();

    var header = ApiClient.getHeaderToken(token: token);
    await http
        .get(url + SERVICELOGOUT, headers: header)
        .timeout(Duration(seconds: 15));

    return ResponsePaginated();
  }

  Future<ResponsePaginated> recoveryPass(String phone, String email) async {
    var _requestManager = Modular.get<RequestCore>();
    var asignature = "Web";

    var result = await _requestManager.requestWithTokenToForm(
        serviceName: SERVICERECOVERY,
        body: {
          "email": email ?? "",
          "telephone": Utils.removeMask(phone ?? ""),
          "signature": asignature ?? ""
        },
        funcFromMap: (data) => data,
        typeResponse: TYPERESPONSE.OBJECT,
        typeRequest: TYPEREQUEST.POST);
    return result;
  }

  Future<ResponsePaginated> recoveryPassMyPass(
      String token, String pass) async {
    var _requestManager = Modular.get<RequestCore>();

    var result = await _requestManager.requestWithTokenToForm(
      serviceName: SERVICERECOVERYRESET,
      body: {
        "token": token,
        "password": pass,
      },
      funcFromMap: (data) => data,
      typeRequest: TYPEREQUEST.POST,
      typeResponse: TYPERESPONSE.OBJECT,
    );
    return result;
  }

  Future<ResponsePaginated> getLoginWithToken(String username, String password,
      {String pin}) async {
    var _requestManager = Modular.get<RequestCore>();
    var body = await _getLoginBody(username: username, password: password);

    var result = await _requestManager.requestWithTokenToForm(
      serviceName: SERVICELOGINWITHTOKEN + pin,
      body: body,
      funcFromMap: (value) {
        if (value != null) {
          final appBloc = Modular.get<AppBloc>();
          var currentUser = CurrentUser.fromMap(Jwt.parseJwt(value["token"]));
          appBloc.setCurrent(currentUser);
          appBloc.setFirstOnboard(currentUser?.isFirstLogin ?? false);
          _setTokenUser(value["token"]);
          _setRefreshTokenUser(value["refreshToken"]);
        }
        return value;
      },
      typeRequest: TYPEREQUEST.POST,
      typeResponse: TYPERESPONSE.OBJECT,
    );
    return result;
  }
}
