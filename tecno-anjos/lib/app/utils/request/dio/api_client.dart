import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjostec/app/modules/general/login/repositories/auth_repository.dart';
import '../../../app_bloc.dart';

class ApiClient {
  var _dio = Modular.get<Dio>();
  var _authToken = Modular.get<AuthRepository>();

  Future<Dio> getApiClient(String  mac) async {
    var token = await _authToken.getToken();
    var baseUrl = Flavor.I.getString(Keys.apiUrl);

    _dio.interceptors.clear();

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // Do something before request is sent
      var header = getHeaderToken(mac, token: token);
      options.headers = header;
      options.baseUrl = baseUrl;
      options.connectTimeout = 30 * 1000; // 30 seconds
      options.receiveTimeout = 30 * 1000; // 30 seconds

      print("Url=> $baseUrl");
      return options;
    }, onResponse: (Response response) {
      // Do something with response data
      return response; // continue
    }, onError: (DioError error) async {
      var appBLoc = Modular.get<AppBloc>();
      var server = await appBLoc.serverInterno();
      if (server == null) {
        if (error.response?.statusCode == 403) {
          _dio.interceptors.requestLock.lock();
          _dio.interceptors.responseLock.lock();

          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          return error;
        } else {
          return error;
        }
      }
      return error;
    }));

    return _dio;
  }

  static getHeaderToken(mac, {String token}) {
    final myMac = (kIsWeb ? "Web" : mac)?.toString()?.trim() ?? "";
    if (token == null) {
      return <String, String>{
        'content-Type': 'application/json',
        'Accept': 'application/json',
        'macAddress': myMac.toString().isEmpty ? "Web" : myMac.toString()
      };
    } else {
      return <String, String>{
        'content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'macAddress': myMac.toString().isEmpty ? "Web" : myMac.toString()
      };
    }
  }
}
