import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';

import 'package:tecnoanjosclient/app/core/request_core.dart';

import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/login/models/auth/user_entity.dart';

import 'package:tecnoanjosclient/app/utils/preferences/cd_preferences.dart';
import 'package:tecnoanjosclient/app/utils/request/dio/api_client.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../../../../app_bloc.dart';

class AuthRepository {
  static const SERVICELOGIN = "/api/login/doLogin";
  static const LOGIN = "AUTH_REPOSITORY";

  static const SERVICELOGOUT = "/api/login/logout";
  static const SERVICERECOVERY = '/api/profile/user/requestResetPassword';

  static const SERVICERECOVERYRESET = '/api/profile/user/resetPassword';

  static const SERVICELOGINWITHTOKEN = "/api/login/loginWithToken/";

  static const SERVICELOGINSOCIALMEDIA = "/api/login/loginWithSocialMedia";

  Future<ResponsePaginated> getLogin({String username, String password}) async {
    var _requestManager = Modular.get<RequestCore>();
    var body = await _getLoginBody(username: username, password: password);

    var result = await _requestManager.requestWithTokenToForm(
        LOGIN, Flavor.I.getString(Keys.apiUrl),
        serviceName: SERVICELOGIN, body: body, funcFromMap: (value) {
      if (value != null) {
        final appBloc = Modular.get<AppBloc>();
        var currentUser = CurrentUser.fromMap(Jwt.parseJwt(value["token"]));
        appBloc.setFirstOnboard(currentUser?.isFirstLogin ?? false);

        appBloc.setCurrent(currentUser);
        _setTokenUser(value["token"]);
        _setRefreshTokenUser(value["refreshToken"]);
      }
      return value;
    }, typeRequest: TYPEREQUEST.POST, isObject: true);
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
    var asignature = kIsWeb ? "Web" : await SmsAutoFill().getAppSignature;
    if (!kIsWeb) {
      await SmsAutoFill().listenForCode;
    }
    return {
      'phone': username ?? "",
      'password': password ?? "",
      'client': "CLIENT",
      "signature": asignature ?? ""
    };
  }

  Future<ResponsePaginated> getLogout() async {
    try {
      var _requestManager = Modular.get<RequestCore>();
      var result = await _requestManager.requestWithTokenToForm(
          LOGIN, Flavor.I.getString(Keys.apiUrl),
          serviceName: SERVICELOGOUT,enableLogout: false,
          body: {},
          funcFromMap: (data) => data,
          typeRequest: TYPEREQUEST.GET,
          isObject: false);
      showLoading(false);
      return ResponsePaginated();
    } catch (e) {
      showLoading(false);
      return ResponsePaginated();
    }
  }

  Future<ResponsePaginated> recoveryPass(String phone, String email) async {
    var _requestManager = Modular.get<RequestCore>();
    var asignature = kIsWeb ? "Web" : await SmsAutoFill().getAppSignature;
    if (!kIsWeb) {
      await SmsAutoFill().listenForCode;
    }
    var result = await _requestManager.requestWithTokenToForm(
        LOGIN, Flavor.I.getString(Keys.apiUrl),
        serviceName: SERVICERECOVERY,
        body: {
          "email": email ?? "",
          "telephone": Utils.removeMask(phone ?? ""),
          "signature": asignature ?? ""
        },
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> recoveryPassMyPass(
      String token, String pass) async {
    var _requestManager = Modular.get<RequestCore>();

    var result = await _requestManager.requestWithTokenToForm(
        LOGIN, Flavor.I.getString(Keys.apiUrl),
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
      {String pin}) async {
    var _requestManager = Modular.get<RequestCore>();
    var body = await _getLoginBody(username: username, password: password);

    var result = await _requestManager.requestWithTokenToForm(
        LOGIN, Flavor.I.getString(Keys.apiUrl),
        serviceName: SERVICELOGINWITHTOKEN + pin,
        body: body, funcFromMap: (value) {
      if (value != null) {
        final appBloc = Modular.get<AppBloc>();
        var currentUser = CurrentUser.fromMap(Jwt.parseJwt(value["token"]));
        appBloc.setCurrent(currentUser);
        appBloc.setFirstOnboard(currentUser?.isFirstLogin ?? false);
        _setTokenUser(value["token"]);
        _setRefreshTokenUser(value["refreshToken"]);
      }
      return value;
    }, typeRequest: TYPEREQUEST.POST, isObject: true);
    return result;
  }

  getLoginWithSocialMedia({String username, String type, String token}) async {
    var _requestManager = Modular.get<RequestCore>();
    var asignature = kIsWeb ? "Web" : await SmsAutoFill().getAppSignature;
    if (!kIsWeb) {
      await SmsAutoFill().listenForCode;
    }
    var result = await _requestManager.requestWithTokenToForm(
        LOGIN, Flavor.I.getString(Keys.apiUrl),
        serviceName: SERVICELOGINSOCIALMEDIA,
        body: {
          "client": "CLIENT",
          "signature": asignature,
          "telephone": username,
          "socialMedia": type,
          "token": token
        }, funcFromMap: (value) {
      if (value != null) {
        final appBloc = Modular.get<AppBloc>();
        var currentUser = CurrentUser.fromMap(Jwt.parseJwt(value["token"]));
        appBloc.setFirstOnboard(currentUser?.isFirstLogin ?? false);

        appBloc.setCurrent(currentUser);
        _setTokenUser(value["token"]);
        _setRefreshTokenUser(value["refreshToken"]);
      }
      return value;
    }, typeRequest: TYPEREQUEST.POST, isObject: true);
    return result;
  }
}
