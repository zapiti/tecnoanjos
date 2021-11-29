import 'dart:async';
import 'dart:convert';

import 'package:tecnoanjos_franquia/app/configuration/code_configuration.dart';
import 'package:tecnoanjos_franquia/app/core/request_core.dart';
import 'package:tecnoanjos_franquia/app/models/current_user.dart';
import 'package:tecnoanjos_franquia/app/modules/login/bloc/login_bloc.dart';
import 'package:tecnoanjos_franquia/app/modules/login/repositories/auth_repository.dart';

import 'package:dio/dio.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import '../../app_bloc.dart';

class ApiClient {
  var _dio = Modular.get<Dio>();
  var _authToken = Modular.get<AuthRepository>();

  Future<Dio> getApiClient(String url) async {
    var token = await _authToken.getToken();


    _dio.interceptors.clear();

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // Do something before request is sent
      var header = getHeaderToken( token: token);
      options.headers = header;
      options.baseUrl = url;
      options.connectTimeout = 30 * 1000; // 60 seconds
      options.receiveTimeout = 30 * 1000; // 60 seconds

      print("Url=> $url");
      return options;
    }, onResponse: (Response response) {
      // Do something with response data
      return response; // continue
    }, onError: (DioError error) async {
      // Do something with response error
      final appBloc = Modular.get<AppBloc>();
      var server = await appBloc.serverInterno();
      if (server == null) {
        if (error.response?.statusCode == 403) {
          _dio.interceptors.requestLock.lock();
          _dio.interceptors.responseLock.lock();
          Modular.get<LoginBloc>().getLogout();
          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          return error;
        } else {
          return error;
        }
      }
    }));

    return _dio;
  }

  static Map<String, String> getHeaderToken({String token}) {
    if (token == null) {
      return <String, String>{
        'content-Type': 'application/json',
        'accept': 'application/json',
        'macAddress':  "Web"
      };
    } else {
      return <String, String>{
        'content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'macAddress':  "Web"
      };
    }
  }
}
