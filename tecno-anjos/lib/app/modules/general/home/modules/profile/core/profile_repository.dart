import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

class ProfileRepository {
  static const serviceAlteration = "/login/dados";
  static const serviceGetData = "/api/profile/user";
  static const serviceGetAddress = "/user/address";
  static const serviceUserImage = "/api/profile/image/user";
  static const serviceGetStatus = "/api/profile/user/getStatus";
  static const serviceChangeStatus = "/api/profile/user/updateStatus";
  static const serviceFinishUser = '/api/profile/user/finish/data';
  static const serviceGetInfo = '/api/profile/user/getInfo';
  static const sendNotification = "/api/profile/attendance/sendMessage";
  static const serviceVerification = '/api/profile/user/sendsms';
  static const serviceValidate = "/api/profile/user/validate";
  var _requestManager = Modular.get<RequestCore>();

  static const PROFILE = "PROFILE_REPOSITORY";

  Future<ResponsePaginated> getUserData() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceGetData,
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => Profile.fromMap(data));
    return userCode;
  }

  //
  Future<ResponsePaginated> createConfig(
    List qualifications,
  ) async {
    var body = {
      "qualifications": [],
      // "regions": regions.map((e) => e?.toMap()).toList(),
    };

    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceFinishUser,
        body: body,
        typeRequest: TYPEREQUEST.POST,
        funcFromMap: (data) => data);
    return userCode;
  }

  Future<ResponsePaginated> saveUserImage(String img64) async {
    var image = "data:image/png;base64," + img64;
    Map<String, String> body = {"imageBase64": image};
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        typeRequest: TYPEREQUEST.POST,
        serviceName: serviceUserImage,
        body: body,
        funcFromMap: (data) => data);
    return userCode;
  }

  Future<ResponsePaginated> getUserImage() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceUserImage,
        body: {},
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => data['pathImage']);
    return userCode;
  }

  getStatus() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceGetStatus,
        body: {},
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => data);
    return userCode;
  }

  updateStatus(bool isOnlineUser) async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceChangeStatus,
        body: {"isOnline": isOnlineUser},
        typeRequest: TYPEREQUEST.PUT,
        funcFromMap: (data) => data);
    return userCode;
  }

  updateUserDataOnly(Map<String, String> dataElement) async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceGetData,
        body: {"fields": dataElement},
        typeRequest: TYPEREQUEST.PUT,
        funcFromMap: (data) => data);
    return userCode;
  }

  getUserInfo() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceGetInfo,
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => data);
    return userCode;
  }

  Future<ResponsePaginated> sendNotificationMessage(
      String message, Attendance attendance) async {
    var id = attendance?.userClient?.id;

    if (id != null) {
      var result = await _requestManager.requestWithTokenToForm(PROFILE,
          serviceName: sendNotification,
          body: {"receiverId": id, "message": message},
          funcFromMap: (data) => data,
          typeRequest: TYPEREQUEST.POST,
          isObject: true);
      return result;
    } else {
      return null;
    }
  }

  requestTokenSms(username) async {
    var asignature = kIsWeb ? "Web" : await  SmsAutoFill().getAppSignature;
    if(!kIsWeb) {
      await SmsAutoFill().listenForCode;
    }
    var result = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceVerification,
        body: {"telephone": Utils.removeMask(username),      "signature":asignature},
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> sendVerifiCodExists(
      String code, String telephone) async {
    var result = await _requestManager.requestWithTokenToForm(PROFILE,
        serviceName: serviceValidate,
        body: {"SMSToken": code, 'telephone': Utils.removeMask(telephone)},
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PUT,
        isObject: true);
    return result;
  }

//
//  static Future<ResponsePaginated> getUserAddress(BuildContext context) =>
//      UserDataService.getUserAddress(context);
//
//  static changeUser(context, User userDataChangeValue) =>
//      UserDataService.changeUser(context, userDataChangeValue);
}
