




import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../../../../app_bloc.dart';


class RegistreUserRepository {

  static const serviceCreateData = "/api/profile/user/create";
  static const serviceCreateDataValidation = "/api/profile/user/create/validation";
  static const serviceVerification = '/api/profile/user/sendsms/client';
  static const serviceValidate = "/api/profile/user/validate";
  static const serviceValidateEmail = "/api/profile/user/validateUserByEmail";
  static const serviceVerificationEmail = "/api/profile/user/sendCodeForValidateEmail";
  static const  serviceAlterPass = "/api/profile/user/updatePassword";
  static const REGISTRE = "REGISTRE_USER_REPOSITORY";

  var _requestManager = Modular.get<RequestCore>();
  final appBloc = Modular.get<AppBloc>();







  Future<ResponsePaginated> validadeNewUser(Map body) async {


    var result = await _requestManager.requestWithTokenToForm(REGISTRE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceCreateDataValidation,
        body: body,

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
 //return ResponsePaginated(content: {'isValid':true,'message':''});
  }

  Future<ResponsePaginated> createNewUser(Map body) async {

    var result = await _requestManager.requestWithTokenToForm(REGISTRE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceCreateData,
        body: body,

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated>   sendVerificationCod({String telefone})async {
     var asignature = kIsWeb ? "Web" : await  SmsAutoFill().getAppSignature;
     if(!kIsWeb) {
       await SmsAutoFill().listenForCode;
     }
    var result = await _requestManager.requestWithTokenToForm(REGISTRE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceVerification,
        body: {
          "telephone": Utils.removeMask(telefone),
          "signature":asignature ?? ""
        },

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated>  sendVerificationCodEmail({String email,String name}) async {
    var result = await _requestManager.requestWithTokenToForm(REGISTRE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceVerificationEmail,
        body: {
          "email":email,
          "name": name
        },

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> sendVerifiCodExists(String code,String telephone)async {
    var result = await _requestManager.requestWithTokenToForm(REGISTRE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceValidate,
        body: {"SMSToken":code, 'telephone':Utils.removeMask(telephone) },

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated>  sendVerifiCodExistsEmail(String code, String email) async {
    var result = await _requestManager.requestWithTokenToForm(REGISTRE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceValidateEmail,
        body: {"code":code, 'email':email },

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  alterMyPass(String actualPass, String confirmPass) async {
    final currentUser = await appBloc.getCurrentUserFutureValue().stream.value;
    var result = await _requestManager.requestWithTokenToForm(REGISTRE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceAlterPass,
        body: {"id":currentUser.id,"oldPassword":actualPass, 'password':confirmPass },

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }


}
