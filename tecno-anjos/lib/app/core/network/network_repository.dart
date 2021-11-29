

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

import '../request_core.dart';

class NetWorkRepository {

   Future<ResponsePaginated> testeConection () async {
     var _requestManager = Modular.get<RequestCore>();
     var result = await _requestManager.requestWithTokenToForm("att",
         serviceName: "/return-in/3000",
         funcFromMap: (data) => data,
         body: {},
         typeRequest: TYPEREQUEST.GET,
         isObject: true);
     return result;
   }
}