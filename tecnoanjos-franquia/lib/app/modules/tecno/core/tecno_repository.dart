import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjos_franquia/app/core/request_core.dart';
import 'package:tecnoanjos_franquia/app/models/page/response_paginated.dart';
import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';
import 'package:tecnoanjos_franquia/app/utils/object/object_utils.dart';

class TecnoRepository {
  final serviceUser = "/api/profile/user/create";
  final serviceListUser = "/api/franchise/list/user";
  static const serviceGetData = "/api/profile/user";
  static const serviceEditData = "/api/franchise/update/user/";
  static const serviceBlockedFunctionary = "/api/profile/user/updateStatus";
  static const serviceListCitys = "/api/activecity";

  var _requestManager = Modular.get<RequestCore>();
  Future<ResponsePaginated> getListMyFunctionary() async {
    // _getTitleItemWidget(
    //     'Status' ,
    // _getTitleItemWidget('Nome', 200),
    // _getTitleItemWidget('Telefone', 200),
    // _getTitleItemWidget('E-mail', 100),
    // _getTitleItemWidget('CPF', 200),
    // _getTitleItemWidget('Açãoes', 200),

    var user = await _requestManager.requestWithTokenToForm(
        serviceName: serviceListUser,
        body: {},
        typeResponse: TYPERESPONSE.LIST,

        funcFromMap: (data) => Profile.fromMap(data),
        typeRequest: TYPEREQUEST.GET);
    return user;
    // return ResponsePaginated(content: [
    //   Profile(isOnline: true,
    //       name: "Nathan",
    //       telephone: "34991727841",
    //       email: "Nathanranghel53@gmail.com",
    //       cpf: "10839838654"),
    //   Profile(isOnline: false,
    //       name: "Nathan",
    //       telephone: "34991727841",
    //       email: "Nathanranghel53@gmail.com",
    //       cpf: "10839838654"),
    //   Profile(isOnline: true,
    //       name: "Nathan",
    //       telephone: "34991727841",
    //       email: "Nathanranghel53@gmail.com",
    //       cpf: "10839838654")
    // ]);
  }

  createOrUpdate(Profile users) async {
    if(users.id == null){
      var user = await _requestManager.requestWithTokenToForm(
          serviceName: serviceUser,
          body: users.toCreate(),
          typeResponse: TYPERESPONSE.OBJECT,

          funcFromMap: (data) => data ,
          typeRequest: TYPEREQUEST.POST);

      return user;
    }else{
      var user = await _requestManager.requestWithTokenToForm(
          serviceName: serviceEditData+users.id.toString(),
          body: users.toEdit() ,
          typeResponse: TYPERESPONSE.OBJECT,

          funcFromMap: (data) => data ,
        typeRequest: TYPEREQUEST.PATCH);

      return user;
    }

  }

  Future<ResponsePaginated> getListAvaliableAddress()async{
    var user = await _requestManager.requestWithTokenToForm(
        serviceName: serviceListCitys,
        body: {},
        typeResponse: TYPERESPONSE.LIST,

        funcFromMap: (data) => Pairs("${data["cityName"]}-${data["stateName"]}","${data["cityName"]}",third: "${data["stateName"]}",),
        typeRequest: TYPEREQUEST.GET);
    if(user.content != null){
      user.content = ObjectUtils.parseToObjectList<Pairs>(user.content);
    }
    return user;
    // return ResponsePaginated(content: [Pairs("Uberlândia-Minas Gerais","Uberlândia",third: "Minas Gerais",)]);
  }

  blockedFunctionary( {String status, Profile profile}) async {
    var user = await _requestManager.requestWithTokenToForm(
        serviceName: serviceBlockedFunctionary,
        body: {
          "status" : status,
          "userId" : profile.id.toString()
        },
        typeResponse: TYPERESPONSE.OBJECT,
        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.PATCH);
    return user;
  }

}