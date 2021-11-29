


import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ItemSecuritySucess extends StatelessWidget {
  final Attendance attendance;

  ItemSecuritySucess(this.attendance);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: Icon(
              Icons.check_circle_outline,
              size: 100,
              color: AppThemeUtils.colorPrimary,
            ),
            margin: EdgeInsets.all(20),
          ),
          Container(
            child: Text(
              "Seu Tecnoanjo teve a identidade confirmada com sucesso",
              textAlign: TextAlign.center,
              style: AppThemeUtils.normalBoldSize(
                  fontSize: 20, color: AppThemeUtils.colorPrimary),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(

                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          Modular.get<FirebaseClientTecnoanjo>().deleteInLocal(attendance);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: AppThemeUtils.colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0))),
                        child: Container(
                            height: 45,
                            child: Center(
                                child: Text(
                                  "Vamos para o atendimento",
                                  textAlign: TextAlign.center,
                                  style: AppThemeUtils.normalSize(
                                      color: AppThemeUtils.whiteColor),
                                ))),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
