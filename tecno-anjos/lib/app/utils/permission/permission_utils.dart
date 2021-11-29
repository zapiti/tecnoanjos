
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import '../attendance/attendance_utils.dart';

class PermissionUtils {
  static final appBloc = Modular.get<AppBloc>();

  static bool getPermissionByRoute(String route, CurrentUser currentUser) {

    if(route == ConstantsRoutes.CONFIGURACOES){
      return true;
    }else {
      if (currentUser?.role == CurrentUser.MULTIFRANQUISE) {
        return true;
      }
       else if (currentUser?.role == CurrentUser.HOMEBASED) {
        return !route.contains("admin");
      } else if (currentUser?.role == CurrentUser.FUNCIONARY) {
        return !route.contains("admin") && !route.contains("tecno");
      } else {
        return route == ConstantsRoutes.LOGIN;
      }
    }
  }

  static initialRedirect( {bool force = false}) async {

    if( !appBloc.callRedirect.stream.value || force){
      appBloc.callRedirect.sink.add(true);
      var currentUser =  appBloc.getCurrentUserFutureValue().stream.value;

      if(currentUser == null){
        AttendanceUtils.pushReplacementNamed(null,ConstantsRoutes.LOGIN);
      }else{
        if (currentUser?.role == CurrentUser.MULTIFRANQUISE) {

            AttendanceUtils.goToHome(null);

        } else if (currentUser?.role == CurrentUser.FUNCIONARY ||
            currentUser?.role == CurrentUser.OFFICE ||
            currentUser?.role == CurrentUser.QUIOSQUE ||
            currentUser?.role == CurrentUser.HOMEBASED) {
          if(currentUser?.role == CurrentUser.HOMEBASED || currentUser?.role == CurrentUser.FUNCIONARY ){
            AttendanceUtils.goToHome(null);
          }else{
            AttendanceUtils.pushReplacementNamed(null,ConstantsRoutes.LOGIN);
          }

        } else {
          AttendanceUtils.pushReplacementNamed(null,ConstantsRoutes.LOGIN);
        }
      }
    }
  }

  static bool checkPermission(String route , CurrentUser user) {

    return getPermissionByRoute(route,user);
  }
}
