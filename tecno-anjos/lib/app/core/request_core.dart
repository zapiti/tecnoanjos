import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjostec/app/models/code_response.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/login/bloc/login_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/login/repositories/auth_repository.dart';
import 'package:tecnoanjostec/app/utils/amplitude/amplitude_util.dart';

import 'package:tecnoanjostec/app/utils/request/dio/api_client.dart';
import 'package:tecnoanjostec/app/utils/response/response_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import '../app_bloc.dart';


enum TYPEREQUEST { PATCH, POST, PUT, GET, DELETE }

class RequestCore {
  var auth = Modular.get<AuthRepository>();
  var appBloc = Modular.get<AppBloc>();
  static const TYPE_GET = "GET";
  static const TYPE_POST = "POST";
  static const TYPE_PUT = "PUT";
  static const showBody = true;


  Future<ResponsePaginated> requestWithTokenToForm(String scream,
      {@required serviceName,
        @required funcFromMap,
        dynamic body,
        TYPEREQUEST typeRequest = TYPEREQUEST.GET,
        String namedResponse,
        bool isObject = true,
        bool isXml = false,
        bool isImage = false,
        bool isJsonResponse = true,
        bool enableLogout = true,
        bool isString = false, bool test = false}) async {
    try {
      debugPrint(
          "SERVICOCHAMADO = $serviceName body = ${jsonEncode(body ?? {})}");
    } catch (e) {}
    var getUser = await appBloc.serverInterno();
    var showDev = getUser != null;


    var mac = test ? "Web" : kIsWeb ? null : await Utils.initPlatformState();
    var api = await ApiClient().getApiClient(mac);
    var token = await auth.getToken();

    var header = ApiClient.getHeaderToken(mac, token: token);
    try {
      Response response;
      switch (typeRequest) {
        case TYPEREQUEST.GET:
          response = await api.get(
            serviceName,
            options: Options(
                contentType: "application/json;charset=UTF-8",
                headers: header),
          );
          break;
        case TYPEREQUEST.POST:
          response = await api.post(
            serviceName,
            data: isJsonResponse
                ? isImage
                ? body
                : jsonEncode(body ?? {})
                : body,
            options: Options(
                contentType: isImage
                    ? 'multipart/form-data'
                    : "application/json;charset=UTF-8",
                headers: header),
          );
          break;

        case TYPEREQUEST.PUT:
          response = await api.put(
            serviceName,
            data: isJsonResponse
                ? isImage
                ? body
                : jsonEncode(body ?? {})
                : body,
            options: Options(
                contentType: isImage
                    ? 'multipart/form-data'
                    : "application/json;charset=UTF-8",
                headers: header),
          );
          break;

        case TYPEREQUEST.PATCH:
          response = await api.patch(
            serviceName,
            data: isJsonResponse
                ? isImage
                ? body
                : jsonEncode(body ?? {})
                : body,
            options: Options(
                contentType: isImage
                    ? 'multipart/form-data'
                    : "application/json;charset=UTF-8",
                headers: header),
          );
          break;
        case TYPEREQUEST.DELETE:
          response = await api.delete(
            serviceName,
            data: isJsonResponse
                ? isImage
                ? body
                : jsonEncode(body ?? {})
                : body,
            options: Options(
                contentType: isImage
                    ? 'multipart/form-data'
                    : "application/json;charset=UTF-8",
                headers: header),
          );
          break;
        default:
          response = await api.post(
            serviceName,
            data: isJsonResponse
                ? isImage
                ? body
                : jsonEncode(body ?? {})
                : body,
            options: Options(
                contentType: isImage
                    ? 'multipart/form-data'
                    : "application/json;charset=UTF-8",
                headers: header),
          );
          break;
      }

      var statusCode = response?.statusCode;
      print("Current status code: $statusCode");

      print(
          "##RETORNO-SERVICO(${typeRequest
              .toString()}) = $serviceName body = ${showBody
              ? response?.data
              : {}}");
      if (statusCode == 200 ||
          statusCode == 201 ||
          statusCode == 202 ||
          statusCode == 204) {
        return ResponseUtils.getResponsePaginatedObject(
            CodeResponse(
                sucess: response?.data.toString().contains("content")
                    ? response?.data['content']
                    : response?.data),
            funcFromMap,
            namedResponse: namedResponse,
            isObject: isObject,
            status: response?.statusCode);
      } else {
        if (statusCode == 403 && enableLogout) {
          Modular.get<LoginBloc>().getLogout();
        }
        return ResponseUtils.getResponsePaginatedObject(
            CodeResponse(error: response), funcFromMap,
            isObject: isObject, status: response?.statusCode);
      }
    } on DioError catch (e) {
      if (!test) {
        AmplitudeUtil.createEvent(AmplitudeUtil.eventoErroBackandByStatus(
            e?.response?.statusCode ?? e.toString()));
      }

      print(
          "***RETORNO-SERVICO (Erro)(${typeRequest
              .toString()}) = $serviceName body = ${showBody ? e.response : {
          }}");
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        return ResponsePaginated(
            error: "Sua conexão esta instável! tente novamente");
      } else {
        if (e.response != null) {
          if (e.response.statusCode == 403 && enableLogout) {
            Modular.get<LoginBloc>().getLogout();
          }
          var msg = ResponseUtils.getErrorBody(
              serviceName, token, body, e.response?.data,
              showDev: showDev);
          return ResponseUtils.getResponsePaginatedObject(
              CodeResponse(error: msg), funcFromMap,
              isObject: isObject, status: e?.response?.statusCode);
        } else {
          return ResponsePaginated(error: StringFile.servidorIndisponivel);
        }
      }
    } catch (error) {
      var msg = ResponseUtils.getErrorBody(
          serviceName, token, body, error?.toString(),
          showDev: showDev) ??
          "Sem descrição de erro";
      return ResponseUtils.getResponsePaginatedObject(
          CodeResponse(error: msg), funcFromMap,
          isObject: isObject, status: 500);
    }
  }
}
