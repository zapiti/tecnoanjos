import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

class AttendanceUtils {


  static void goToHome(BuildContext context) {


      AttendanceUtils.pushReplacementNamed(context,ConstantsRoutes.HOMEPAGE);

  //  }
  }


  static bool isOnlyPresential(List<ServiceProd> listService){

    final tempList = listService.where((element) => element.type == ServiceProd.PRESENTIAL ).toList();
    if(tempList.isNotEmpty){
      return true;
    }else{
      return false;
    }

  }


  static void pushReplacementNamed(BuildContext context,String route,{dynamic arguments}) {
    if(route != ConstantsRoutes.CHATTECNOCLIENT){
      if(context == null){
        if (Modular?.to?.modulePath != route) {
          Modular.to.pushReplacementNamed(route,arguments:arguments);
        }
      }else{
        try{
          // if(ModalRoute.of(context).settings.name != route){
          //   Modular.to.pushReplacementNamed(route,arguments:arguments);
          // }

          //  if (Modular?.to?.modulePath != route) {
          Modular.to.pushReplacementNamed(route,arguments:arguments);
          //  }
        }catch(E){
          if (Modular?.to?.modulePath != route) {
            Modular.to.pushReplacementNamed(route,arguments:arguments);
          }
        }
      }
    }

  }

  static void pushNamed(BuildContext context,String route,{dynamic arguments}) {
    if(context == null){
      if (Modular?.to?.modulePath != route) {
        Modular.to.pushNamed(route,arguments:arguments);
      }
    }else{
      try{
        if (Modular?.to?.modulePath != route) {
          Modular.to.pushNamed(route,arguments:arguments);
        }else{
          if(ModalRoute.of(context).settings.name == Modular.initialRoute){

          }else {
            if (ModalRoute
                .of(context)
                .settings
                .name != route) {
              Modular.to.pushNamed(route, arguments: arguments);
            }
          }
        }

      }catch(E){
        if (Modular?.to?.modulePath != route) {
          Modular.to.pushNamed(route,arguments:arguments);
        }
      }
    }
  }
}
