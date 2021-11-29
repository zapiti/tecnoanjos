

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjostec/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class CardWebWithTitle extends StatelessWidget {
  final Widget child;
  final Function onInit;
  CardWebWithTitle({this.child,this.onInit});
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          if(onInit != null){
            onInit();
          }

        },
        child: Scaffold(
            body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                  child: Center(
                      child: Card(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        right: 30, left: 30, bottom: 20, top: 30),
                                    child: Text(
                                      ConstantsRoutes.getNameByRoute(
                                          ModalRoute.of(context).settings.name),
                                      style: AppThemeUtils.normalSize(
                                          fontSize: 22, color: AppThemeUtils.colorPrimary),
                                    )),
                                child
                              ]))),
                ))));
  }
}

