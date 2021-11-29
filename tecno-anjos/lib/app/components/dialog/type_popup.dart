import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TypePopup {
  static show({child, BuildContext context}) {
    if (child != null) {
      try {
        if (context == null) {
          Modular.to.push(PageRouteBuilder(
              pageBuilder: (___, _, __) => Container(
                  color: Colors.black.withOpacity(0.55),
                  child:  Center(
                    child: Container(
                        width: 600,
                        height: 1000,
                        child:
                            Material(color: Colors.transparent, child: child)),
                  )),
              opaque: false));
        } else {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (___, _, __) => Container(
                  color: Colors.black.withOpacity(0.55),
                  child: Center(
                    child: Container(
                        width: 600,
                        height: 1000,
                        child:
                            Material(color: Colors.transparent, child: child)),
                  )),
              opaque: false));
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
