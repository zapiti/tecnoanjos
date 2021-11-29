//import 'package:flutter/material.dart';
//import 'package:flutter_modular/flutter_modular.dart';
//import 'package:tecnoanjostec/app/modules/drawer/drawer_bloc.dart';
//
//import 'constants_routes.dart';
//
//class BackWidget extends StatelessWidget {
//  final Widget child;
//  BackWidget({this.child});
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: () async {
//          var drawerBloc = Modular.get<DrawerBloc>();
//          if (drawerBloc.homeDataStream.value.selectedHome ==
//              ConstantsRoutes.HOMEPAGE) {
//            return true;
//          } else {
//            drawerBloc.setPageActual(ConstantsRoutes.HOMEPAGE, true);
//
//            return false;
//          }
//        },
//        child: child);
//  }
//}
