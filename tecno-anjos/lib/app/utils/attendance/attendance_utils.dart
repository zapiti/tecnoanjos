import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';

class AttendanceUtils {
  static void goToHome(BuildContext context) {
    AttendanceUtils.pushReplacementNamed(context, ConstantsRoutes.HOMEPAGE);
  }

  static void pushReplacementNamed(BuildContext context, String route,
      {dynamic arguments}) {
    if (route != ConstantsRoutes.CHATTECNOCLIENT) {
      if (context == null) {
        if (Modular?.to?.modulePath != route) {
          Modular.to.pushReplacementNamed(route, arguments: arguments);
        }
      } else {
        try {
          Modular.to.pushReplacementNamed(route, arguments: arguments);
        } catch (E) {
          if (Modular?.to?.modulePath != route) {
            Modular.to.pushReplacementNamed(route, arguments: arguments);
          }
        }
      }
    }
  }

  static void pushNamed(BuildContext context, String route,
      {dynamic arguments}) {
    if (context == null) {
      if (Modular?.to?.modulePath != route) {
        Modular.to.pushNamed(route, arguments: arguments);
      }
    } else {
      try {
        if (ModalRoute.of(context).settings.name != route) {
          Modular.to.pushNamed(route, arguments: arguments);
        }
      } catch (E) {
        if (Modular?.to?.modulePath != route) {
          Modular.to.pushNamed(route, arguments: arguments);
        }
      }
    }
  }
}
