import 'dart:convert';

import 'package:tecnoanjos_franquia/app/configuration/code_configuration.dart';
import 'package:tecnoanjos_franquia/app/core/utils/response_utils.dart';
import 'package:tecnoanjos_franquia/app/models/code_response.dart';
import 'package:tecnoanjos_franquia/app/models/page/response_paginated.dart';
import 'package:tecnoanjos_franquia/app/modules/login/repositories/auth_repository.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'dio/api_client.dart';

enum TYPEREQUEST { PATCH, POST, PUT, GET, DELETE }
enum TYPERESPONSE { OBJECT, LIST }

class RequestCore {
  var auth = Modular.get<AuthRepository>();

  Future<ResponsePaginated> requestWithTokenToForm(
      {@required serviceName,
        @required funcFromMap,
        dynamic body,
        @required TYPEREQUEST typeRequest,
        String namedResponse,
        @required TYPERESPONSE typeResponse,
        bool isXml = false,
        bool isXhttp = false,
        bool isJsonResponse = true,
        bool isString = false}) async {
    try {
      debugPrint(
          "SERVICOCHAMADO = $serviceName body = ${jsonEncode(body ?? {})}");
    } catch (e) {}


      if (CodeConfiguration.isMockDevTest) {
        return ResponsePaginated();
      } else {
        var api = await ApiClient().getApiClient(CodeConfiguration.baseUrl());
        var user = await auth.getToken();


        var header = ApiClient.getHeaderToken(token: user);
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
                    ? isXhttp
                    ? body
                    : jsonEncode(body ?? {})
                    : body,
                options: Options(
                    contentType: isXhttp
                        ? 'application/x-www-form-urlencoded'
                        : "application/json;charset=UTF-8",
                    headers: header),
              );
              break;

            case TYPEREQUEST.PUT:
              response = await api.put(
                serviceName,
                data: isJsonResponse
                    ? isXhttp
                    ? body
                    : jsonEncode(body ?? {})
                    : body,
                options: Options(
                    contentType: isXhttp
                        ? 'application/x-www-form-urlencoded'
                        : "application/json;charset=UTF-8",
                    headers: header),
              );
              break;

            case TYPEREQUEST.PATCH:
              response = await api.patch(
                serviceName,
                data: isJsonResponse
                    ? isXhttp
                    ? body
                    : jsonEncode(body ?? {})
                    : body,
                options: Options(
                    contentType: isXhttp
                        ? 'application/x-www-form-urlencoded'
                        : "application/json;charset=UTF-8",
                    headers: header),
              );
              break;
            case TYPEREQUEST.DELETE:
              response = await api.delete(
                serviceName,
                data: isJsonResponse
                    ? isXhttp
                    ? body
                    : jsonEncode(body ?? {})
                    : body,
                options: Options(
                    contentType: isXhttp
                        ? 'application/x-www-form-urlencoded'
                        : "application/json;charset=UTF-8",
                    headers: header),
              );
              break;
            default:
              response = await api.post(
                serviceName,
                data: isJsonResponse
                    ? isXhttp
                    ? body
                    : jsonEncode(body ?? {})
                    : body,
                options: Options(
                    contentType: isXhttp
                        ? 'application/x-www-form-urlencoded'
                        : "application/json;charset=UTF-8",
                    headers: header),
              );
              break;
          }

          var statusCode = response?.statusCode;
          print("Current status code: $statusCode");

          print(
              "##RETORNO-SERVICO(${typeRequest.toString()}) = $serviceName body = ${response?.data}");
          if (statusCode == 200 || statusCode == 201) {
            return ResponseUtils.getResponsePaginatedObject(
                CodeResponse(
                    sucess:  response?.data),
                funcFromMap,
                namedResponse: namedResponse,
                isObject: typeResponse);
          } else {
            return ResponseUtils.getResponsePaginatedObject(
                CodeResponse(error: response), funcFromMap,
                isObject: typeResponse);
          }
        } on DioError catch (e) {
          print(
              "***RETORNO-SERVICO (Erro)(${typeRequest.toString()}) = $serviceName body = ${e.response}");

          var msg = ResponseUtils.getErrorBody(e.response?.data);
          return ResponseUtils.getResponsePaginatedObject(
              CodeResponse(error: msg), funcFromMap,
              isObject: typeResponse);
        } on Exception catch (e) {
          var msg = ResponseUtils.getErrorBody(e?.toString()) ??
              "Sem descrição de erro";
          return ResponseUtils.getResponsePaginatedObject(
              CodeResponse(error: msg), funcFromMap,
              isObject: typeResponse);
        }

    }
  }
}
