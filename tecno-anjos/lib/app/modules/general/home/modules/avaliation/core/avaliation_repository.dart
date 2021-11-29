import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/core/request_core.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/models/total_avaliation.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';

import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/response/response_utils.dart';

class AvaliationRepository {
  static const serviceGetTotal = "/api/avaliation/user/total";
  static const serviceGetListData = "/api/avaliation/listdata";
  static const serviceGetListDataAwait = '/api/avaliation/wait/listdata';

  var _requestManager = Modular.get<RequestCore>();
  static const AVALIATION = "AVALIATION_REPOSITORY";

  Future<ResponsePaginated> getListAvaliationMaker({int page}) async {
    var body =
        ResponseUtils.getBodyPageable(page: page, mapBody: {"filter": "S"});
    var listhours = await _requestManager.requestWithTokenToForm(AVALIATION,
        serviceName: serviceGetListData,
        body: body,
        namedResponse: "content",
        funcFromMap: (data) => Avaliation.fromMap(data, true),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);

    return listhours;
  }

  Future<ResponsePaginated>  getTotalAvaliations() async {
    var listhours = await _requestManager.requestWithTokenToForm(AVALIATION,
        serviceName: serviceGetTotal,
        funcFromMap: (data) => TotalAvaluation.fromMap(data),
        typeRequest: TYPEREQUEST.GET,
        isObject: true);
    return listhours;
  }

  Future<ResponsePaginated>  getListAvaliationReceiver({int page}) async {
    var body = ResponseUtils.getBodyPageable(
        page: page, mapBody: {"filter": ActivityUtils.RECUSADO});
    var listhours = await _requestManager.requestWithTokenToForm(AVALIATION,
        serviceName: serviceGetListData,
        body: body,
        namedResponse: "content",
        funcFromMap: (data) => Avaliation.fromMap(data, false),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);
    return listhours;
  }

  Future<ResponsePaginated> getListAvaliationPendent({int page}) async {
    var elements = await _requestManager.requestWithTokenToForm(AVALIATION,
        serviceName: serviceGetListDataAwait,
        body: {},
        funcFromMap: (data) => Avaliation.fromAttendance(data),
        typeRequest: TYPEREQUEST.POST,
        isObject: false);

    if(elements.content != null){
      try{
        var list = ObjectUtils.parseToObjectList<Avaliation>(elements.content);
        var tempList = list.where((element) => element.attendance.status == ActivityUtils.FINALIZADO).toList();
        elements.content = tempList;
      }catch(e){}

    }

    return elements;
  }
}
