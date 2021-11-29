import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';

import '../../../../../../app_bloc.dart';



class ProfileRepository {
  static const serviceAlteration = "/login/dados";
  static const serviceGetData = "/api/profile/user";
  static const serviceGetAddress = "/user/address";
  static const serviceUserImage = "/api/profile/image/user";
  static const serviceGetStatus = "/api/profile/status/status/data";
  static const serviceChangeStatus = "/api/profile/status/status";
  static const serviceFinishUser = '/api/profile/user/finish/data';
  static const serviceGetInfo = '/api/profile/user/getInfo';
  static const sendNotification = "/api/profile/attendance/sendMessage";

  var _requestManager = Modular.get<RequestCore>();

  static const PROFILE = "PROFILE_USER_REPOSITORY";

  Future<ResponsePaginated> sendNotificationMessage(String message,
      Attendance attendance) async {
    var id = attendance?.userTecno?.id;

    if (id != null) {
      //OnsignalNotification().postNotification(id.toString(),message);

      var result = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),
          serviceName: sendNotification,
          body: {"receiverId":id, "message": message},
          funcFromMap: (data) => data,
          typeRequest: TYPEREQUEST.POST,
          isObject: true);
      return result;
    }else{
      return null;
    }
  }

  Future<ResponsePaginated> getUserData() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetData,
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => Profile.fromMap(data));

    if(userCode.content != null){
      final appBloc = Modular.get<AppBloc>();
      final currentUser = CurrentUser.fromMap(userCode.content.toMap());
      appBloc.setCurrent(currentUser);
    }

    return userCode;
  }

  Future<ResponsePaginated> saveUserImage(String img64) async {
    var image = "data:image/png;base64," + img64;
    Map<String, String> body = {"imageBase64": image};
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),typeRequest: TYPEREQUEST.POST,
        serviceName: serviceUserImage, body: body, funcFromMap: (data) => data);
    return userCode;
  }

  Future<ResponsePaginated> getUserImage() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceUserImage,
        body: {},
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => data['pathImage']);
    return userCode;
  }

  getStatus() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetStatus,
        body: {},
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => data);
    return userCode;
  }

  updateStatus(bool isOnlineUser) async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceChangeStatus,
        body: {"isOnline": isOnlineUser},
        typeRequest: TYPEREQUEST.PUT,
        funcFromMap: (data) => data);
    return userCode;
  }

  updateUserDataOnly(Map<String, String> dataElement) async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetData,
        body: {"fields": dataElement},
        typeRequest: TYPEREQUEST.PUT,
        funcFromMap: (data) => data);
    return userCode;
  }

  getUserInfos() async {
    var userCode = await _requestManager.requestWithTokenToForm(PROFILE,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetInfo,
        typeRequest: TYPEREQUEST.GET,
        funcFromMap: (data) => data);
    return userCode;
  }

//
//  static Future<ResponsePaginated> getUserAddress(BuildContext context) =>
//      UserDataService.getUserAddress(context);
//
//  static changeUser(context, User userDataChangeValue) =>
//      UserDataService.changeUser(context, userDataChangeValue);
}
