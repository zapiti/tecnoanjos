import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/login/bloc/login_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/login/repositories/auth_repository.dart';




import '../../../app_bloc.dart';

class ApiClient {
  var _dio = Modular.get<Dio>();
  var _authToken = Modular.get<AuthRepository>();

  Future<Dio> getApiClient(String url, String mac) async {
    var token = await _authToken.getToken();

    _dio.interceptors.clear();

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // Do something before request is sent
      var header = getHeaderToken(mac, token: token);
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
          if(token != null) {
            _dio.interceptors.requestLock.lock();
            _dio.interceptors.responseLock.lock();
            Modular.get<LoginBloc>().getLogout();
            _dio.interceptors.requestLock.unlock();
            _dio.interceptors.responseLock.unlock();
          }
          return error;
        } else {
          return error;
        }
      }
    }));

    return _dio;
  }

  static Map<String, String> getHeaderToken(mac, {String token}) {
    final myMac = (kIsWeb ? "Web" : mac)?.toString()?.trim() ?? "";
    if (token == null) {
      return <String, String>{
        'content-Type': 'application/json',
        'accept': 'application/json',
        'macAddress': myMac.toString().isEmpty ? "Web" : myMac.toString()
      };
    } else {
      return <String, String>{
        'content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'macAddress': myMac.toString().isEmpty ? "Web" : myMac.toString()
      };
    }
  }
}
