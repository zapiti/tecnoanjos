import 'package:flutter_modular/flutter_modular.dart';
import 'package:flavor/flavor.dart';
import 'package:tecnoanjosclient/app/core/request_core.dart';

import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';

class MyAddressRepository {
  static const serviceGetListData = "/api/profile/client/address/listdata";
  static const serviceSearch = "/api/profile/regionAttendance";
  static const serviceSaveAddress = '/api/profile/client/address/data';
  static const serviceDeleteAddress = '/api/profile/client/address/data';
  var _requestManager = Modular.get<RequestCore>();
  static const ADRESS = "ADRESS_REPOSITORY";
  bool isDelete;

  Future<ResponsePaginated> getListAddress({int page}) async {
    var result = await _requestManager.requestWithTokenToForm(ADRESS,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetListData,
        funcFromMap: (data) => data != null ? MyAddress.fromMap(data) : data,
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    return result;
  }

  // Future<ResponsePaginated> getRegionByName(String search) async {
  //   var result = await _requestManager.requestWithTokenToForm(ADRESS,Flavor.I.getString(Keys.apiUrl),
  //       serviceName: serviceSearch,
  //       body: {"search": search},
  //       typerequest: TYPEREQUEST.POST,
  //       funcFromMap: (data) => RegionAttendance.fromMap(data),
  //       isObject: false);
  //   return result;
  // }

  Future<ResponsePaginated> saveAddress(MyAddress value) async {
    var myAddress = value.toMap();
    if(value?.id == null){
      var result = await _requestManager.requestWithTokenToForm(ADRESS,Flavor.I.getString(Keys.apiUrl),
          serviceName: serviceSaveAddress,
          body: myAddress,
          typeRequest: TYPEREQUEST.POST,
          funcFromMap: (data) => MyAddress.fromMap(data),
          isObject: true);
      return result;
    }else{
      return editAddress(value);
    }


  }

  deleteAddress(MyAddress address) async {
    var myAddress = address.toMap();

    var result = await _requestManager.requestWithTokenToForm(ADRESS,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceDeleteAddress,
        body: myAddress,
        typeRequest: TYPEREQUEST.DELETE,
        funcFromMap: (data) => data,
        isObject: true);
    return result;
  }

  Future<ResponsePaginated> editAddress(MyAddress value) async {
    var myAddress = value.toMap();

    var result = await _requestManager.requestWithTokenToForm(ADRESS,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceSaveAddress,
        body: myAddress,
        typeRequest: TYPEREQUEST.PUT,
        funcFromMap: (data) =>  value,
        isObject: true);
    return result;
  }

 Future<MyAddress> getOneAddress() async {
    var result = await _requestManager.requestWithTokenToForm(ADRESS,Flavor.I.getString(Keys.apiUrl),
        serviceName: serviceGetListData,
        funcFromMap: (data) => data != null ? MyAddress.fromMap(data) : data,
        typeRequest: TYPEREQUEST.GET,
        isObject: false);
    if(result.content == null ){
      return result.content;
    }else{
      return result.content.isEmpty ? null : result.content.first;
    }
  }
}
