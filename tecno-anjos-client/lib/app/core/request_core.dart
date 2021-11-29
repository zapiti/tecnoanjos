import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';

import 'package:tecnoanjosclient/app/models/code_response.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/login/bloc/login_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/login/repositories/auth_repository.dart';

import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/connection/network_service.dart';
import 'package:tecnoanjosclient/app/utils/request/dio/api_client.dart';
import 'package:tecnoanjosclient/app/utils/response/response_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import 'package:tecnoanjosclient/app/utils/utils.dart';

enum TYPEREQUEST { PATCH, POST, PUT, GET, DELETE }

class RequestCore {
  var auth = Modular.get<AuthRepository>();
  final appBloc = Modular.get<AppBloc>();
  static const TYPE_GET = "GET";
  static const TYPE_POST = "POST";
  static const TYPE_PUT = "PUT";
  static const showBody = true;

  // Future<ResponsePaginated> requestWithTokenToForm(String scream,
  //     {@required serviceName,
  //       @required funcFromMap,
  //       Map body,
  //       bool isPost = true,
  //       bool isPut = false,
  //       bool isObject = true,
  //       String namedResponse,
  //       bool isDelete = false}) async {

  Future<ResponsePaginated> requestWithTokenToForm(scream,String url,
      {@required serviceName,
      @required funcFromMap,
      dynamic body,
       TYPEREQUEST typeRequest,
      String namedResponse,
      bool isObject = true,
      bool isXml = false,
      bool isImage = false,
      bool enableLogout = true,
      bool isJsonResponse = true,
      bool isString = false, bool test = false}) async {
    try {
      debugPrint("############INICIO################");
      debugPrint(
          "SERVICOCHAMADO(${typeRequest.toString()}) = $serviceName body = ${jsonEncode(body ?? {})}");
    } catch (e) {}
    var getUser = await appBloc.serverInterno();
    var showDev = getUser != null;
    var checkCelular = await NetWorkService.check();
    if (!checkCelular) {
      return ResponsePaginated(error: StringFile.semConexaoRede);
    } else {

        var mac = test ? "Web" :await Utils.initPlatformState();
        var api = await ApiClient().getApiClient(url,mac);

        api.options.baseUrl = url;
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


          print(
              "##RETORNO-SERVICO(${typeRequest.toString()}) = $serviceName body = ${showBody ? response?.data : {}}");
          print("Current status code: $statusCode");
          debugPrint("############FIM################");
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
              debugPrint("Logout servico ${serviceName}");
              Modular.get<LoginBloc>().getLogout();
            }
            return ResponseUtils.getResponsePaginatedObject(
                CodeResponse(error: response), funcFromMap,
                isObject: isObject, status: response?.statusCode);
          }
        } on DioError catch (e) {
          if(!test) {
            AmplitudeUtil.createEvent(AmplitudeUtil.eventoErroBackandByStatus(
                e?.response?.statusCode ?? e.toString()));
          }
          print(
              "***RETORNO-SERVICO (Erro)(${typeRequest.toString()}) = $serviceName body = ${showBody ? e.response : {}}");
          debugPrint("############FIM################");
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
                  CodeResponse(error: msg,others:  e.response?.data), funcFromMap,
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
          debugPrint("############FIM################");
          return ResponseUtils.getResponsePaginatedObject(
              CodeResponse(error: msg), funcFromMap,
              isObject: isObject, status: 500);
        }

    }
  }
}
