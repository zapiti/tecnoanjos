





import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjostec/app/core/request_core.dart';

import '../../../../../../app_bloc.dart';



class RegistreUserRepository {

  static const  serviceAlterPass = "/api/profile/user/updatePassword";
  static const REGISTRE = "REGISTRE_USER_REPOSITORY";

  var _requestManager = Modular.get<RequestCore>();
  final appBloc = Modular.get<AppBloc>();




  alterMyPass(String actualPass, String confirmPass) async {
    final currentUser =  appBloc.getCurrentUserFutureValue().stream.value;
    var result = await _requestManager.requestWithTokenToForm(REGISTRE,
        serviceName: serviceAlterPass,
        body: {"id":currentUser.id,"oldPassword":actualPass, 'password':confirmPass },

        funcFromMap: (data) => data,
        typeRequest: TYPEREQUEST.POST,
        isObject: true);
    return result;
  }


}
